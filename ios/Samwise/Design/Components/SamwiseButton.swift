import SwiftUI

// MARK: - Samwise Button Component System
// Complete button implementation based on design system specifications

struct SamwiseButton: View {
    
    // MARK: - Button Types
    enum ButtonType {
        case primary        // Call-to-Action buttons
        case secondary      // Alternative actions  
        case tertiary       // Text-only buttons
        case recording      // Voice recording button
        case destructive    // Delete/warning actions
    }
    
    // MARK: - Button Sizes
    enum ButtonSize {
        case standard       // 48pt height
        case compact       // 44pt height (for navigation)
        case large         // 56pt height (for emphasis)
        case recording     // 80pt diameter (circular)
        
        var height: CGFloat {
            switch self {
            case .standard: return 48
            case .compact: return 44
            case .large: return 56
            case .recording: return 80
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .standard, .compact: return 16
            case .large: return 18
            case .recording: return 24
            }
        }
    }
    
    // MARK: - Properties
    let title: String
    let icon: String?
    let type: ButtonType
    let size: ButtonSize
    let action: () -> Void
    let isEnabled: Bool
    let isLoading: Bool
    
    @State private var isPressed = false
    
    // MARK: - Initializers
    init(
        _ title: String,
        icon: String? = nil,
        type: ButtonType = .primary,
        size: ButtonSize = .standard,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.type = type
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                // Haptic feedback for important actions
                if type == .primary || type == .recording {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }
                action()
            }
        }) {
            buttonContent
        }
        .buttonStyle(SamwiseButtonStyle(
            type: type,
            size: size,
            isEnabled: isEnabled,
            isLoading: isLoading,
            isPressed: isPressed
        ))
        .disabled(!isEnabled || isLoading)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50) { pressing in
            isPressed = pressing
        } perform: { }
    }
    
    // MARK: - Button Content
    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: size == .recording ? 0 : 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                    .scaleEffect(0.8)
            } else if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size.fontSize, weight: .medium))
            }
            
            if !title.isEmpty && size != .recording {
                Text(title)
                    .font(.system(size: size.fontSize, weight: .medium, design: .default))
                    .lineLimit(1)
            }
        }
        .foregroundColor(textColor)
        .frame(
            maxWidth: size == .recording ? size.height : .infinity,
            minHeight: size.height,
            maxHeight: size.height
        )
        .if(size == .recording) { view in
            view.clipShape(Circle())
        }
        .if(size != .recording) { view in
            view.clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Color Calculations
    private var backgroundColor: Color {
        guard isEnabled else {
            return Color.Button.disabledBackground
        }
        
        switch type {
        case .primary:
            return .samwisePrimary
        case .secondary:
            return .clear
        case .tertiary:
            return .clear
        case .recording:
            return .samwiseVoice
        case .destructive:
            return .samwiseWarning
        }
    }
    
    private var textColor: Color {
        guard isEnabled else {
            return Color.Button.disabledText
        }
        
        switch type {
        case .primary, .recording, .destructive:
            return .white
        case .secondary, .tertiary:
            return .samwisePrimary
        }
    }
    
    private var borderColor: Color? {
        switch type {
        case .secondary:
            return .samwiseSecondary
        default:
            return nil
        }
    }
}

// MARK: - Custom Button Style
struct SamwiseButtonStyle: ButtonStyle {
    let type: SamwiseButton.ButtonType
    let size: SamwiseButton.ButtonSize
    let isEnabled: Bool
    let isLoading: Bool
    let isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundView)
            .overlay(borderView)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowOffset
            )
            .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private var backgroundView: some View {
        Group {
            if type == .recording {
                Circle()
                    .fill(backgroundColor)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
            }
        }
    }
    
    @ViewBuilder
    private var borderView: some View {
        if type == .secondary {
            if size == .recording {
                Circle()
                    .stroke(Color.samwiseSecondary, lineWidth: 2)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.samwiseSecondary, lineWidth: 2)
            }
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .primary:
            return .samwisePrimary
        case .secondary, .tertiary:
            return .clear
        case .recording:
            return .samwiseVoice
        case .destructive:
            return .samwiseWarning
        }
    }
    
    private var shadowColor: Color {
        switch type {
        case .recording:
            return Color.samwiseVoice.opacity(0.3)
        case .primary:
            return Color.samwisePrimary.opacity(0.2)
        default:
            return Color.clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch type {
        case .recording:
            return 8
        case .primary:
            return 4
        default:
            return 0
        }
    }
    
    private var shadowOffset: CGFloat {
        switch type {
        case .recording, .primary:
            return 2
        default:
            return 0
        }
    }
}

// MARK: - Convenience Extensions
extension SamwiseButton {
    
    // MARK: - Primary Buttons
    static func primary(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> SamwiseButton {
        SamwiseButton(
            title,
            icon: icon,
            type: .primary,
            size: .standard,
            isEnabled: isEnabled,
            isLoading: isLoading,
            action: action
        )
    }
    
    // MARK: - Secondary Buttons
    static func secondary(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> SamwiseButton {
        SamwiseButton(
            title,
            icon: icon,
            type: .secondary,
            size: .standard,
            isEnabled: isEnabled,
            action: action
        )
    }
    
    // MARK: - Text Buttons
    static func textButton(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> SamwiseButton {
        SamwiseButton(
            title,
            icon: icon,
            type: .tertiary,
            size: .compact,
            isEnabled: isEnabled,
            action: action
        )
    }
    
    // MARK: - Recording Button
    static func recording(
        isRecording: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        SamwiseButton(
            "",
            icon: "mic.fill",
            type: .recording,
            size: .recording,
            action: action
        )
        .overlay(
            // Pulsing animation when recording
            Circle()
                .stroke(Color.samwiseVoice.opacity(0.4), lineWidth: 4)
                .scaleEffect(isRecording ? 1.2 : 1.0)
                .opacity(isRecording ? 0.0 : 0.4)
                .animation(
                    isRecording ? 
                    Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: false) : 
                    .none,
                    value: isRecording
                )
        )
    }
    
    // MARK: - Destructive Button
    static func destructive(
        _ title: String,
        icon: String? = "trash.fill",
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> SamwiseButton {
        SamwiseButton(
            title,
            icon: icon,
            type: .destructive,
            size: .standard,
            isEnabled: isEnabled,
            action: action
        )
    }
}

// MARK: - View Extension Helper

// MARK: - Preview Provider
struct SamwiseButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Primary Buttons
            Group {
                SamwiseButton.primary("Create Run", icon: "plus.circle.fill") { }
                SamwiseButton.primary("Start Run", icon: "play.fill", isLoading: true) { }
                SamwiseButton.primary("Disabled", isEnabled: false) { }
            }
            
            // Secondary Buttons
            Group {
                SamwiseButton.secondary("Cancel", icon: "xmark") { }
                SamwiseButton.secondary("Share", icon: "square.and.arrow.up") { }
            }
            
            // Text Buttons
            Group {
                SamwiseButton.textButton("Skip") { }
                SamwiseButton.textButton("Learn More", icon: "info.circle") { }
            }
            
            // Recording Button
            HStack(spacing: 40) {
                SamwiseButton.recording(isRecording: false) { }
                SamwiseButton.recording(isRecording: true) { }
            }
            
            // Destructive Button
            SamwiseButton.destructive("Delete Run") { }
        }
        .padding()
        .background(Color.samwiseBackground)
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Samwise Buttons")
    }
}

/*
 USAGE EXAMPLES:
 
 // Primary action button
 SamwiseButton.primary("Create Run", icon: "plus.circle.fill") {
     // Handle run creation
 }
 
 // Secondary action with loading state
 SamwiseButton.secondary("Share", icon: "square.and.arrow.up") {
     // Handle sharing
 }
 
 // Text button for navigation
 SamwiseButton.textButton("Skip") {
     // Handle skip action
 }
 
 // Recording button with animation
 SamwiseButton.recording(isRecording: viewModel.isRecording) {
     viewModel.toggleRecording()
 }
 
 // Destructive action
 SamwiseButton.destructive("Delete Run") {
     // Handle deletion with confirmation
 }
 
 ACCESSIBILITY FEATURES:
 
 - All buttons meet 44pt minimum touch target requirement
 - VoiceOver labels automatically generated from title
 - Haptic feedback for primary and recording actions
 - Loading states prevent double-taps
 - Disabled states clearly communicated
 - Color-blind friendly (doesn't rely solely on color)
 
 DESIGN SYSTEM COMPLIANCE:
 
 - Uses semantic colors from colors.swift
 - Follows spacing system for padding and sizing  
 - Implements brand-appropriate corner radius (12pt)
 - Consistent typography (SF Pro Text 16pt Medium)
 - State management with proper visual feedback
 - Animation timing follows design system (0.15s easeOut)
 
 */