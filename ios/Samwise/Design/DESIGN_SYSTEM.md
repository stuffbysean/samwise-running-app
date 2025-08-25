# Samwise Design System

## 1. Brand Identity & Visual Philosophy

### Core Brand Attributes

**Loyal & Supportive** - Like a trusted friend, not a coach
- Design reflects companionship rather than performance pressure
- Emphasis on encouragement and emotional support
- Visual elements feel personal and caring

**Intimate & Personal** - Focus on close relationships, not social media
- Private, non-performative experience design
- Emphasis on meaningful connections over metrics
- No public sharing or competitive elements

**Reliable & Trustworthy** - Always there when you need it
- Consistent, predictable interface patterns
- Clear visual hierarchy and intuitive interactions
- Technical reliability reflected in design choices

**Journey-Focused** - About the process, not just the destination
- Celebrate progress over perfection
- Visual emphasis on the running experience itself
- Support system integrated throughout the journey

### Visual Tone

**Warm & Approachable** - Earthy, comforting colors
- Natural color palette inspired by outdoor running environments
- Soft, organic feeling rather than stark digital aesthetics
- Colors that feel welcoming and inclusive

**Clean & Uncluttered** - Minimalist without being cold
- Generous whitespace and clear visual hierarchy
- Focus user attention on what matters most
- Remove distractions to support concentration during runs

**Human-Centered** - Emphasis on people and relationships
- Design celebrates the human connections that motivate
- Voice message features prominently displayed
- Friend support visualized throughout the experience

**Authentic & Honest** - No artificial motivation or pressure
- Real metrics without gamification
- Honest feedback about progress and challenges
- No false urgency or manipulative design patterns

## 2. Color System

### Primary Palette

```swift
// Brand Colors
Forest Green: #2D5016     // Primary brand color, trust & nature
Sage Green: #87A96B       // Secondary, calming accent  
Warm Beige: #F5F1E8       // Background, comfort & warmth
Charcoal: #2C3E50         // Text, professional yet friendly
```

**Usage Guidelines:**
- **Forest Green**: Primary actions, navigation, brand elements
- **Sage Green**: Secondary actions, subtle accents, inactive states
- **Warm Beige**: Background surfaces, card backgrounds, gentle separation
- **Charcoal**: Primary text, icons, high-contrast elements

### Accent Colors

```swift
Sunrise Orange: #FF6B35   // Voice message indicators, encouragement
Gentle Blue: #6C9BD1      // Progress indicators, calm energy
Soft Yellow: #F7DC6F      // Success states, achievement
Muted Red: #E74C3C        // Warnings, delete actions
```

**Usage Guidelines:**
- **Sunrise Orange**: Voice message bubbles, audio controls, friend interactions
- **Gentle Blue**: Progress bars, distance tracking, calm informational elements
- **Soft Yellow**: Completion celebrations, positive feedback, achievements
- **Muted Red**: Error states, deletion warnings, critical actions

### System Colors

```swift
Success: #27AE60          // Completed runs, successful actions
Warning: #F39C12          // GPS issues, battery warnings
Error: #E74C3C            // Failed uploads, critical errors
Info: #3498DB             // Tips, informational content
```

## 3. Typography

### Hierarchy

Based on SwiftUI's semantic typography with custom weights and spacing:

```swift
// Display Typography
Title Large: .largeTitle, Forest Green, Bold
Title Standard: .title, Charcoal, Bold
Title Small: .title2, Charcoal, Semibold

// Body Typography
Headline: .headline, Charcoal, Semibold
Body: .body, Charcoal, Regular
Callout: .callout, Charcoal, Regular

// Supporting Typography
Subheadline: .subheadline, Sage Green, Medium
Caption: .caption, Sage Green, Regular
Caption Small: .caption2, Sage Green, Regular
```

### Usage Guidelines

- **Titles**: Run names, major section headers, celebration moments
- **Headlines**: Form labels, card headers, action button text
- **Body**: Message text, descriptions, informational content
- **Supporting**: Metadata, distances, timestamps, helper text

## 4. Layout & Spacing System

### Grid System

**8pt base unit** for consistent spacing throughout the application
- **Fine-tuned adjustments**: 4pt, 12pt for detailed spacing
- **Major spacing intervals**: 16pt, 24pt, 32pt, 48pt for section breaks
- **Consistent alignment**: All elements align to 8pt grid

### Screen Margins (Device-Responsive)

```swift
// Device-specific margins
iPhone SE:        16pt margins   // Compact screen optimization
iPhone Standard:  20pt margins   // Standard phone experience  
iPhone Plus/Pro:  24pt margins   // Large phone comfort
iPad:             32pt margins   // Tablet-appropriate spacing
```

### Component Spacing Categories

```swift
// Spacing Scale
Tight:    4pt-8pt    // Within components (icon-text gaps, tight padding)
Normal:   16pt       // Between related elements (form fields, list items)
Loose:    24pt-32pt  // Between major sections (card groups, page sections)
Spacious: 48pt+      // Major visual breaks (hero sections, celebration spaces)
```

### Detailed Component Spacing

- **Cards**: 16pt internal padding, 24pt external margins
- **Buttons**: 12pt vertical, 20pt horizontal padding
- **Lists**: 16pt between items, 12pt item internal padding
- **Forms**: 8pt label-to-input, 16pt between field groups
- **Navigation**: 44pt minimum touch targets, 16pt icon spacing

## 5. Navigation Architecture

### Information Architecture

**Primary Navigation** (Bottom Tab Bar):
```
├── Home (Runs & Dashboard)
├── Create (New Run Setup)  
├── History (Past Runs)
└── Settings (Profile & Preferences)
```

**Secondary Navigation**:
```
├── Voice Messages (within active run context)
├── Friends List (sharing and supporter context)
└── Run Configuration (distance, preferences, audio settings)
```

### Navigation Patterns

#### Bottom Tab Navigation ✅ **Recommended Primary Pattern**
**Research-backed**: 21% faster navigation compared to top navigation patterns

**Design Specifications**:
- **Always visible** for core functions
- **Thumb-friendly** positioning for large screens
- **Clear visual hierarchy** with SF Symbols icons + labels
- **Semantic colors**: Forest Green for selected, Sage Green for unselected
- **Touch targets**: 44pt minimum height

**Tab Structure**:
```swift
TabView {
    HomeView()
        .tabItem {
            Image(systemName: "house.fill")
            Text("Home")
        }
    
    CreateRunView()
        .tabItem {
            Image(systemName: "plus.circle.fill")
            Text("Create")
        }
    
    HistoryView()
        .tabItem {
            Image(systemName: "clock.fill")
            Text("History")
        }
        
    SettingsView()
        .tabItem {
            Image(systemName: "person.circle.fill")
            Text("Settings")
        }
}
.accentColor(.samwisePrimary)
```

#### Gesture Navigation (Secondary)
**Purpose**: Enhanced interaction without cluttering interface

- **Swipe gestures**: Navigate between voice messages during run playback
- **Pull-to-refresh**: Update friends list and message status
- **Long-press**: Quick actions (share run, delete message, mark favorite)
- **Gentle haptic feedback**: Confirm gesture recognition

#### Modal Presentation Strategy

**Sheet Modals** (Preferred):
```swift
// For run creation flow
.sheet(isPresented: $showingRunSetup) {
    RunSetupView()
}
```
- **Use cases**: Run creation, settings, friend invitation
- **Behavior**: Dismissible with swipe down
- **Height**: Adaptive based on content

**Full-Screen Modals**:
```swift
// For immersive experiences
.fullScreenCover(isPresented: $showingActiveRun) {
    ActiveRunView()
}
```
- **Use cases**: Active running interface, voice recording
- **Behavior**: Dedicated back button required
- **Focus**: Single-task, distraction-free

**Alert Modals** (Minimal Use):
```swift
// Only for critical confirmations
.alert("Complete Run?", isPresented: $showingCompleteAlert)
```
- **Use cases**: Run completion confirmation, data deletion warnings
- **Behavior**: Required user decision before proceeding

### Navigation State Management

#### Navigation Flow Examples
```swift
// Run Creation Flow
Home → Create → Setup Form → Share Success → [Optional] Active Run

// Voice Message Flow  
Web Link → Run Info → Record Form → Recording UI → Confirmation

// Historical Review
Home → History → Run Detail → Message Playback → [Optional] Share
```

#### Deep Linking Strategy
```swift
// Share link handling
samwise://share/[shareId]           // Voice message recording
samwise://run/[runId]/active        // Active run resumption
samwise://settings/notifications    // Direct settings access
```

### Accessibility Navigation

#### VoiceOver Optimization
- **Tab announcements**: "Home, tab 1 of 4, selected"
- **Navigation hints**: "Double-tap to create new run"
- **Context announcements**: "Viewing Sarah's morning run, 3 messages available"

#### Motor Accessibility
- **Large touch targets**: 44pt minimum throughout
- **Edge avoidance**: No critical controls near screen edges
- **One-handed operation**: All primary functions reachable with thumb
- **Voice control support**: Clear semantic labels for voice navigation

## 6. Border Radius & Shapes

### Radius Scale

```swift
Small: 6px      // Tags, small buttons, input fields
Medium: 8px     // Cards, message bubbles, standard buttons  
Large: 12px     // Major cards, modal corners
XLarge: 16px    // Hero cards, featured elements
Round: 50%      // Profile pictures, status indicators
```

### Shape Language

- **Rounded rectangles**: Primary shape language, feels approachable
- **Subtle curves**: Organic feeling, never harsh geometric
- **Consistent radius**: Same radius family within component groups

## 6. Shadows & Elevation

### Shadow System

```swift
// Subtle shadows for warmth, not stark material design
Low Elevation: 
  - offsetY: 2px, blur: 4px, opacity: 0.1, color: Forest Green

Medium Elevation:
  - offsetY: 4px, blur: 8px, opacity: 0.15, color: Forest Green

High Elevation:
  - offsetY: 8px, blur: 16px, opacity: 0.2, color: Forest Green
```

**Usage:**
- **Low**: Cards, buttons in normal state
- **Medium**: Modals, focused states, active buttons
- **High**: Alerts, critical actions, celebration moments

## 7. Motion & Animation

### Principles

- **Gentle & Natural**: Movements feel organic, never jarring
- **Purposeful**: Animations guide attention and provide feedback
- **Respectful**: Never interrupt or distract during runs
- **Consistent**: Same easing curves and durations throughout

### Timing

```swift
Quick: 0.2s     // State changes, button press feedback
Standard: 0.3s  // Card transitions, modal appearances
Smooth: 0.5s    // Page transitions, major state changes
Gentle: 0.8s    // Celebration animations, success states
```

### Easing Curves

```swift
// SwiftUI Animation Types
Gentle: .easeInOut          // Standard transitions
Natural: .spring(response: 0.6, dampingFraction: 0.8)  // Organic feeling
Celebration: .spring(response: 0.3, dampingFraction: 0.6)  // Success moments
```

## 8. Iconography

### Style Guidelines

- **SF Symbols**: Primary icon system for consistency
- **24px base size**: Standard icon size throughout app
- **Semantic usage**: Icons support meaning, never purely decorative
- **Consistent weight**: Medium weight for body text, semibold for headlines

### Core Icon Set

```swift
// Navigation & Actions
figure.run: Primary brand icon
play.circle.fill: Start actions
stop.circle.fill: Stop actions
share.circle: Sharing functionality

// Voice & Audio
waveform: Voice messages
microphone.fill: Recording
speaker.wave.2.fill: Audio playback

// Progress & Status  
checkmark.circle.fill: Success states
location.circle.fill: GPS tracking
clock.fill: Time tracking
```

## 9. Layout Principles

### Grid System

- **Base unit**: 8px grid for consistent alignment
- **Content width**: Maximum 320px for optimal readability
- **Margins**: 16px minimum screen margins on mobile
- **Safe areas**: Always respect iOS safe area insets

### Information Hierarchy

1. **Primary**: Current run status, distance, active voice message
2. **Secondary**: Progress indicators, upcoming messages, controls
3. **Tertiary**: Settings, metadata, supporting information

### Component Organization

- **Top to bottom**: Information flows naturally down the screen
- **Left to right**: Actions progress from left (back) to right (forward)
- **Center focus**: Most important information centered and prominent

## 10. Accessibility

### Color Accessibility

- **Contrast ratios**: Minimum 4.5:1 for normal text, 3:1 for large text
- **Color independence**: Never rely solely on color to convey meaning
- **High contrast mode**: All colors provide sufficient contrast alternatives

### Typography Accessibility

- **Dynamic Type**: Support all iOS Dynamic Type sizes
- **Minimum sizes**: Never smaller than 11px on mobile
- **Reading flow**: Clear visual hierarchy for screen readers

### Interaction Accessibility

- **Touch targets**: Minimum 44px tap targets throughout
- **Voice Over**: Comprehensive labels and hints
- **Motor accessibility**: Easy-to-reach controls, gesture alternatives

## 11. Implementation Guidelines

### SwiftUI Integration

```swift
// Use semantic color names, never hex values in components
Color.primary              // Forest Green
Color.secondary           // Sage Green  
Color.accent             // Sunrise Orange
Color.background         // Warm Beige
```

### Component Consistency

- **Reuse over recreation**: Build component library systematically
- **Prop-driven variation**: Same component, different props for variations
- **Semantic naming**: Component names reflect purpose, not appearance

### Design Tokens

All design system values should be centralized in:
- `Colors.swift` - Color definitions and semantic mappings
- `Typography.swift` - Font sizes, weights, and semantic styles
- `Spacing.swift` - Spacing constants and semantic usage
- `Animation.swift` - Animation timing and easing definitions