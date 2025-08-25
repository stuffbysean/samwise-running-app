import Foundation
import CoreLocation

class Run: Identifiable, ObservableObject {
    let id = UUID()
    @Published var title: String
    @Published var targetDistance: Double
    @Published var createdAt: Date
    @Published var shareLink: String?
    @Published var isActive: Bool = false
    @Published var completedAt: Date?
    @Published var actualDistance: Double = 0.0
    @Published var duration: TimeInterval = 0
    
    @Published var messages: [VoiceMessage] = []
    
    init(title: String, targetDistance: Double) {
        self.title = title
        self.targetDistance = targetDistance
        self.createdAt = Date()
    }
}

class VoiceMessage: Identifiable, ObservableObject {
    let id = UUID()
    @Published var serverId: String?  // ID from backend server
    @Published var distanceMarker: Double
    @Published var audioURL: URL?
    @Published var senderName: String
    @Published var message: String?
    @Published var isPlayed: Bool = false
    @Published var createdAt: Date
    
    init(distanceMarker: Double, senderName: String, message: String? = nil) {
        self.distanceMarker = distanceMarker
        self.senderName = senderName
        self.message = message
        self.createdAt = Date()
    }
}

// MARK: - Preview Mock Data
extension Run {
    static func mockRun() -> Run {
        let run = Run(title: "Morning 5K Run", targetDistance: 5.0)
        run.shareLink = "/share/mock-share-id-123"
        run.messages = [
            VoiceMessage.mockMessage1(),
            VoiceMessage.mockMessage2(),
            VoiceMessage.mockMessage3()
        ]
        return run
    }
    
    static func mockActiveRun() -> Run {
        let run = mockRun()
        run.isActive = true
        run.actualDistance = 2.5
        run.duration = 1200 // 20 minutes
        return run
    }
    
    static func mockCompletedRun() -> Run {
        let run = mockRun()
        run.isActive = false
        run.actualDistance = 5.2
        run.duration = 1800 // 30 minutes
        run.completedAt = Date()
        return run
    }
}

extension VoiceMessage {
    static func mockMessage1() -> VoiceMessage {
        let message = VoiceMessage(
            distanceMarker: 1.0,
            senderName: "Mom",
            message: "You're doing great! Keep going!"
        )
        return message
    }
    
    static func mockMessage2() -> VoiceMessage {
        let message = VoiceMessage(
            distanceMarker: 2.5,
            senderName: "Alex",
            message: "Halfway there! You've got this!"
        )
        return message
    }
    
    static func mockMessage3() -> VoiceMessage {
        let message = VoiceMessage(
            distanceMarker: 4.0,
            senderName: "Sam",
            message: "Almost at the finish line! Push through!"
        )
        return message
    }
}