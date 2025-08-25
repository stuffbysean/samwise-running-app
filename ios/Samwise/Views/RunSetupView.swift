import SwiftUI

struct RunSetupView: View {
    @StateObject private var runViewModel = RunViewModel()
    @State private var runTitle = ""
    @State private var targetDistance = ""
    @State private var showingShareSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    if runViewModel.currentRun == nil {
                        setupFormSection
                    } else {
                        runCreatedSection
                    }
                    
                    if runViewModel.isLoading {
                        loadingSection
                    }
                    
                    if let errorMessage = runViewModel.errorMessage {
                        errorSection(errorMessage)
                    }
                }
                .padding()
            }
            .navigationTitle("Create Run")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if runViewModel.currentRun != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ActiveRunView(runViewModel: runViewModel)) {
                            Text("Start Run")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let shareURL = runViewModel.shareURL() {
                ActivityViewController(activityItems: [shareURL])
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.samwisePrimary)
            
            Text("Set up your run and share with friends to receive encouraging voice messages!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
    
    private var setupFormSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Run Title")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("e.g., Morning 5K, Marathon Training", text: $runTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .disableAutocorrection(false)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Target Distance")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    TextField("0.0", text: $targetDistance)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    Text("km")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                }
            }
            
            SamwiseButton(
                "Create Run",
                icon: "plus.circle.fill",
                type: .primary,
                size: .large,
                isEnabled: !runTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
                           !targetDistance.isEmpty && 
                           !runViewModel.isLoading,
                isLoading: runViewModel.isLoading,
                action: createRun
            )
        }
        .padding(.horizontal)
    }
    
    private var runCreatedSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.samwiseSystemSuccess)
                
                Text("Run Created!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Share this link with friends so they can record encouraging voice messages for your run.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            if let run = runViewModel.currentRun {
                runDetailsCard(run)
            }
            
            shareSection
            
            if !runViewModel.voiceMessages.isEmpty {
                messagesPreviewSection
            }
        }
        .padding(.horizontal)
    }
    
    private func runDetailsCard(_ run: Run) -> some View {
        SamwiseRunCard(
            run: RunCardData(
                title: run.title,
                targetDistance: run.targetDistance,
                status: mapToCardStatus(runViewModel.runStatus),
                messageCount: runViewModel.voiceMessages.count,
                createdAt: run.createdAt,
                duration: nil
            ),
            onTap: nil
        )
    }
    
    private func mapToCardStatus(_ status: RunViewModel.RunStatus) -> SamwiseStatusBadge.Status {
        switch status {
        case .created: return .created
        case .active: return .active
        case .completed: return .completed
        default: return .created
        }
    }
    
    
    private var shareSection: some View {
        VStack(spacing: 12) {
            Text("Share with Friends")
                .font(.headline)
                .fontWeight(.semibold)
            
            SamwiseButton(
                "Share Link",
                icon: "square.and.arrow.up",
                type: .secondary,
                size: .large,
                action: { showingShareSheet = true }
            )
            
            Text("Friends can use this link to record voice messages that will play at specific distances during your run.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
    
    private var messagesPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Voice Messages")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(runViewModel.voiceMessages.count)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Circle()
                            .fill(Color.samwiseVoice)
                    )
                    .foregroundColor(.white)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(runViewModel.voiceMessages.prefix(3)) { message in
                    messagePreviewCard(message)
                }
                
                if runViewModel.voiceMessages.count > 3 {
                    Text("+ \(runViewModel.voiceMessages.count - 3) more messages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    private func messagePreviewCard(_ message: VoiceMessage) -> some View {
        SamwiseMessageCard(
            message: MessageCardData(
                senderName: message.senderName,
                distanceMarker: message.distanceMarker,
                text: message.message,
                hasAudio: message.audioURL != nil,
                isPlayed: message.isPlayed,
                createdAt: message.createdAt
            ),
            onTap: nil,
            onPlay: nil
        )
    }
    
    private var loadingSection: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Creating your run...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private func errorSection(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.red.opacity(0.1))
        )
    }
    
    private func createRun() {
        guard let distance = Double(targetDistance.replacingOccurrences(of: ",", with: ".")) else {
            runViewModel.errorMessage = "Please enter a valid distance"
            return
        }
        
        runViewModel.createRun(title: runTitle.trimmingCharacters(in: .whitespacesAndNewlines), 
                             targetDistance: distance)
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview("Empty Setup") {
    RunSetupView()
}

#Preview("Run Created") {
    RunSetupView()
}