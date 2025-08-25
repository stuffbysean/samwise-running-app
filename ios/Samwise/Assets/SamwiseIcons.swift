import SwiftUI

// MARK: - Samwise Iconography System
// Complete icon system based on design system specifications with accessibility

struct SamwiseIcons {
    
    // MARK: - Core App Icons
    struct Navigation {
        /// Home tab icon - house.fill
        static let home = SamwiseIcon(
            name: "house.fill",
            category: .navigation,
            accessibilityLabel: "Home",
            description: "Navigate to home screen with runs overview"
        )
        
        /// Create tab icon - plus.circle.fill
        static let create = SamwiseIcon(
            name: "plus.circle.fill",
            category: .navigation,
            accessibilityLabel: "Create",
            description: "Create a new run"
        )
        
        /// History tab icon - clock.arrow.circlepath
        static let history = SamwiseIcon(
            name: "clock.arrow.circlepath",
            category: .navigation,
            accessibilityLabel: "History",
            description: "View past runs and statistics"
        )
        
        /// Settings tab icon - gearshape.fill
        static let settings = SamwiseIcon(
            name: "gearshape.fill",
            category: .navigation,
            accessibilityLabel: "Settings",
            description: "App settings and preferences"
        )
    }
    
    // MARK: - Action Icons
    struct Actions {
        /// Play/Start action - play.circle.fill
        static let play = SamwiseIcon(
            name: "play.circle.fill",
            category: .action,
            accessibilityLabel: "Start",
            description: "Start run or play message"
        )
        
        /// Stop action - stop.circle.fill
        static let stop = SamwiseIcon(
            name: "stop.circle.fill",
            category: .action,
            accessibilityLabel: "Stop",
            description: "Stop current activity"
        )
        
        /// Pause action - pause.circle.fill
        static let pause = SamwiseIcon(
            name: "pause.circle.fill",
            category: .action,
            accessibilityLabel: "Pause",
            description: "Pause current activity"
        )
        
        /// Share action - square.and.arrow.up
        static let share = SamwiseIcon(
            name: "square.and.arrow.up",
            category: .action,
            accessibilityLabel: "Share",
            description: "Share run with friends"
        )
        
        /// Delete action - trash.fill
        static let delete = SamwiseIcon(
            name: "trash.fill",
            category: .action,
            accessibilityLabel: "Delete",
            description: "Delete item"
        )
        
        /// Edit action - pencil
        static let edit = SamwiseIcon(
            name: "pencil",
            category: .action,
            accessibilityLabel: "Edit",
            description: "Edit item details"
        )
        
        /// Cancel/Close action - xmark
        static let close = SamwiseIcon(
            name: "xmark",
            category: .action,
            accessibilityLabel: "Close",
            description: "Close or cancel"
        )
        
        /// Checkmark - checkmark.circle.fill
        static let checkmark = SamwiseIcon(
            name: "checkmark.circle.fill",
            category: .action,
            accessibilityLabel: "Complete",
            description: "Completed or successful"
        )
    }
    
    // MARK: - Audio & Voice Icons
    struct Audio {
        /// Voice/Microphone - mic.fill
        static let microphone = SamwiseIcon(
            name: "mic.fill",
            category: .audio,
            accessibilityLabel: "Voice message",
            description: "Record or play voice message"
        )
        
        /// Audio waveform - waveform
        static let waveform = SamwiseIcon(
            name: "waveform",
            category: .audio,
            accessibilityLabel: "Audio waveform",
            description: "Voice message visualization"
        )
        
        /// Speaker - speaker.wave.2.fill
        static let speaker = SamwiseIcon(
            name: "speaker.wave.2.fill",
            category: .audio,
            accessibilityLabel: "Audio playback",
            description: "Audio is playing"
        )
        
        /// Muted speaker - speaker.slash.fill
        static let speakerMuted = SamwiseIcon(
            name: "speaker.slash.fill",
            category: .audio,
            accessibilityLabel: "Audio muted",
            description: "Audio is muted"
        )
        
        /// Headphones - headphones
        static let headphones = SamwiseIcon(
            name: "headphones",
            category: .audio,
            accessibilityLabel: "Headphones",
            description: "Audio output to headphones"
        )
    }
    
    // MARK: - Running & Fitness Icons
    struct Running {
        /// Running figure - figure.run
        static let runner = SamwiseIcon(
            name: "figure.run",
            category: .running,
            accessibilityLabel: "Running",
            description: "Running activity or runner"
        )
        
        /// Location/GPS - location.fill
        static let location = SamwiseIcon(
            name: "location.fill",
            category: .running,
            accessibilityLabel: "Location",
            description: "GPS location or distance marker"
        )
        
        /// Route/Path - map
        static let route = SamwiseIcon(
            name: "map",
            category: .running,
            accessibilityLabel: "Route",
            description: "Running route or path"
        )
        
        /// Stopwatch - stopwatch.fill
        static let stopwatch = SamwiseIcon(
            name: "stopwatch.fill",
            category: .running,
            accessibilityLabel: "Timer",
            description: "Run duration timing"
        )
        
        /// Speedometer - speedometer
        static let pace = SamwiseIcon(
            name: "speedometer",
            category: .running,
            accessibilityLabel: "Pace",
            description: "Running pace indicator"
        )
        
        /// Heart rate - heart.fill
        static let heartRate = SamwiseIcon(
            name: "heart.fill",
            category: .running,
            accessibilityLabel: "Heart rate",
            description: "Heart rate monitoring"
        )
    }
    
    // MARK: - Social & People Icons
    struct Social {
        /// Friends/People - person.2.fill
        static let friends = SamwiseIcon(
            name: "person.2.fill",
            category: .social,
            accessibilityLabel: "Friends",
            description: "Friends or supporters"
        )
        
        /// Single person - person.circle.fill
        static let person = SamwiseIcon(
            name: "person.circle.fill",
            category: .social,
            accessibilityLabel: "Person",
            description: "Individual person or profile"
        )
        
        /// Message - message.fill
        static let message = SamwiseIcon(
            name: "message.fill",
            category: .social,
            accessibilityLabel: "Message",
            description: "Text or voice message"
        )
        
        /// Text bubble - text.bubble
        static let textBubble = SamwiseIcon(
            name: "text.bubble",
            category: .social,
            accessibilityLabel: "Text message",
            description: "Text message bubble"
        )
        
        /// Notification - bell.fill
        static let notification = SamwiseIcon(
            name: "bell.fill",
            category: .social,
            accessibilityLabel: "Notification",
            description: "Notification or alert"
        )
    }
    
    // MARK: - System & Interface Icons
    struct System {
        /// Information - info.circle.fill
        static let info = SamwiseIcon(
            name: "info.circle.fill",
            category: .system,
            accessibilityLabel: "Information",
            description: "Additional information available"
        )
        
        /// Warning - exclamationmark.triangle.fill
        static let warning = SamwiseIcon(
            name: "exclamationmark.triangle.fill",
            category: .system,
            accessibilityLabel: "Warning",
            description: "Warning or attention needed"
        )
        
        /// Error - exclamationmark.circle.fill
        static let error = SamwiseIcon(
            name: "exclamationmark.circle.fill",
            category: .system,
            accessibilityLabel: "Error",
            description: "Error occurred"
        )
        
        /// Calendar - calendar
        static let calendar = SamwiseIcon(
            name: "calendar",
            category: .system,
            accessibilityLabel: "Calendar",
            description: "Date or schedule"
        )
        
        /// Clock - clock.fill
        static let clock = SamwiseIcon(
            name: "clock.fill",
            category: .system,
            accessibilityLabel: "Time",
            description: "Time or duration"
        )
        
        /// Eye (visibility) - eye.fill
        static let eye = SamwiseIcon(
            name: "eye.fill",
            category: .system,
            accessibilityLabel: "Show",
            description: "Show or make visible"
        )
        
        /// Eye slash (hidden) - eye.slash.fill
        static let eyeSlash = SamwiseIcon(
            name: "eye.slash.fill",
            category: .system,
            accessibilityLabel: "Hide",
            description: "Hide or make invisible"
        )
    }
    
    // MARK: - Statistics Icons
    struct Stats {
        /// Chart/Statistics - chart.bar.fill
        static let chart = SamwiseIcon(
            name: "chart.bar.fill",
            category: .stats,
            accessibilityLabel: "Statistics",
            description: "Statistical data or charts"
        )
        
        /// Trending up - arrow.up.right.circle.fill
        static let trendingUp = SamwiseIcon(
            name: "arrow.up.right.circle.fill",
            category: .stats,
            accessibilityLabel: "Improving",
            description: "Trending upward or improving"
        )
        
        /// Medal/Achievement - medal.fill
        static let achievement = SamwiseIcon(
            name: "medal.fill",
            category: .stats,
            accessibilityLabel: "Achievement",
            description: "Achievement or milestone"
        )
        
        /// Target - target
        static let target = SamwiseIcon(
            name: "target",
            category: .stats,
            accessibilityLabel: "Goal",
            description: "Target or goal"
        )
    }
}

// MARK: - Icon Model
struct SamwiseIcon {
    let name: String
    let category: IconCategory
    let accessibilityLabel: String
    let description: String
    
    enum IconCategory {
        case navigation
        case action
        case audio
        case running
        case social
        case system
        case stats
        
        var semanticColor: Color {
            switch self {
            case .navigation:
                return .samwisePrimary
            case .action:
                return .samwiseSecondary
            case .audio:
                return .samwiseVoice
            case .running:
                return .samwiseProgress
            case .social:
                return .samwiseVoice
            case .system:
                return .samwiseSecondary
            case .stats:
                return .samwiseSystemSuccess
            }
        }
    }
}

// MARK: - Icon View Component
struct SamwiseIconView: View {
    let icon: SamwiseIcon
    let size: IconSize
    let color: Color?
    let useSemanticColor: Bool
    
    enum IconSize {
        case small      // 16pt
        case regular    // 24pt (baseline)
        case large      // 32pt
        case xlarge     // 48pt
        
        var points: CGFloat {
            switch self {
            case .small: return 16
            case .regular: return 24
            case .large: return 32
            case .xlarge: return 48
            }
        }
        
        var weight: Font.Weight {
            switch self {
            case .small: return .regular
            case .regular: return .medium
            case .large: return .semibold
            case .xlarge: return .bold
            }
        }
    }
    
    init(
        _ icon: SamwiseIcon,
        size: IconSize = .regular,
        color: Color? = nil,
        useSemanticColor: Bool = true
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.useSemanticColor = useSemanticColor
    }
    
    var body: some View {
        Image(systemName: icon.name)
            .font(.system(size: size.points, weight: size.weight))
            .foregroundColor(displayColor)
            .accessibilityLabel(icon.accessibilityLabel)
            .accessibilityHint(icon.description)
    }
    
    private var displayColor: Color {
        if let color = color {
            return color
        } else if useSemanticColor {
            return icon.category.semanticColor
        } else {
            return .primary
        }
    }
}

// MARK: - Icon Button Component
struct SamwiseIconButton: View {
    let icon: SamwiseIcon
    let size: SamwiseIconView.IconSize
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case plain
        case circular
        case rounded
        
        var backgroundColor: Color {
            switch self {
            case .plain:
                return .clear
            case .circular, .rounded:
                return Color.Button.secondaryBackground
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .plain:
                return 0
            case .circular:
                return 22 // Half of 44pt touch target
            case .rounded:
                return 8
            }
        }
    }
    
    init(
        _ icon: SamwiseIcon,
        size: SamwiseIconView.IconSize = .regular,
        style: ButtonStyle = .plain,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            SamwiseIconView(icon, size: size)
                .frame(
                    minWidth: .Navigation.touchTarget,
                    minHeight: .Navigation.touchTarget
                )
                .background(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .fill(style.backgroundColor)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement()
        .accessibilityLabel(icon.accessibilityLabel)
        .accessibilityHint(icon.description)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Icon Grid (for documentation/reference)
struct SamwiseIconGrid: View {
    let category: SamwiseIcon.IconCategory?
    let columns: [GridItem]
    
    init(category: SamwiseIcon.IconCategory? = nil, columnCount: Int = 4) {
        self.category = category
        self.columns = Array(repeating: GridItem(.flexible()), count: columnCount)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredIcons, id: \.name) { icon in
                    VStack(spacing: 8) {
                        SamwiseIconView(icon, size: .large)
                        
                        Text(icon.name)
                            .font(.caption2)
                            .foregroundColor(.samwiseSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 80)
                }
            }
            .padding()
        }
        .navigationTitle(category?.title ?? "All Icons")
    }
    
    private var filteredIcons: [SamwiseIcon] {
        let allIcons = getAllIcons()
        if let category = category {
            return allIcons.filter { $0.category == category }
        }
        return allIcons
    }
    
    private func getAllIcons() -> [SamwiseIcon] {
        // Reflection-based collection of all icons
        // This is a simplified version - in practice, you'd maintain a registry
        return [
            SamwiseIcons.Navigation.home,
            SamwiseIcons.Navigation.create,
            SamwiseIcons.Navigation.history,
            SamwiseIcons.Navigation.settings,
            SamwiseIcons.Actions.play,
            SamwiseIcons.Actions.stop,
            SamwiseIcons.Actions.share,
            SamwiseIcons.Audio.microphone,
            SamwiseIcons.Audio.waveform,
            SamwiseIcons.Running.runner,
            SamwiseIcons.Running.location,
            SamwiseIcons.Social.friends,
            SamwiseIcons.Social.message
        ]
    }
}

// MARK: - Category Extension
extension SamwiseIcon.IconCategory {
    var title: String {
        switch self {
        case .navigation: return "Navigation"
        case .action: return "Actions"
        case .audio: return "Audio & Voice"
        case .running: return "Running & Fitness"
        case .social: return "Social"
        case .system: return "System"
        case .stats: return "Statistics"
        }
    }
}

// MARK: - Convenience Extensions
extension SamwiseIconView {
    /// Create a navigation-sized icon (24pt, medium weight)
    static func navigation(_ icon: SamwiseIcon, color: Color? = nil) -> SamwiseIconView {
        SamwiseIconView(icon, size: .regular, color: color, useSemanticColor: color == nil)
    }
    
    /// Create a small inline icon (16pt, regular weight)
    static func inline(_ icon: SamwiseIcon, color: Color? = nil) -> SamwiseIconView {
        SamwiseIconView(icon, size: .small, color: color, useSemanticColor: color == nil)
    }
    
    /// Create a prominent icon (32pt, semibold weight)
    static func prominent(_ icon: SamwiseIcon, color: Color? = nil) -> SamwiseIconView {
        SamwiseIconView(icon, size: .large, color: color, useSemanticColor: color == nil)
    }
}

// MARK: - Preview Provider
struct SamwiseIcons_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SamwiseIconGrid()
        }
        .previewDisplayName("Icon Library")
        
        VStack(spacing: 20) {
            // Different sizes
            HStack(spacing: 20) {
                SamwiseIconView(SamwiseIcons.Running.runner, size: .small)
                SamwiseIconView(SamwiseIcons.Running.runner, size: .regular)
                SamwiseIconView(SamwiseIcons.Running.runner, size: .large)
                SamwiseIconView(SamwiseIcons.Running.runner, size: .xlarge)
            }
            
            // Icon buttons
            HStack(spacing: 20) {
                SamwiseIconButton(SamwiseIcons.Actions.play, style: .circular) { }
                SamwiseIconButton(SamwiseIcons.Actions.share, style: .rounded) { }
                SamwiseIconButton(SamwiseIcons.Actions.close, style: .plain) { }
            }
            
            // Semantic colors
            HStack(spacing: 15) {
                SamwiseIconView(SamwiseIcons.Audio.microphone)
                SamwiseIconView(SamwiseIcons.Running.location)
                SamwiseIconView(SamwiseIcons.Social.friends)
                SamwiseIconView(SamwiseIcons.Stats.achievement)
            }
        }
        .padding()
        .previewDisplayName("Icon Samples")
    }
}

/*
 USAGE EXAMPLES:
 
 // Basic icon with semantic color
 SamwiseIconView(SamwiseIcons.Audio.microphone)
 
 // Navigation icon with custom color
 SamwiseIconView.navigation(SamwiseIcons.Navigation.home, color: .white)
 
 // Small inline icon
 SamwiseIconView.inline(SamwiseIcons.System.clock)
 
 // Icon button with circular background
 SamwiseIconButton(SamwiseIcons.Actions.play, style: .circular) {
     viewModel.startRun()
 }
 
 // Tab bar item
 .tabItem {
     SamwiseIconView(SamwiseIcons.Navigation.home)
     Text("Home")
 }
 
 ACCESSIBILITY FEATURES:
 
 - Every icon has descriptive accessibility labels
 - Icons include accessibility hints explaining their purpose
 - Button icons automatically get button traits
 - Semantic meanings are preserved in voice descriptions
 - Icon sizing respects Dynamic Type when appropriate
 - High contrast support through semantic color system
 
 DESIGN SYSTEM COMPLIANCE:
 
 - 24pt baseline size for touch targets
 - 2pt stroke weight for custom icons (SF Symbols auto-adjust)
 - Rounded corners match brand personality
 - Semantic color usage based on icon category
 - Consistent sizing scale (16pt, 24pt, 32pt, 48pt)
 - Brand-appropriate icon selection from SF Symbols
 
 ICON PRINCIPLES:
 
 - Consistent sizing across similar contexts
 - Proper labels for accessibility
 - Color coding for different states and categories
 - Animation only for state changes (not decorative)
 - Universal recognition where possible
 - Brand personality reflected in icon choices
 
 */