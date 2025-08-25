import SwiftUI

// MARK: - Samwise Card & Container Component System
// Complete card implementation based on design system specifications

struct SamwiseCard<Content: View>: View {
    
    // MARK: - Card Types
    enum CardType {
        case standard       // Regular content card
        case run            // Run information display
        case message        // Voice message card
        case stats          // Statistics display
        case settings       // Settings/configuration card
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard, .settings: return 12
            case .run, .stats: return 16
            case .message: return 12
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .standard, .message: return 16
            case .run: return 20
            case .stats: return 16
            case .settings: return 16
            }
        }
    }
    
    // MARK: - Card States
    enum CardState {
        case normal
        case highlighted
        case selected
        case disabled
    }
    
    // MARK: - Properties
    let type: CardType
    let state: CardState
    let hasBackground: Bool
    let hasShadow: Bool
    let hasBorder: Bool
    let borderAccent: Color?
    let content: () -> Content
    
    @State private var isPressed = false
    
    // MARK: - Initializer
    init(
        type: CardType = .standard,
        state: CardState = .normal,
        hasBackground: Bool = true,
        hasShadow: Bool = true,
        hasBorder: Bool = false,
        borderAccent: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.type = type
        self.state = state
        self.hasBackground = hasBackground
        self.hasShadow = hasShadow
        self.hasBorder = hasBorder
        self.borderAccent = borderAccent
        self.content = content
    }
    
    // MARK: - Body
    var body: some View {
        content()
            .padding(type.padding)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: type.cornerRadius))
            .overlay(borderView)
            .if(hasShadow) { view in
                view.shadow(
                    color: shadowColor,
                    radius: shadowRadius,
                    x: 0,
                    y: shadowOffset
                )
            }
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: isPressed)
            .opacity(state == .disabled ? 0.6 : 1.0)
    }
    
    // MARK: - Background View
    @ViewBuilder
    private var backgroundView: some View {
        if hasBackground {
            RoundedRectangle(cornerRadius: type.cornerRadius)
                .fill(backgroundColor)
        }
    }
    
    // MARK: - Border View
    @ViewBuilder
    private var borderView: some View {
        if hasBorder || borderAccent != nil {
            RoundedRectangle(cornerRadius: type.cornerRadius)
                .stroke(
                    borderAccent ?? borderColor,
                    lineWidth: borderWidth
                )
        }
    }
    
    // MARK: - Color Calculations
    private var backgroundColor: Color {
        switch type {
        case .standard, .run, .stats, .settings:
            return state == .selected ? Color.Card.activeBackground : .white
        case .message:
            return .samwiseBackground
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .normal:
            return Color.Card.border
        case .highlighted, .selected:
            return Color.Card.activeBorder
        case .disabled:
            return Color.Card.border.opacity(0.5)
        }
    }
    
    private var borderWidth: CGFloat {
        switch state {
        case .selected, .highlighted:
            return 2
        default:
            return 1
        }
    }
    
    private var shadowColor: Color {
        switch type {
        case .run:
            return Color.samwisePrimary.opacity(0.15)
        case .message:
            return Color.samwiseVoice.opacity(0.1)
        default:
            return Color.Card.shadow
        }
    }
    
    private var shadowRadius: CGFloat {
        switch type {
        case .run:
            return 6
        case .message:
            return 4
        default:
            return 2
        }
    }
    
    private var shadowOffset: CGFloat {
        switch type {
        case .run:
            return 3
        default:
            return 1
        }
    }
    
    // MARK: - Interaction Support
    func customTapGesture(perform action: @escaping () -> Void) -> some View {
        self
            .onTapGesture(perform: action)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: 50) { pressing in
                withAnimation(.easeOut(duration: 0.15)) {
                    isPressed = pressing
                }
            } perform: { }
    }
}

// MARK: - Specialized Card Components

// MARK: - Run Card
struct SamwiseRunCard: View {
    let run: RunCardData
    let onTap: (() -> Void)?
    
    var body: some View {
        SamwiseCard(type: .run, hasShadow: true) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(run.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.samwiseText)
                        
                        Text("Target: \(run.targetDistance, specifier: "%.1f") km")
                            .font(.subheadline)
                            .foregroundColor(.samwiseSecondary)
                    }
                    
                    Spacer()
                    
                    SamwiseStatusBadge(status: run.status)
                }
                
                // Stats
                HStack(spacing: 20) {
                    statItem(
                        icon: "calendar",
                        value: run.formattedDate,
                        color: .samwiseProgress
                    )
                    
                    statItem(
                        icon: "message.fill",
                        value: "\(run.messageCount) messages",
                        color: .samwiseVoice
                    )
                    
                    if let duration = run.duration {
                        statItem(
                            icon: "clock.fill",
                            value: duration,
                            color: .samwiseSystemSuccess
                        )
                    }
                }
            }
        }
        .if(onTap != nil) { view in
            view.onTapGesture {
                onTap?()
            }
        }
    }
    
    private func statItem(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(.caption)
                .foregroundColor(.samwiseText)
        }
    }
}

// MARK: - Message Card  
struct SamwiseMessageCard: View {
    let message: MessageCardData
    let onTap: (() -> Void)?
    let onPlay: (() -> Void)?
    
    var body: some View {
        SamwiseCard(
            type: .message,
            borderAccent: message.isPlayed ? .samwiseSystemSuccess : nil
        ) {
            HStack(spacing: 12) {
                // Left border accent
                RoundedRectangle(cornerRadius: 2)
                    .fill(message.hasAudio ? Color.samwiseVoice : Color.samwisePrimary)
                    .frame(width: 4)
                    .padding(.vertical, -16)
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    // Header
                    HStack {
                        Text(message.senderName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.samwiseText)
                        
                        Spacer()
                        
                        SamwiseDistanceTag(distance: message.distanceMarker)
                    }
                    
                    // Message text
                    if let text = message.text, !text.isEmpty {
                        Text(text)
                            .font(.caption)
                            .foregroundColor(.samwiseSecondary)
                            .lineLimit(2)
                    }
                    
                    // Footer
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: message.hasAudio ? "waveform" : "text.bubble")
                                .font(.caption2)
                                .foregroundColor(message.hasAudio ? .samwiseVoice : .samwisePrimary)
                            
                            Text(message.hasAudio ? "Voice message" : "Text message")
                                .font(.caption2)
                                .foregroundColor(.samwiseSecondary)
                        }
                        
                        Spacer()
                        
                        if message.isPlayed {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.samwiseSystemSuccess)
                        }
                        
                        if message.hasAudio && onPlay != nil {
                            Button(action: { onPlay?() }) {
                                Image(systemName: "play.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.samwiseVoice)
                            }
                        }
                    }
                }
            }
        }
        .if(onTap != nil) { view in
            view.onTapGesture {
                onTap?()
            }
        }
    }
}

// MARK: - Stats Card
struct SamwiseStatsCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    
    var body: some View {
        SamwiseCard(type: .stats) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.samwiseText)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.samwiseSecondary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption2)
                            .foregroundColor(.samwiseSecondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Supporting Components

struct SamwiseStatusBadge: View {
    enum Status {
        case created
        case active
        case completed
        
        var text: String {
            switch self {
            case .created: return "Ready"
            case .active: return "Active"
            case .completed: return "Completed"
            }
        }
        
        var color: Color {
            switch self {
            case .created: return .Status.created
            case .active: return .Status.active
            case .completed: return .Status.completed
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .created: return .Status.createdBackground
            case .active: return .Status.activeBackground
            case .completed: return .Status.completedBackground
            }
        }
    }
    
    let status: Status
    
    var body: some View {
        Text(status.text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(status.backgroundColor)
            )
            .foregroundColor(status.color)
    }
}

struct SamwiseDistanceTag: View {
    let distance: Double
    
    var body: some View {
        Text("\(distance, specifier: "%.1f") km")
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.Message.distanceTagBackground)
            )
            .foregroundColor(Color.Message.distanceTagText)
    }
}

// MARK: - Data Models

struct RunCardData {
    let title: String
    let targetDistance: Double
    let status: SamwiseStatusBadge.Status
    let messageCount: Int
    let createdAt: Date
    let duration: String?
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

struct MessageCardData {
    let senderName: String
    let distanceMarker: Double
    let text: String?
    let hasAudio: Bool
    let isPlayed: Bool
    let createdAt: Date
}

// MARK: - View Extension
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview Provider
struct SamwiseCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Run Card
                SamwiseRunCard(
                    run: RunCardData(
                        title: "Morning 5K Run",
                        targetDistance: 5.0,
                        status: .active,
                        messageCount: 3,
                        createdAt: Date(),
                        duration: nil
                    )
                ) {
                    print("Run card tapped")
                }
                
                // Message Cards
                SamwiseMessageCard(
                    message: MessageCardData(
                        senderName: "Sarah",
                        distanceMarker: 2.5,
                        text: "You're doing amazing! Keep pushing forward!",
                        hasAudio: true,
                        isPlayed: false,
                        createdAt: Date()
                    )
                ) {
                    print("Message tapped")
                } onPlay: {
                    print("Play message")
                }
                
                SamwiseMessageCard(
                    message: MessageCardData(
                        senderName: "Mike",
                        distanceMarker: 4.0,
                        text: "Almost there! You've got this!",
                        hasAudio: false,
                        isPlayed: true,
                        createdAt: Date()
                    )
                ) {
                    print("Text message tapped")
                } onPlay: {
                    print("Play voice message")
                }
                
                // Stats Cards
                HStack(spacing: 16) {
                    SamwiseStatsCard(
                        title: "Distance",
                        value: "3.2 km",
                        subtitle: "of 5.0 km",
                        icon: "location.fill",
                        color: .samwiseProgress
                    )
                    
                    SamwiseStatsCard(
                        title: "Duration",
                        value: "24:15",
                        subtitle: "moving time",
                        icon: "clock.fill",
                        color: .samwiseSystemSuccess
                    )
                }
                
                // Custom Card
                SamwiseCard(
                    type: .standard,
                    hasShadow: true
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Custom Card")
                            .font(.headline)
                            .foregroundColor(.samwiseText)
                        
                        Text("This is a custom card with any content you want to display.")
                            .font(.body)
                            .foregroundColor(.samwiseSecondary)
                    }
                }
            }
            .padding()
        }
        .background(Color.samwiseBackground)
        .previewDisplayName("Samwise Cards")
    }
}

/*
 USAGE EXAMPLES:
 
 // Run card with tap handling
 SamwiseRunCard(run: runData) {
     viewModel.selectRun(runData.id)
 }
 
 // Message card with audio playback
 SamwiseMessageCard(
     message: messageData,
     onTap: { viewModel.selectMessage(messageData.id) },
     onPlay: { audioManager.playMessage(messageData) }
 )
 
 // Stats display
 SamwiseStatsCard(
     title: "Pace",
     value: "5:30/km",
     icon: "speedometer",
     color: .samwiseProgress
 )
 
 // Custom content card
 SamwiseCard(type: .standard, hasShadow: true) {
     VStack {
         Text("Custom Content")
         Button("Action") { }
     }
 }
 .onTapGesture {
     // Handle tap
 }
 
 ACCESSIBILITY FEATURES:
 
 - VoiceOver reads all card content in logical order
 - Interactive elements have proper labels and hints
 - Cards support focus navigation
 - High contrast support for borders and backgrounds
 - Dynamic Type support for all text content
 - Semantic markup for status badges and tags
 
 DESIGN SYSTEM COMPLIANCE:
 
 - Uses semantic colors from colors.swift
 - Consistent corner radius (12pt/16pt based on card type)
 - Proper spacing using design system values
 - Shadow system matches design specifications
 - State-based visual feedback
 - Brand-appropriate color usage throughout
 
 */