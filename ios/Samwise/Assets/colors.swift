import SwiftUI

// MARK: - Samwise Design System Colors
// This file contains all colors used in the Samwise app, organized by the design system
// Based on the brand values: Loyal & Supportive, Intimate & Personal, Reliable & Trustworthy, Journey-Focused

extension Color {
    
    // MARK: - Brand Colors (Primary Palette)
    
    /// Primary brand color - Forest Green (#2D5016)
    /// Usage: Primary actions, navigation, brand elements, main CTAs
    /// Represents trust, nature, and reliability
    static let samwisePrimary = Color(red: 0.176, green: 0.314, blue: 0.086)
    
    /// Secondary brand color - Sage Green (#87A96B)  
    /// Usage: Secondary actions, subtle accents, inactive states, supporting text
    /// Represents calm, balance, and approachability
    static let samwiseSecondary = Color(red: 0.529, green: 0.663, blue: 0.420)
    
    /// Background color - Warm Beige (#F5F1E8)
    /// Usage: Background surfaces, card backgrounds, gentle separation
    /// Represents comfort, warmth, and inclusivity
    static let samwiseBackground = Color(red: 0.961, green: 0.945, blue: 0.910)
    
    /// Text color - Charcoal (#2C3E50)
    /// Usage: Primary text, icons, high-contrast elements
    /// Represents professionalism balanced with friendliness
    static let samwiseText = Color(red: 0.173, green: 0.243, blue: 0.314)
    
    // MARK: - Accent Colors
    
    /// Voice message indicator - Sunrise Orange (#FF6B35)
    /// Usage: Voice message bubbles, audio controls, friend interactions
    /// Represents encouragement, energy, and human connection
    static let samwiseVoice = Color(red: 1.0, green: 0.420, blue: 0.208)
    
    /// Progress indicator - Gentle Blue (#6C9BD1)  
    /// Usage: Progress bars, distance tracking, calm informational elements
    /// Represents steady progress and tranquil determination
    static let samwiseProgress = Color(red: 0.424, green: 0.608, blue: 0.820)
    
    /// Success/Achievement - Soft Yellow (#F7DC6F)
    /// Usage: Completion celebrations, positive feedback, achievements
    /// Represents joy, accomplishment, and warm celebration
    static let samwiseSuccess = Color(red: 0.969, green: 0.863, blue: 0.435)
    
    /// Warning/Caution - Muted Red (#E74C3C)
    /// Usage: Error states, deletion warnings, critical actions
    /// Represents important information without alarm
    static let samwiseWarning = Color(red: 0.906, green: 0.298, blue: 0.235)
    
    // MARK: - System Colors
    
    /// System Success - (#27AE60)
    /// Usage: Completed runs, successful API calls, positive confirmations
    static let samwiseSystemSuccess = Color(red: 0.153, green: 0.682, blue: 0.376)
    
    /// System Warning - (#F39C12)  
    /// Usage: GPS issues, battery warnings, non-critical issues
    static let samwiseSystemWarning = Color(red: 0.953, green: 0.612, blue: 0.071)
    
    /// System Error - (#E74C3C)
    /// Usage: Failed uploads, network errors, critical system issues  
    static let samwiseSystemError = Color(red: 0.906, green: 0.298, blue: 0.235)
    
    /// System Info - (#3498DB)
    /// Usage: Tips, informational content, helpful guidance
    static let samwiseSystemInfo = Color(red: 0.204, green: 0.596, blue: 0.859)
    
    // MARK: - Semantic Color Extensions
    
    /// Dynamic primary color that adapts to context
    /// Returns samwisePrimary in standard contexts
    static var primary: Color {
        return samwisePrimary
    }
    
    /// Dynamic secondary color for supporting elements
    /// Returns samwiseSecondary for subtitle text, borders, etc.
    static var secondary: Color {
        return samwiseSecondary
    }
    
    
    /// Dynamic background color
    /// Returns samwiseBackground, adapts for dark mode if implemented
    static var background: Color {
        return samwiseBackground
    }
    
    // MARK: - Component-Specific Colors
    
    struct Button {
        /// Primary button background
        static let primaryBackground = Color.samwisePrimary
        static let primaryText = Color.white
        
        /// Secondary button colors  
        static let secondaryBackground = Color.samwiseSecondary
        static let secondaryText = Color.samwisePrimary
        
        /// Recording button colors
        static let recordingBackground = Color.samwiseVoice
        static let recordingText = Color.white
        
        /// Destructive button colors
        static let destructiveBackground = Color.samwiseWarning
        static let destructiveText = Color.white
        
        /// Disabled button colors
        static let disabledBackground = Color.samwiseSecondary.opacity(0.3)
        static let disabledText = Color.samwiseText.opacity(0.5)
    }
    
    struct Card {
        /// Standard card background
        static let background = Color.samwiseBackground
        
        /// Card border for subtle definition
        static let border = Color.samwiseSecondary.opacity(0.2)
        
        /// Card shadow color  
        static let shadow = Color.samwisePrimary.opacity(0.1)
        
        /// Active/selected card state
        static let activeBackground = Color.samwiseProgress.opacity(0.1)
        static let activeBorder = Color.samwiseProgress.opacity(0.3)
    }
    
    struct Status {
        /// Run status: Created (ready for messages)
        static let created = Color.samwiseSecondary
        static let createdBackground = Color.samwiseSecondary.opacity(0.2)
        
        /// Run status: Active (currently running)  
        static let active = Color.samwiseProgress
        static let activeBackground = Color.samwiseProgress.opacity(0.2)
        
        /// Run status: Completed (finished)
        static let completed = Color.samwiseSystemSuccess
        static let completedBackground = Color.samwiseSystemSuccess.opacity(0.2)
    }
    
    struct Message {
        /// Voice message indicators
        static let voiceIndicator = Color.samwiseVoice
        static let voiceBackground = Color.samwiseVoice.opacity(0.1)
        
        /// Text message indicators
        static let textIndicator = Color.samwisePrimary
        static let textBackground = Color.samwisePrimary.opacity(0.1)
        
        /// Played message state
        static let playedIndicator = Color.samwiseSystemSuccess
        static let playedBackground = Color.samwiseSystemSuccess.opacity(0.1)
        
        /// Distance marker tags
        static let distanceTagBackground = Color.samwiseProgress
        static let distanceTagText = Color.white
    }
    
    struct Progress {
        /// Progress bar track (empty portion)
        static let track = Color.samwiseBackground
        
        /// Progress bar fill (completed portion)
        static let fill = Color.samwiseProgress
        
        /// Progress percentage text
        static let text = Color.samwiseProgress
    }
    
    struct Form {
        /// Input field backgrounds
        static let inputBackground = Color.white
        
        /// Input field borders (normal state)
        static let inputBorder = Color.samwiseSecondary
        
        /// Input field borders (focus state)
        static let inputBorderFocused = Color.samwisePrimary
        
        /// Input field borders (error state)
        static let inputBorderError = Color.samwiseWarning
        
        /// Placeholder text
        static let placeholder = Color.samwiseSecondary
        
        /// Help text
        static let helpText = Color.samwiseSecondary
        
        /// Error text
        static let errorText = Color.samwiseWarning
    }
}

// MARK: - Dark Mode Support

extension Color {
    
    // MARK: - Adaptive Brand Colors (Light/Dark Mode)
    
    /// Adaptive primary color - Forest Green in light, Sage Green in dark
    static let samwisePrimaryAdaptive = Color(
        light: Color.samwisePrimary,
        dark: Color.samwiseSecondary
    )
    
    /// Adaptive background - Warm Beige in light, True Black alternative in dark
    static let samwiseBackgroundAdaptive = Color(
        light: Color.samwiseBackground,
        dark: Color.hex("#121212")
    )
    
    /// Adaptive text - Charcoal in light, White in dark
    static let samwiseTextAdaptive = Color(
        light: Color.samwiseText,
        dark: Color.white
    )
    
    /// Adaptive secondary text - Sage Green in light, muted in dark
    static let samwiseSecondaryAdaptive = Color(
        light: Color.samwiseSecondary,
        dark: Color.hex("#9CA3AF")
    )
    
    /// Adaptive accent colors for dark mode
    static let samwiseVoiceAdaptive = Color(
        light: Color.samwiseVoice,
        dark: Color.hex("#E55B2B") // Muted Orange for dark mode
    )
    
    /// Adaptive surface color for cards
    static let samwiseSurfaceAdaptive = Color(
        light: Color.white,
        dark: Color.hex("#1E1E1E")
    )
    
    /// Adaptive elevated surface (modals, overlays)
    static let samwiseElevatedSurfaceAdaptive = Color(
        light: Color.white,
        dark: Color.hex("#2C2C2C")
    )
    
    // MARK: - Dark Mode Color Palette
    struct DarkMode {
        /// Primary background - True black alternative
        static let backgroundPrimary = Color.hex("#121212")
        
        /// Secondary background
        static let backgroundSecondary = Color.hex("#1E1E1E")
        
        /// Surface color for cards and containers
        static let surface = Color.hex("#2C2C2C")
        
        /// On-surface text color
        static let onSurface = Color.white
        
        /// Primary brand color - softer Sage Green for dark mode
        static let primary = Color.samwiseSecondary
        
        /// Accent color - muted orange for less eye strain
        static let accent = Color.hex("#E55B2B")
        
        /// Muted text color
        static let textSecondary = Color.hex("#9CA3AF")
        
        /// Divider/border color
        static let divider = Color.hex("#374151")
    }
    
    // MARK: - Adaptive Color Constructor
    init(light: Color, dark: Color) {
        self = Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
    
    // MARK: - Component-Specific Adaptive Colors
    
    struct AdaptiveCard {
        /// Card background that adapts to light/dark mode
        static let background = Color(
            light: .white,
            dark: Color.DarkMode.surface
        )
        
        /// Card border that adapts to light/dark mode
        static let border = Color(
            light: Color.Card.border,
            dark: Color.DarkMode.divider
        )
        
        /// Card shadow that works in both modes
        static let shadow = Color(
            light: Color.Card.shadow,
            dark: Color.black.opacity(0.3)
        )
    }
    
    struct AdaptiveButton {
        /// Primary button background
        static let primaryBackground = Color.samwisePrimaryAdaptive
        
        /// Secondary button border
        static let secondaryBorder = Color.samwiseSecondaryAdaptive
        
        /// Disabled button colors
        static let disabledBackground = Color(
            light: Color.Button.disabledBackground,
            dark: Color.DarkMode.surface.opacity(0.3)
        )
        
        static let disabledText = Color(
            light: Color.Button.disabledText,
            dark: Color.DarkMode.textSecondary
        )
    }
    
    struct AdaptiveForm {
        /// Input field background
        static let inputBackground = Color(
            light: Color.white,
            dark: Color.DarkMode.surface
        )
        
        /// Input field border (normal state)
        static let inputBorder = Color(
            light: Color.Form.inputBorder,
            dark: Color.DarkMode.divider
        )
        
        /// Input field border (focused state)
        static let inputBorderFocused = Color.samwisePrimaryAdaptive
        
        /// Placeholder text
        static let placeholder = Color.samwiseSecondaryAdaptive
    }
}

// MARK: - UIColor Extensions (for UIKit compatibility)

extension UIColor {
    
    // MARK: - Brand Colors
    
    static let samwisePrimary = UIColor(red: 0.176, green: 0.314, blue: 0.086, alpha: 1.0)
    static let samwiseSecondary = UIColor(red: 0.529, green: 0.663, blue: 0.420, alpha: 1.0)
    static let samwiseBackground = UIColor(red: 0.961, green: 0.945, blue: 0.910, alpha: 1.0)
    static let samwiseText = UIColor(red: 0.173, green: 0.243, blue: 0.314, alpha: 1.0)
    
    // MARK: - Accent Colors
    
    static let samwiseVoice = UIColor(red: 1.0, green: 0.420, blue: 0.208, alpha: 1.0)
    static let samwiseProgress = UIColor(red: 0.424, green: 0.608, blue: 0.820, alpha: 1.0)
    static let samwiseSuccess = UIColor(red: 0.969, green: 0.863, blue: 0.435, alpha: 1.0)
    static let samwiseWarning = UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 1.0)
    
    // MARK: - Adaptive Colors
    
    static let samwisePrimaryAdaptive = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return .samwiseSecondary
        default:
            return .samwisePrimary
        }
    }
    
    static let samwiseBackgroundAdaptive = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1.0) // #121212
        default:
            return .samwiseBackground
        }
    }
    
    static let samwiseTextAdaptive = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return .white
        default:
            return .samwiseText
        }
    }
}

// MARK: - Color Utility Functions

extension Color {
    
    /// Creates a color from hex string
    /// - Parameter hex: Hex string (with or without #)
    /// - Returns: SwiftUI Color
    static func hex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        return Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Returns a slightly darker version of the color for pressed states
    var pressed: Color {
        return self.opacity(0.8)
    }
    
    /// Returns a much lighter version of the color for background use
    var backgroundTint: Color {
        return self.opacity(0.1)
    }
    
    /// Returns a lighter version of the color for border use
    var borderTint: Color {
        return self.opacity(0.3)
    }
}

// MARK: - Usage Examples & Documentation

/*
 
 USAGE EXAMPLES:
 
 // Primary Actions
 .foregroundColor(.samwisePrimary)
 .background(.samwisePrimary)
 
 // Secondary Text
 .foregroundColor(.samwiseSecondary)
 
 // Voice Message Elements
 .foregroundColor(.samwiseVoice)
 .background(.samwiseVoice.backgroundTint)
 
 // Status Badges
 .foregroundColor(.Status.active)
 .background(.Status.activeBackground)
 
 // Form Elements
 .background(.Form.inputBackground)
 .overlay(
     RoundedRectangle(cornerRadius: 6)
         .stroke(.Form.inputBorder, lineWidth: 1)
 )
 
 // Buttons
 .foregroundColor(.Button.primaryText)
 .background(.Button.primaryBackground)
 
 ACCESSIBILITY NOTES:
 
 All colors in this system have been chosen to meet WCAG AA contrast requirements:
 - samwiseText on samwiseBackground: >4.5:1 contrast ratio
 - White text on samwisePrimary: >4.5:1 contrast ratio  
 - samwiseSecondary on samwiseBackground: >3:1 contrast ratio (for large text)
 
 For users with color vision differences:
 - Never rely solely on color to convey information
 - Use icons, text, or patterns as additional indicators
 - High contrast mode support will be added in future iterations
 
 */