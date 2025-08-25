import SwiftUI
import CoreLocation

struct ActiveRunView: View {
    @ObservedObject var runViewModel: RunViewModel
    @StateObject private var locationManager = LocationManager()
    @StateObject private var audioManager = AudioManager()
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingCompleteAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerSection
                
                Spacer()
                
                statsSection
                
                Spacer()
                
                if !locationManager.isTracking {
                    startRunSection
                } else {
                    activeRunSection
                }
                
                Spacer()
                
                if !runViewModel.voiceMessages.isEmpty {
                    messagesSection
                }
            }
            .padding()
        }
        .navigationTitle("Active Run")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(locationManager.isTracking)
        .onAppear {
            setupLocationManager()
        }
        .onDisappear {
            stopTimer()
            audioManager.stopPlayback()
        }
        .alert("Complete Run?", isPresented: $showingCompleteAlert) {
            Button("Continue") { }
            Button("Complete") {
                completeRun()
            }
        } message: {
            Text("Are you sure you want to complete this run? This action cannot be undone.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            if let run = runViewModel.currentRun {
                Text(run.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Target: \(runViewModel.formatDistance(run.targetDistance))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var statsSection: some View {
        VStack(spacing: 24) {
            HStack(spacing: 20) {
                SamwiseStatsCard(
                    title: "Distance",
                    value: runViewModel.formatDistance(locationManager.totalDistance),
                    subtitle: nil,
                    icon: "location",
                    color: .samwiseProgress
                )
                
                SamwiseStatsCard(
                    title: "Duration",
                    value: runViewModel.formatDuration(elapsedTime),
                    subtitle: nil,
                    icon: "clock",
                    color: .samwiseProgress
                )
            }
            
            HStack(spacing: 20) {
                SamwiseStatsCard(
                    title: "Pace",
                    value: currentPace,
                    subtitle: nil,
                    icon: "speedometer",
                    color: .samwiseSecondary
                )
                
                SamwiseStatsCard(
                    title: "Messages",
                    value: "\(playedMessagesCount)/\(runViewModel.voiceMessages.count)",
                    subtitle: nil,
                    icon: "message",
                    color: .samwiseVoice
                )
            }
        }
    }
    
    
    private var startRunSection: some View {
        VStack(spacing: 16) {
            Text("Ready to start your run?")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("Make sure location permissions are enabled to track your distance.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            SamwiseButton(
                "Start Run",
                icon: "play.circle.fill",
                type: .primary,
                size: .large,
                isEnabled: locationManager.authorizationStatus == .authorizedWhenInUse || 
                          locationManager.authorizationStatus == .authorizedAlways,
                action: startRun
            )
            
            if locationManager.authorizationStatus == .denied {
                Text("Location access is required. Please enable in Settings.")
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var activeRunSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                SamwiseButton(
                    "Complete",
                    icon: "stop.circle.fill",
                    type: .destructive,
                    size: .large,
                    action: { showingCompleteAlert = true }
                )
            }
            
            if let run = runViewModel.currentRun {
                progressBar(current: locationManager.totalDistance, target: run.targetDistance)
            }
        }
    }
    
    private func progressBar(current: Double, target: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int((current / target) * 100))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.samwiseProgress)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 8)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    Rectangle()
                        .fill(Color.samwiseProgress)
                        .frame(width: geometry.size.width * min(current / target, 1.0), height: 8)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .animation(.easeInOut(duration: 0.3), value: current)
                }
            }
            .frame(height: 8)
        }
    }
    
    private var messagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Messages")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(upcomingMessages.prefix(5)) { message in
                        upcomingMessageCard(message)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
    
    private func upcomingMessageCard(_ message: VoiceMessage) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(message.senderName)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                if message.isPlayed {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.samwiseSystemSuccess)
                }
            }
            
            Text("at \(runViewModel.formatDistance(message.distanceMarker))")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            if let messageText = message.message {
                Text(messageText)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
        }
        .padding(8)
        .frame(width: 120)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(message.isPlayed ? Color(.systemGray5) : Color.samwiseVoice.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(message.isPlayed ? Color.clear : Color.samwiseVoice.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var currentPace: String {
        guard elapsedTime > 0 && locationManager.totalDistance > 0 else {
            return "--:--"
        }
        
        let paceSecondsPerKm = elapsedTime / locationManager.totalDistance
        let minutes = Int(paceSecondsPerKm) / 60
        let seconds = Int(paceSecondsPerKm) % 60
        
        return String(format: "%d:%02d/km", minutes, seconds)
    }
    
    private var playedMessagesCount: Int {
        runViewModel.voiceMessages.filter { $0.isPlayed }.count
    }
    
    private var upcomingMessages: [VoiceMessage] {
        runViewModel.voiceMessages.sorted { $0.distanceMarker < $1.distanceMarker }
    }
    
    private func setupLocationManager() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestPermission()
        }
    }
    
    private func startRun() {
        locationManager.startTracking()
        startTime = Date()
        startTimer()
        runViewModel.startRun()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = startTime {
                elapsedTime = Date().timeIntervalSince(startTime)
                checkForTriggeredMessages()
                
                // Refresh voice messages every 30 seconds to get new messages from friends
                if Int(elapsedTime) % 30 == 0 {
                    runViewModel.refreshVoiceMessages()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkForTriggeredMessages() {
        let currentDistance = locationManager.totalDistance
        let messagesToPlay = runViewModel.getMessagesForDistance(currentDistance)
        
        for message in messagesToPlay {
            playMessage(message)
            runViewModel.markMessageAsPlayed(message)
        }
    }
    
    private func playMessage(_ message: VoiceMessage) {
        audioManager.playMessage(message) { success in
            if success {
                print("Successfully played message from \(message.senderName)")
            } else {
                print("Failed to play message from \(message.senderName)")
            }
        }
    }
    
    private func completeRun() {
        locationManager.stopTracking()
        stopTimer()
        
        runViewModel.completeRun(
            actualDistance: locationManager.totalDistance,
            duration: elapsedTime
        )
        
        dismiss()
    }
}

#Preview("Ready to Start") {
    let viewModel = RunViewModel.mockViewModel()
    ActiveRunView(runViewModel: viewModel)
}

#Preview("Active Run") {
    let viewModel = RunViewModel.mockActiveViewModel()
    ActiveRunView(runViewModel: viewModel)
}