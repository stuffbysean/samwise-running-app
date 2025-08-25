# Samwise User Flows & Interaction Patterns

This document outlines the user experience flows in Samwise, designed around our core brand values of being loyal, supportive, intimate, and journey-focused.

## 1. Core User Journey Overview

### The Complete Experience
```
Runner's Journey:
Plan → Create → Share → Run → Celebrate

Supporter's Journey:  
Receive Link → Record Message → Send Encouragement → Feel Connected
```

### Key Moments of Support
1. **Pre-Run**: Anticipation and preparation
2. **Message Recording**: Friends investing in the runner's success
3. **During Run**: Surprising moments of encouragement
4. **Post-Run**: Celebration and connection

## 2. Primary Flows

### Flow 1: Run Creation (iOS App)
**Goal**: Runner creates a run and shares it with their support network
**Brand Values**: Reliable & Trustworthy, Journey-Focused

#### Flow Steps
```
1. App Launch
   ├── First Time: Welcome & permissions
   └── Returning: Direct to run options

2. Run Setup
   ├── Enter run title (personal, meaningful)
   ├── Set target distance (realistic goal)
   ├── Review details
   └── Create run

3. Success & Sharing
   ├── Celebration moment (run created!)
   ├── Share link generation
   ├── Multiple sharing options
   └── Confirmation that friends can now help
```

#### Interaction Details

**Screen 1: Welcome/Home**
- **Entry Point**: App icon tap or notification
- **Visual Focus**: Welcoming header with running figure icon
- **Primary Action**: "Start a Run" button (Forest Green, prominent)
- **Secondary Actions**: View past runs, settings
- **Emotional Tone**: Encouraging without pressure

**Screen 2: Run Setup Form**
- **Visual Hierarchy**: 
  1. Friendly instructions at top
  2. Form fields with clear labels
  3. Preview of what friends will see
- **Input Validation**: Gentle, helpful error messages
- **Progress Indication**: No pressure, just clarity
- **Accessibility**: Large touch targets, clear labels

**Screen 3: Run Created Success**
- **Celebration**: Checkmark animation with soft success color
- **Information Display**: Run details card with clear sharing options
- **Call to Action**: Share button with multiple options
- **Reassurance**: "Friends can now support you" messaging

#### Error Handling
- **Network Issues**: "Let's try that again" messaging
- **Invalid Input**: Gentle guidance, not criticism
- **Recovery Options**: Always provide clear next steps

### Flow 2: Voice Message Recording (Web Interface)
**Goal**: Friend records an encouraging message for specific run moment
**Brand Values**: Intimate & Personal, Warm & Approachable

#### Flow Steps
```
1. Link Access
   ├── Click shared link from friend
   ├── Load run information
   └── See personal invitation

2. Message Setup
   ├── Enter your name
   ├── Choose distance marker
   ├── See context about when message plays
   └── Optional: Write backup text

3. Recording Experience
   ├── Simple recording controls
   ├── Clear visual feedback
   ├── Preview and retry options
   └── Send with confidence

4. Confirmation
   ├── Success celebration
   ├── Impact explanation
   └── Option to send more
```

#### Interaction Details

**Screen 1: Run Information**
- **Personal Connection**: "Support [Runner Name]'s [Run Title]"
- **Context Setting**: Run distance, when it happens, current message count
- **Emotional Framing**: "Your encouragement will mean everything"
- **Visual Design**: Warm colors, personal tone

**Screen 2: Message Form**
- **Name Input**: "Let [Runner] know this is from you"
- **Distance Selection**: Slider with contextual hints ("Quarter way", "Halfway", "Final push")
- **Text Backup**: Optional but encouraged
- **Instructions**: Clear, encouraging guidance

**Screen 3: Recording Interface**
- **Visual Feedback**: Gentle pulsing during recording, clear timer
- **Controls**: Large, obvious buttons with icons and text
- **Preview**: Easy playback and re-recording
- **Encouragement**: "This is going to make their day!"

**Screen 4: Success Confirmation**
- **Personal Impact**: "Your message will play at [distance] km"
- **Runner Connection**: Reference to when/how it helps
- **Additional Support**: Easy path to record another message

### Flow 3: Active Run Experience (iOS App)  
**Goal**: Runner receives timed encouragement during their run
**Brand Values**: Loyal & Supportive, Journey-Focused

#### Flow Steps
```
1. Pre-Run Preparation
   ├── Review upcoming messages
   ├── Check GPS permissions
   ├── Set up audio preferences
   └── Start when ready

2. Run Initiation
   ├── GPS tracking begins
   ├── Timer starts
   ├── First encouragement
   └── Focus on the journey

3. During Run
   ├── Automatic message triggering
   ├── Progress without pressure
   ├── Support at right moments
   └── Journey-focused metrics

4. Run Completion
   ├── Celebration of achievement
   ├── Connection to supporter impact
   ├── Simple completion flow
   └── Optional sharing
```

#### Interaction Details

**Pre-Run Screen**
- **Message Preview**: Scrollable list of upcoming encouragements
- **Confidence Building**: "You have [X] friends cheering for you"
- **Technical Readiness**: Clear GPS/audio status
- **No Pressure**: Start when you're ready

**Active Run Screen**
- **Primary Focus**: Current distance and time (large, clear)
- **Secondary Info**: Progress bar, pace (smaller, less prominent)
- **Message Integration**: 
  - Automatic audio playback
  - Visual notification of message
  - No interaction required during run
- **Completion**: Large, obvious stop button when appropriate

**Message Playback Experience**
- **Audio Priority**: Messages play over any music
- **Visual Acknowledgment**: Brief overlay showing sender
- **Seamless Integration**: No disruption to run flow
- **Emotional Impact**: Timed for maximum encouragement

## 3. Secondary Flows

### Permission Flows
**Philosophy**: Transparent, trustworthy, never manipulative

#### Location Permission
```
1. Context First
   ├── Explain why GPS matters
   ├── Emphasize privacy (no location storage)
   └── Clear value proposition

2. System Permission
   ├── Standard iOS prompt
   └── Graceful handling of denial

3. Permission Recovery
   ├── Clear explanation if needed later
   ├── Direct path to Settings
   └── No guilt or pressure
```

#### Microphone Permission (Web)
```
1. Recording Context
   ├── Explain voice message purpose
   ├── Emphasize one-time use
   └── Alternative text option

2. Browser Permission
   ├── Standard browser prompt
   └── Fallback to text input

3. Recording Confidence
   ├── Clear recording feedback
   ├── Easy preview and retry
   └── No pressure for perfection
```

### Error Recovery Flows
**Philosophy**: Helpful, never blaming, always provide path forward

#### Network Connectivity Issues
```
1. Detection
   ├── Gentle notification
   └── Avoid technical jargon

2. User Communication
   ├── "Let's try that again"
   ├── Specific retry options
   └── No data loss where possible

3. Recovery
   ├── Automatic retry when appropriate
   ├── Clear manual retry options
   └── Progress preservation
```

#### GPS Issues During Run
```
1. Detection
   ├── Monitor GPS accuracy
   └── Graceful degradation

2. User Notification
   ├── Gentle status indication
   ├── Avoid alarm or panic
   └── Continue run functionality

3. Recovery
   ├── Automatic GPS re-acquisition
   ├── Smooth transition back
   └── No loss of progress
```

## 4. Interaction Patterns

### Button Behavior
**Philosophy**: Confident, responsive, trustworthy

#### Primary Actions
- **Visual Feedback**: Immediate press state (subtle shadow change)
- **Loading States**: Clear progress indication, prevent double-tap
- **Success States**: Brief confirmation animation
- **Accessibility**: Large touch targets, clear labels

#### Secondary Actions  
- **Visual Hierarchy**: Clearly secondary, not competing
- **Consistent Placement**: Left for cancel/back, right for forward
- **Confirmation**: Destructive actions always confirm

### Form Interactions
**Philosophy**: Helpful, forgiving, encouraging

#### Input Validation
- **Real-time**: Helpful guidance as user types
- **Error Messages**: Specific, actionable, never judgmental
- **Success Indicators**: Subtle positive feedback
- **Auto-correction**: Help user succeed

#### Form Progress
- **No Traditional Progress Bars**: Focus on current step
- **Context**: Always show where you are and why
- **Back Navigation**: Always possible, with state preservation

### Audio Interactions
**Philosophy**: Seamless, personal, technically reliable

#### Recording
- **Clear State Indication**: Visual and audio feedback
- **Easy Retry**: No penalty for re-recording
- **Quality Guidance**: Subtle tips for best results
- **Privacy Assurance**: Clear data handling explanation

#### Playback
- **Automatic Timing**: No manual intervention needed during run
- **Volume Intelligence**: Appropriate levels for context
- **Graceful Degradation**: Text backup if audio fails

## 5. Emotional Design Patterns

### Encouragement Moments
**Philosophy**: Authentic support, not forced motivation

#### Pre-Run
- **Anticipation**: "Your friends are ready to cheer you on"
- **Confidence**: Show number of messages waiting
- **Personal Touch**: Reference specific supporters

#### During Run
- **Surprise**: Messages appear at perfect moments
- **Personal Connection**: Sender identification
- **Momentum**: "Keep going, you're doing amazing"

#### Post-Run
- **Achievement**: Celebrate the completion
- **Connection**: Acknowledge supporter impact
- **Personal Growth**: Focus on journey, not just metrics

### Stress Reduction Patterns

#### Information Hierarchy
- **What Matters Most**: Current distance, current message
- **What Helps**: Progress, upcoming encouragement
- **What Distracts**: Complex metrics, social features

#### Cognitive Load
- **Minimal Decisions**: Automatic where appropriate
- **Clear Options**: When choices are needed
- **No Pressure**: Always allow easy exit or pause

## 6. Accessibility & Inclusion

### Universal Design Principles

#### Visual Accessibility
- **Color Independence**: Never rely only on color
- **Contrast**: High contrast mode support
- **Size**: Dynamic Type support throughout

#### Motor Accessibility  
- **Touch Targets**: Minimum 44pt throughout
- **Alternative Inputs**: Voice control support
- **Gesture Alternatives**: Button alternatives for swipe actions

#### Cognitive Accessibility
- **Simple Language**: Clear, encouraging, never technical
- **Consistent Patterns**: Same interactions work the same way
- **Error Recovery**: Always clear path to fix problems

### Inclusive Design

#### Language
- **Encouraging**: "You're doing great" vs "You're behind pace"
- **Inclusive**: Avoid assumptions about ability or experience
- **Personal**: "Your run" vs "The run"

#### Cultural Sensitivity
- **Distance Units**: Support both metric and imperial
- **Time Formats**: Respect user's locale settings
- **Celebration Styles**: Gentle achievement, not competition

## 7. Implementation Guidelines

### Interaction Timing
```swift
// Animation Timing
Immediate Feedback: 0.1s    // Button press acknowledgment
State Changes: 0.3s         // Form field updates, status changes  
Page Transitions: 0.5s      // Screen navigation
Celebrations: 0.8s          // Success moments, achievements
```

### Touch & Gesture Patterns
- **Single Tap**: Primary actions throughout
- **Long Press**: Context menus, additional options
- **Swipe**: Natural navigation (back/forward)
- **No Complex Gestures**: Keep simple for during-run use

### State Management
- **Loading States**: Always visible for operations > 0.5s
- **Error States**: Specific, actionable, recoverable
- **Empty States**: Encouraging, with clear next steps
- **Success States**: Brief celebration, clear next action

This user flow documentation ensures that every interaction in Samwise reinforces our brand values of being loyal, supportive, intimate, personal, and journey-focused.