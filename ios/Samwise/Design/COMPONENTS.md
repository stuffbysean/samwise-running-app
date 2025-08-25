
# Samwise Component Library

This document catalogs all UI components in the Samwise iOS app, documenting their design specifications, usage guidelines, and implementation patterns based on our design system.

## 1. Layout Components

### Screen Container
**Purpose**: Consistent screen-level layout and navigation
**Location**: All main views (RunSetupView, ActiveRunView)

```swift
// Current Implementation Pattern
NavigationView {
    ScrollView {
        VStack(spacing: 24) {
            // Content sections
        }
        .padding()
    }
    .navigationTitle("Screen Title")
    .navigationBarTitleDisplayMode(.large)
}
```

**Design System Integration**:
- Spacing: 24px (LG) between major sections
- Padding: 16px (MD) screen margins  
- Colors: Warm Beige background, Charcoal navigation text

### Card Container
**Purpose**: Group related content with subtle elevation
**Found In**: Run details, message previews, stat cards

```swift
// Current Implementation
VStack {
    // Card content
}
.padding()
.background(
    RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemGray6))
)
```

**Design System Upgrade**:
- Background: Warm Beige instead of systemGray6
- Border Radius: 12px (Large) for major cards, 8px (Medium) for smaller ones
- Shadow: Low elevation (2px offset, 4px blur, 0.1 opacity, Forest Green)
- Padding: 16px (MD) internal padding

## 2. Form Components

### Text Input Field
**Purpose**: User text input for run titles, names
**Found In**: RunSetupView form fields

```swift
// Current Implementation
TextField("Placeholder", text: $binding)
    .textFieldStyle(RoundedBorderTextFieldStyle())
```

**Design System Upgrade**:
- Border: 1px solid Sage Green, focus state Forest Green
- Border Radius: 6px (Small)
- Padding: 12px vertical, 16px horizontal
- Typography: .body, Charcoal text
- Placeholder: .body, Sage Green

### Form Label
**Purpose**: Labels for form inputs
**Found In**: "Run Title", "Target Distance", "Your Name"

```swift
// Current Implementation
Text("Label Text")
    .font(.headline)
    .foregroundColor(.primary)
```

**Design System Upgrade**:
- Typography: .headline, Charcoal, Semibold
- Spacing: 8px (XS) below label to input
- Color: Charcoal for primary labels

### Help Text
**Purpose**: Instructional or contextual information
**Found In**: Distance marker helper text

```swift
// Current Implementation  
Text("Helper text")
    .font(.caption)
    .foregroundColor(.secondary)
```

**Design System Upgrade**:
- Typography: .caption, Sage Green, Regular
- Spacing: 4px (XXS) above help text

## 3. Button Components

### Primary Button
**Purpose**: Main actions (Create Run, Start Recording, Send Message)
**Found In**: Throughout app for primary actions

```swift
// Current Implementation
Button(action: action) {
    HStack {
        Image(systemName: "icon.name")
        Text("Button Text")
    }
    .font(.headline)
    .foregroundColor(.white)
    .frame(maxWidth: .infinity)
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.blue) // Changes by context
    )
}
```

**Design System Upgrade**:
- Background: Forest Green
- Hover/Press: Darker Forest Green tint
- Typography: .headline, White, Semibold
- Border Radius: 12px (Large)
- Padding: 12px vertical, 20px horizontal
- Shadow: Low elevation on normal, Medium elevation on press

### Secondary Button  
**Purpose**: Secondary actions (Cancel, Reset, Re-record)
**Found In**: Modal actions, alternative options

**Design System Specs**:
- Background: Sage Green
- Border: 1px solid Sage Green
- Typography: .headline, Forest Green, Semibold
- Same dimensions as Primary Button

### Destructive Button
**Purpose**: Delete, stop, or warning actions
**Found In**: Complete run, stop recording

**Design System Specs**:
- Background: Muted Red (#E74C3C)
- Typography: .headline, White, Semibold
- Same dimensions as Primary Button

### Recording Button
**Purpose**: Audio recording controls
**Found In**: Voice message recording interface

**Design System Specs**:
- Background: Sunrise Orange
- Special State: Pulsing animation when recording
- Icon: Microphone or stop symbol
- Typography: .headline, White, Semibold

## 4. Status & Feedback Components

### Status Badge
**Purpose**: Display run status (Created, Active, Completed)
**Found In**: Run details, run cards

```swift
// Current Implementation
Text(statusText)
    .font(.subheadline)
    .fontWeight(.medium)
    .padding(.horizontal, 12)
    .padding(.vertical, 4)
    .background(
        RoundedRectangle(cornerRadius: 8)
            .fill(statusColor.opacity(0.2))
    )
    .foregroundColor(statusColor)
```

**Design System Upgrade**:
- **Created**: Sage Green background (0.2 opacity), Forest Green text
- **Active**: Gentle Blue background (0.2 opacity), Gentle Blue text  
- **Completed**: Success Green background (0.2 opacity), Success Green text
- Border Radius: 8px (Medium)
- Typography: .subheadline, Medium weight

### Distance Tag
**Purpose**: Show distance markers for messages
**Found In**: Message lists, voice message indicators

**Design System Specs**:
- Background: Gentle Blue
- Typography: .caption, White, Semibold
- Border Radius: 50% (Round) for pill shape
- Padding: 2px vertical, 8px horizontal

### Progress Indicator
**Purpose**: Show run progress toward target distance
**Found In**: ActiveRunView progress bar

```swift
// Current Implementation
GeometryReader { geometry in
    ZStack(alignment: .leading) {
        Rectangle()
            .fill(Color(.systemGray4))
            .frame(height: 8)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        
        Rectangle()
            .fill(Color.blue)
            .frame(width: geometry.size.width * progress, height: 8)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .animation(.easeInOut(duration: 0.3), value: progress)
    }
}
```

**Design System Upgrade**:
- Background Track: Warm Beige with subtle Sage Green tint
- Progress Fill: Gentle Blue
- Height: 8px
- Border Radius: 4px
- Animation: .spring(response: 0.6, dampingFraction: 0.8)

## 5. Data Display Components

### Stat Card
**Purpose**: Display key metrics (distance, duration, pace, messages)
**Found In**: ActiveRunView stats section

```swift
// Current Implementation
VStack(spacing: 8) {
    Image(systemName: icon)
        .font(.system(size: 24))
        .foregroundColor(color)
    
    Text(value)
        .font(.title2)
        .fontWeight(.bold)
    
    Text(title)
        .font(.caption)
        .foregroundColor(.secondary)
}
.frame(maxWidth: .infinity)
.padding()
.background(
    RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemGray6))
)
```

**Design System Upgrade**:
- Background: Warm Beige
- Shadow: Low elevation
- Icon Colors:
  - Distance: Gentle Blue
  - Duration: Success Green  
  - Pace: Sunrise Orange
  - Messages: Forest Green
- Value Typography: .title2, Charcoal, Bold
- Title Typography: .caption, Sage Green, Regular

### Message Card
**Purpose**: Display voice message preview information
**Found In**: Existing messages list, upcoming messages

```swift
// Current Implementation
HStack {
    VStack(alignment: .leading) {
        // Sender name and distance
        // Message text preview
    }
    Spacer()
    // Message type icon
}
.padding(12)
.background(
    RoundedRectangle(cornerRadius: 8)
        .fill(Color(.systemGray6))
)
```

**Design System Upgrade**:
- Background: Warm Beige
- Border: 1px solid Sage Green (subtle)
- Shadow: Low elevation
- Sender Name: .subheadline, Charcoal, Medium
- Distance: Gentle Blue distance tag
- Message Text: .caption, Sage Green, Regular
- Audio Icon: Sunrise Orange
- Text Icon: Forest Green

### Message Preview Bubble
**Purpose**: Compact message display for active run
**Found In**: ActiveRunView upcoming messages scroll

**Design System Specs**:
- Background: Warm Beige
- Border: 1px solid (Sage Green for unplayed, Success Green for played)
- Width: Fixed 120px
- Border Radius: 8px (Medium)
- Played State: Gentle opacity reduction, Success Green checkmark

## 6. Navigation Components

### Header Section  
**Purpose**: Screen title and contextual information
**Found In**: All main screens

**Design System Specs**:
- Run Title: .title2, Charcoal, Bold
- Subtitle: .subheadline, Sage Green, Regular
- Spacing: 8px (XS) between title and subtitle
- Center alignment

### Toolbar Actions
**Purpose**: Primary screen actions in navigation bar
**Found In**: Cancel, Start Run, navigation actions

**Design System Specs**:
- Typography: .body, Forest Green, Semibold
- Touch Target: Minimum 44px
- Active State: Forest Green
- Disabled State: Sage Green

## 7. Audio Components

### Recording Controls
**Purpose**: Voice message recording interface
**Found In**: Web interface, future iOS recording

**Design System Specs**:
- Container: Warm Beige background, dashed Sage Green border
- Recording Indicator: Pulsing Sunrise Orange circle
- Timer: .title3, Sunrise Orange, Monospace font
- Control Buttons: Standard button hierarchy

### Audio Preview
**Purpose**: Playback controls for recorded messages
**Found In**: Message recording flow

**Design System Specs**:
- Background: Warm Beige
- Controls: Sunrise Orange accent color
- Progress: Gentle Blue track
- Border Radius: 8px (Medium)

## 8. Loading & Empty States

### Loading Spinner
**Purpose**: Indicate ongoing operations
**Found In**: Run creation, API calls

```swift
// Current Implementation
VStack(spacing: 16) {
    ProgressView()
        .scaleEffect(1.2)
    
    Text("Loading message...")
        .font(.subheadline)
        .foregroundColor(.secondary)
}
```

**Design System Upgrade**:
- Spinner: Forest Green accent
- Message: .subheadline, Sage Green, Regular
- Spacing: 16px (MD) between elements

### Error State
**Purpose**: Display error messages and recovery actions
**Found In**: Network errors, validation errors

```swift
// Current Implementation
HStack {
    Image(systemName: "exclamationmark.triangle.fill")
        .foregroundColor(.red)
    
    Text(errorMessage)
        .font(.subheadline)
        .foregroundColor(.red)
}
.padding()
.background(
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.red.opacity(0.1))
)
```

**Design System Upgrade**:
- Icon: Muted Red
- Text: .subheadline, Muted Red, Regular
- Background: Muted Red (0.1 opacity)
- Border Radius: 8px (Medium)

## 9. Success & Celebration Components

### Success Message
**Purpose**: Celebrate completed actions
**Found In**: Run creation success, message sent confirmation

**Design System Specs**:
- Background: Warm Beige with Success Green accent
- Icon: Large Success Green checkmark
- Title: .title2, Charcoal, Bold
- Message: .body, Sage Green, Regular
- Shadow: Medium elevation for prominence

### Completion Celebration
**Purpose**: Major milestone celebrations
**Future Use**: Run completion, achievement unlocks

**Design System Specs**:
- Background: Gradient from Warm Beige to Soft Yellow
- Animation: Gentle spring animation
- Typography: .largeTitle, Forest Green, Bold
- Duration: 2-3 seconds display time

## 10. Implementation Guidelines

### Component Creation Checklist

1. **Semantic Colors**: Use design system colors, never hardcoded values
2. **Typography Scale**: Use defined typography hierarchy
3. **Spacing System**: Apply consistent spacing using 8px grid
4. **Touch Targets**: Minimum 44px for interactive elements
5. **Accessibility**: VoiceOver labels, Dynamic Type support
6. **Animation**: Use defined timing and easing curves
7. **State Management**: Clear visual feedback for all states

### Code Organization

```swift
// Recommended file structure
Components/
├── Layout/
│   ├── ScreenContainer.swift
│   └── CardContainer.swift
├── Forms/
│   ├── SamwiseTextField.swift
│   └── SamwiseLabel.swift
├── Buttons/
│   ├── PrimaryButton.swift
│   ├── SecondaryButton.swift
│   └── RecordingButton.swift
└── Display/
    ├── StatCard.swift
    ├── MessageCard.swift
    └── StatusBadge.swift
```

### Usage Examples

Each component should include:
- Clear initialization parameters
- Default values aligned with design system
- Preview examples for different states
- Comprehensive documentation
- Accessibility considerations

This component library ensures consistent implementation of the Samwise design system across the entire iOS application.