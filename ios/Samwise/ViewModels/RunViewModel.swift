import Foundation
import Combine

@MainActor
class RunViewModel: ObservableObject {
    
    @Published var currentRun: Run?
    @Published var shareLink: String?
    @Published var voiceMessages: [VoiceMessage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRunActive = false
    @Published var runStatus: RunStatus = .notStarted
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    
    enum RunStatus {
        case notStarted
        case created
        case active
        case completed
        
        var displayText: String {
            switch self {
            case .notStarted:
                return "Not Started"
            case .created:
                return "Created"
            case .active:
                return "Active"
            case .completed:
                return "Completed"
            }
        }
    }
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $currentRun
            .map { run in
                guard let run = run else { return .notStarted }
                switch run.isActive {
                case true:
                    return run.completedAt != nil ? .completed : .active
                case false:
                    return run.shareLink != nil ? .created : .notStarted
                }
            }
            .assign(to: &$runStatus)
    }
}

// MARK: - Run Management
extension RunViewModel {
    
    func createRun(title: String, targetDistance: Double) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter a title for your run"
            return
        }
        
        guard targetDistance > 0 else {
            errorMessage = "Distance must be greater than 0"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.createRun(title: title, targetDistance: targetDistance)
                
                let newRun = response.run.toLocalRun()
                newRun.shareLink = response.shareLink
                
                currentRun = newRun
                shareLink = response.shareLink
                isLoading = false
                
                loadVoiceMessages(shareId: response.run.shareId)
                
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func startRun() {
        guard let run = currentRun,
              let shareId = extractShareId(from: run.shareLink) else {
            errorMessage = "No run available to start"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.startRun(shareId: shareId)
                
                currentRun?.isActive = true
                isRunActive = true
                isLoading = false
                
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func completeRun(actualDistance: Double, duration: TimeInterval) {
        guard let run = currentRun,
              let shareId = extractShareId(from: run.shareLink) else {
            errorMessage = "No active run to complete"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.completeRun(
                    shareId: shareId,
                    actualDistance: actualDistance,
                    duration: duration
                )
                
                currentRun?.isActive = false
                currentRun?.completedAt = Date()
                currentRun?.actualDistance = actualDistance
                currentRun?.duration = duration
                
                isRunActive = false
                isLoading = false
                
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func resetRun() {
        currentRun = nil
        shareLink = nil
        voiceMessages = []
        errorMessage = nil
        isRunActive = false
        runStatus = .notStarted
    }
}

// MARK: - Voice Messages
extension RunViewModel {
    
    func loadVoiceMessages(shareId: String) {
        Task {
            do {
                let response = try await apiService.getVoiceMessages(for: shareId)
                
                voiceMessages = response.messages
                    .map { $0.toLocalVoiceMessage() }
                    .sorted { $0.distanceMarker < $1.distanceMarker }
                
            } catch {
                print("Failed to load voice messages: \(error.localizedDescription)")
                errorMessage = "Failed to load voice messages: \(error.localizedDescription)"
            }
        }
    }
    
    func getMessagesForDistance(_ distance: Double) -> [VoiceMessage] {
        return voiceMessages.filter { message in
            !message.isPlayed && distance >= message.distanceMarker
        }
    }
    
    func markMessageAsPlayed(_ message: VoiceMessage) {
        guard let run = currentRun,
              let shareId = extractShareId(from: run.shareLink),
              let serverId = message.serverId,
              let messageIndex = voiceMessages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        
        voiceMessages[messageIndex].isPlayed = true
        
        Task {
            do {
                try await apiService.markMessageAsPlayed(shareId: shareId, messageId: serverId)
            } catch {
                print("Failed to mark message as played: \(error.localizedDescription)")
                voiceMessages[messageIndex].isPlayed = false
            }
        }
    }
    
    func refreshVoiceMessages() {
        guard let run = currentRun,
              let shareId = extractShareId(from: run.shareLink) else {
            return
        }
        
        loadVoiceMessages(shareId: shareId)
    }
}

// MARK: - Utility Functions
extension RunViewModel {
    
    private func extractShareId(from shareLink: String?) -> String? {
        guard let shareLink = shareLink else { return nil }
        
        if shareLink.hasPrefix("/share/") {
            return String(shareLink.dropFirst(7))
        }
        
        if let url = URL(string: shareLink) {
            return url.lastPathComponent
        }
        
        return nil
    }
    
    func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2f km", distance)
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    func shareURL() -> URL? {
        guard let shareLink = shareLink else { return nil }
        
        let baseURL = "https://samwise.app"
        let fullLink = shareLink.hasPrefix("http") ? shareLink : "\(baseURL)\(shareLink)"
        
        return URL(string: fullLink)
    }
}

// MARK: - Preview Mock Data
extension RunViewModel {
    static func mockViewModel() -> RunViewModel {
        let viewModel = RunViewModel()
        viewModel.currentRun = Run.mockRun()
        viewModel.voiceMessages = [
            VoiceMessage.mockMessage1(),
            VoiceMessage.mockMessage2(),
            VoiceMessage.mockMessage3()
        ]
        viewModel.shareLink = "/share/mock-share-id-123"
        viewModel.runStatus = .created
        return viewModel
    }
    
    static func mockActiveViewModel() -> RunViewModel {
        let viewModel = RunViewModel()
        viewModel.currentRun = Run.mockActiveRun()
        viewModel.voiceMessages = [
            VoiceMessage.mockMessage1(),
            VoiceMessage.mockMessage2(),
            VoiceMessage.mockMessage3()
        ]
        viewModel.shareLink = "/share/mock-share-id-123"
        viewModel.runStatus = .active
        viewModel.isRunActive = true
        return viewModel
    }
}