import SwiftUI

// MARK: - Samwise Design System Spacing
// This file contains all spacing values used in the Samwise app
// Based on an 8pt grid system with device-responsive margins

extension CGFloat {
    
    // MARK: - Core Spacing Scale (8pt Base Unit)
    
    /// 4pt - Tight inline elements, fine adjustments
    static let xxs: CGFloat = 4
    
    /// 8pt - Icon-text gaps, small padding, base grid unit
    static let xs: CGFloat = 8
    
    /// 12pt - Fine-tuned adjustments, card internal spacing
    static let sm: CGFloat = 12
    
    /// 16pt - Section spacing, form elements, standard spacing
    static let md: CGFloat = 16
    
    /// 20pt - Medium section breaks, comfortable spacing
    static let lg: CGFloat = 20
    
    /// 24pt - Major section breaks, large spacing intervals
    static let xl: CGFloat = 24
    
    /// 32pt - Screen margins, major separations
    static let xxl: CGFloat = 32
    
    /// 48pt - Hero sections, celebration spaces, spacious breaks
    static let xxxl: CGFloat = 48
    
    // MARK: - Semantic Spacing Categories
    
    struct Spacing {
        /// 4pt-8pt - Within components (icon-text gaps, tight padding)
        static let tight = 4...8
        
        /// 16pt - Between related elements (form fields, list items)
        static let normal: CGFloat = 16
        
        /// 24pt-32pt - Between major sections (card groups, page sections)
        static let loose = 24...32
        
        /// 48pt+ - Major visual breaks (hero sections, celebrations)
        static let spacious: CGFloat = 48
    }
    
    // MARK: - Device-Responsive Screen Margins
    
    struct ScreenMargin {
        /// iPhone SE: 16pt margins - Compact screen optimization
        static let compact: CGFloat = 16
        
        /// iPhone Standard: 20pt margins - Standard phone experience
        static let regular: CGFloat = 20
        
        /// iPhone Plus/Pro: 24pt margins - Large phone comfort
        static let large: CGFloat = 24
        
        /// iPad: 32pt margins - Tablet-appropriate spacing
        static let extraLarge: CGFloat = 32
        
        /// Dynamic margin based on screen size
        static var adaptive: CGFloat {
            let screenWidth = UIScreen.main.bounds.width
            switch screenWidth {
            case ...320:  // iPhone SE and smaller
                return compact
            case 321...414:  // Standard iPhone sizes
                return regular  
            case 415...500:  // iPhone Plus/Pro sizes
                return large
            default:  // iPad and larger
                return extraLarge
            }
        }
    }
    
    // MARK: - Component-Specific Spacing
    
    struct Card {
        /// Internal padding within cards
        static let internalPadding: CGFloat = 16
        
        /// External margins between cards
        static let externalMargin: CGFloat = 24
        
        /// Spacing between card elements
        static let elementSpacing: CGFloat = 12
    }
    
    struct Button {
        /// Vertical padding inside buttons
        static let verticalPadding: CGFloat = 12
        
        /// Horizontal padding inside buttons
        static let horizontalPadding: CGFloat = 20
        
        /// Spacing between button icon and text
        static let iconTextGap: CGFloat = 8
        
        /// Minimum spacing between buttons
        static let betweenButtons: CGFloat = 12
    }
    
    struct List {
        /// Spacing between list items
        static let itemSpacing: CGFloat = 16
        
        /// Internal padding within list items
        static let itemInternalPadding: CGFloat = 12
        
        /// Spacing between list sections
        static let sectionSpacing: CGFloat = 24
    }
    
    struct Form {
        /// Spacing from label to input field
        static let labelToInput: CGFloat = 8
        
        /// Spacing between field groups
        static let betweenGroups: CGFloat = 16
        
        /// Internal input padding
        static let inputPadding: CGFloat = 12
        
        /// Help text spacing below inputs
        static let helpTextSpacing: CGFloat = 4
    }
    
    struct Navigation {
        /// Minimum touch target size (44pt iOS standard)
        static let touchTarget: CGFloat = 44
        
        /// Icon spacing in navigation bars
        static let iconSpacing: CGFloat = 16
        
        /// Tab bar height
        static let tabBarHeight: CGFloat = 49
        
        /// Navigation bar height
        static let navBarHeight: CGFloat = 44
    }
    
    struct Message {
        /// Spacing between message elements
        static let elementSpacing: CGFloat = 8
        
        /// Internal message card padding
        static let cardPadding: CGFloat = 12
        
        /// Spacing between message cards
        static let betweenCards: CGFloat = 16
        
        /// Distance tag internal padding
        static let tagPadding: CGFloat = 6
    }
}

// MARK: - SwiftUI View Extensions

extension View {
    
    // MARK: - Padding Convenience Methods
    
    /// Apply adaptive screen margins based on device size
    func screenMargins() -> some View {
        self.padding(.horizontal, .ScreenMargin.adaptive)
    }
    
    /// Apply standard card spacing (internal padding + external margins)
    func cardSpacing() -> some View {
        self
            .padding(.Card.internalPadding)
            .padding(.vertical, .Card.externalMargin)
    }
    
    /// Apply form field spacing
    func formFieldSpacing() -> some View {
        self.padding(.bottom, .Form.betweenGroups)
    }
    
    /// Apply button spacing (horizontal groups)
    func buttonGroupSpacing() -> some View {
        self.padding(.trailing, .Button.betweenButtons)
    }
    
    // MARK: - Layout Convenience Methods
    
    /// Standard section break spacing
    func sectionBreak() -> some View {
        self.padding(.vertical, .xl)
    }
    
    /// Major visual break for celebrations/hero sections
    func heroSpacing() -> some View {
        self.padding(.vertical, .xxxl)
    }
    
    /// Tight spacing for related elements
    func tightSpacing() -> some View {
        self.padding(.xs)
    }
    
    /// Standard spacing for general layout
    func standardSpacing() -> some View {
        self.padding(.md)
    }
    
    /// Loose spacing for major sections
    func looseSpacing() -> some View {
        self.padding(.xl)
    }
}

// MARK: - Spacing Utilities

struct SpacingUtilities {
    
    /// Returns appropriate spacing based on context
    static func contextualSpacing(for context: SpacingContext) -> CGFloat {
        switch context {
        case .withinComponent:
            return .xs
        case .betweenRelatedElements:
            return .md
        case .betweenSections:
            return .xl
        case .majorBreaks:
            return .xxxl
        case .screenEdges:
            return .ScreenMargin.adaptive
        }
    }
    
    /// Calculates spacing for dynamic layouts
    static func dynamicSpacing(basedOn screenSize: CGSize) -> CGFloat {
        let screenWidth = screenSize.width
        let baseSpacing: CGFloat = 16
        
        // Scale spacing based on screen width
        let scaleFactor = screenWidth / 375 // iPhone 8 as baseline
        return baseSpacing * scaleFactor
    }
}

enum SpacingContext {
    case withinComponent
    case betweenRelatedElements  
    case betweenSections
    case majorBreaks
    case screenEdges
}

// MARK: - Layout Guides

struct LayoutGuides {
    
    /// Standard content width for readability
    static let maxContentWidth: CGFloat = 320
    
    /// Recommended minimum touch target size
    static let minTouchTarget: CGFloat = 44
    
    /// Safe area considerations for different devices
    struct SafeArea {
        static let topInset: CGFloat = 44
        static let bottomInset: CGFloat = 34
        static let homeIndicatorHeight: CGFloat = 21
    }
}

// MARK: - Usage Examples & Documentation

/*
 
 USAGE EXAMPLES:
 
 // Basic spacing
 VStack(spacing: .md) {
     Text("Title")
     Text("Content")
 }
 
 // Card layout
 VStack {
     content
 }
 .cardSpacing()
 
 // Screen margins
 ScrollView {
     content
 }
 .screenMargins()
 
 // Button layout
 HStack(spacing: .Button.betweenButtons) {
     Button("Cancel") { }
     Button("Continue") { }
 }
 
 // Form layout
 VStack(spacing: .Form.betweenGroups) {
     FormField("Name")
     FormField("Email")
 }
 
 // Navigation touch targets
 Button("Menu") {
     // action
 }
 .frame(minHeight: .Navigation.touchTarget)
 
 ACCESSIBILITY CONSIDERATIONS:
 
 - All interactive elements use minimum 44pt touch targets
 - Spacing scales appropriately with Dynamic Type
 - Adequate spacing between interactive elements prevents accidental taps
 - Visual hierarchy supported by consistent spacing relationships
 
 RESPONSIVE DESIGN:
 
 - Screen margins adapt to device size automatically
 - Spacing scales proportionally on larger screens  
 - Compact devices get optimized spacing for thumb reach
 - Landscape orientation maintains usable spacing ratios
 
 */