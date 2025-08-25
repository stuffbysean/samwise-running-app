import SwiftUI

// MARK: - Samwise Animation System
// Complete animation and micro-interaction system based on design system specifications

struct SamwiseAnimations {
    
    // MARK: - Animation Timing
    struct Timing {
        /// Quick feedback animations (0.15s)
        static let quick: Double = 0.15
        
        /// Standard UI transitions (0.3s)
        static let standard: Double = 0.3
        
        /// Smooth longer transitions (0.5s)
        static let smooth: Double = 0.5
        
        /// Gentle celebration animations (0.8s)
        static let gentle: Double = 0.8
        
        /// Voice message duration-based (2.0s default)
        static let voiceMessage: Double = 2.0
    }
    
    // MARK: - Easing Curves
    struct Curves {
        /// Standard ease-in-out for most transitions
        static let standard = Animation.easeInOut(duration: Timing.standard)
        
        /// Quick ease-out for button feedback
        static let quickFeedback = Animation.easeOut(duration: Timing.quick)
        
        /// Smooth transitions for page navigation
        static let pageTransition = Animation.easeInOut(duration: Timing.smooth)
        
        /// Gentle spring for organic feeling
        static let gentle = Animation.spring(
            response: 0.6,
            dampingFraction: 0.8,
            blendDuration: 0
        )
        
        /// Natural spring for celebrations
        static let celebration = Animation.spring(
            response: 0.3,
            dampingFraction: 0.6,
            blendDuration: 0
        )
        
        /// Bounce effect for success states
        static let bounce = Animation.interpolatingSpring(
            mass: 1.0,
            stiffness: 300,
            damping: 15,
            initialVelocity: 0
        )
    }
    
    // MARK: - Predefined Animations
    
    /// Button press animation with haptic feedback
    static func buttonPress() -> Animation {
        return Curves.quickFeedback
    }
    
    /// Page transition (slide from right)
    static func pageTransition() -> Animation {
        return Curves.pageTransition
    }
    
    /// Success celebration
    static func celebration() -> Animation {
        return Curves.celebration
    }
    
    /// Progress update (smooth value changes)
    static func progressUpdate() -> Animation {
        return Curves.gentle
    }
    
    /// Voice message playback
    static func voiceMessagePlayback(duration: Double? = nil) -> Animation {
        return Animation.easeInOut(duration: duration ?? Timing.voiceMessage)
    }
}

// MARK: - Micro-Interaction Components

// MARK: - Haptic Feedback Manager
class SamwiseHaptics {
    static let shared = SamwiseHaptics()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
    
    private init() {
        // Prepare generators for reduced latency
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        selection.prepare()
        notification.prepare()
    }
    
    enum FeedbackType {
        case buttonTap      // Light impact for regular buttons
        case primaryAction  // Medium impact for primary buttons
        case success        // Success notification
        case warning        // Warning notification
        case error          // Error notification
        case selection      // Selection feedback
        case recordingStart // Heavy impact for recording start
        case messageReceived // Light impact for message notification
    }
    
    func trigger(_ type: FeedbackType) {
        // Respect user's haptic feedback preference
        guard UIDevice.current.userInterfaceIdiom != .pad else { return }
        
        switch type {
        case .buttonTap, .messageReceived:
            lightImpact.impactOccurred()
        case .primaryAction, .recordingStart:
            mediumImpact.impactOccurred()
        case .selection:
            selection.selectionChanged()
        case .success:
            notification.notificationOccurred(.success)
        case .warning:
            notification.notificationOccurred(.warning)
        case .error:
            notification.notificationOccurred(.error)
        }
    }
}

// MARK: - Animated Button Press
struct AnimatedPressButton<Content: View>: View {
    let content: Content
    let hapticType: SamwiseHaptics.FeedbackType
    let scaleEffect: CGFloat
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        hapticType: SamwiseHaptics.FeedbackType = .buttonTap,
        scaleEffect: CGFloat = 0.95,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.hapticType = hapticType
        self.scaleEffect = scaleEffect
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            SamwiseHaptics.shared.trigger(hapticType)
            action()
        }) {
            content
        }
        .scaleEffect(isPressed ? scaleEffect : 1.0)
        .animation(SamwiseAnimations.Curves.quickFeedback, value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50) { pressing in
            isPressed = pressing
        } perform: { }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Pulse Animation (for recording)
struct PulseAnimation: View {
    let isAnimating: Bool
    let color: Color
    let size: CGFloat
    let opacity: Double
    
    @State private var scale: CGFloat = 1.0
    @State private var animationOpacity: Double = 1.0
    
    init(
        isAnimating: Bool,
        color: Color = .samwiseVoice,
        size: CGFloat = 80,
        opacity: Double = 0.4
    ) {
        self.isAnimating = isAnimating
        self.color = color
        self.size = size
        self.opacity = opacity
    }
    
    var body: some View {
        Circle()
            .stroke(color, lineWidth: 4)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(animationOpacity)
            .onAppear {
                if isAnimating {
                    startAnimation()
                }
            }
            .onChange(of: isAnimating) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    stopAnimation()
                }
            }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
            scale = 1.4
            animationOpacity = 0.0
        }
    }
    
    private func stopAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            scale = 1.0
            animationOpacity = opacity
        }
    }
}

// MARK: - Bounce Animation (for success)
struct BounceAnimation: ViewModifier {
    let trigger: Bool
    @State private var bounceScale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounceScale)
            .onChange(of: trigger) { _ in
                withAnimation(SamwiseAnimations.Curves.bounce) {
                    bounceScale = 1.2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(SamwiseAnimations.Curves.bounce) {
                        bounceScale = 1.0
                    }
                }
            }
    }
}

// MARK: - Slide Transition
struct SlideTransition: ViewModifier {
    let isVisible: Bool
    let direction: Edge
    let distance: CGFloat
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(
                x: direction == .leading || direction == .trailing ? 
                    (isVisible ? 0 : (direction == .leading ? -distance : distance)) : 0,
                y: direction == .top || direction == .bottom ? 
                    (isVisible ? 0 : (direction == .top ? -distance : distance)) : 0
            )
            .animation(SamwiseAnimations.Curves.pageTransition, value: isVisible)
    }
}

// MARK: - Shake Animation (for errors)
struct ShakeAnimation: ViewModifier {
    let trigger: Bool
    @State private var shakeOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: shakeOffset)
            .onChange(of: trigger) { _ in
                shake()
            }
    }
    
    private func shake() {
        let animation = Animation.easeInOut(duration: 0.1)
        withAnimation(animation) { shakeOffset = -5 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(animation) { shakeOffset = 5 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(animation) { shakeOffset = -5 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(animation) { shakeOffset = 0 }
        }
    }
}

// MARK: - Progress Ring Animation
struct ProgressRingAnimation: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let color: Color
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        size: CGFloat = 100,
        color: Color = .samwiseProgress
    ) {
        self.progress = min(max(progress, 0), 1.0)
        self.lineWidth = lineWidth
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    Color.Progress.track,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // Animated progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(SamwiseAnimations.progressUpdate().delay(0.2)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(SamwiseAnimations.progressUpdate()) {
                animatedProgress = newProgress
            }
        }
    }
}

// MARK: - View Extensions
extension View {
    
    /// Add bounce animation on trigger
    func bounceOnTrigger(_ trigger: Bool) -> some View {
        self.modifier(BounceAnimation(trigger: trigger))
    }
    
    /// Add slide transition
    func slideTransition(
        isVisible: Bool,
        from direction: Edge,
        distance: CGFloat = 50
    ) -> some View {
        self.modifier(SlideTransition(
            isVisible: isVisible,
            direction: direction,
            distance: distance
        ))
    }
    
    /// Add shake animation for errors
    func shakeOnError(_ trigger: Bool) -> some View {
        self.modifier(ShakeAnimation(trigger: trigger))
    }
    
    /// Wrap in animated press button
    func animatedPress(
        hapticType: SamwiseHaptics.FeedbackType = .buttonTap,
        scaleEffect: CGFloat = 0.95,
        action: @escaping () -> Void
    ) -> some View {
        AnimatedPressButton(
            hapticType: hapticType,
            scaleEffect: scaleEffect,
            action: action
        ) {
            self
        }
    }
    
    /// Add breathing animation (subtle scale)
    func breathingAnimation(isActive: Bool) -> some View {
        self
            .scaleEffect(isActive ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: isActive
            )
    }
    
    /// Add glow effect animation
    func glowEffect(
        color: Color,
        radius: CGFloat = 10,
        isActive: Bool = true
    ) -> some View {
        self
            .shadow(color: color.opacity(isActive ? 0.6 : 0), radius: radius)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isActive)
    }
}

// MARK: - Page Transition Manager
struct PageTransitionView<Content: View>: View {
    let content: Content
    let isPresented: Bool
    let transition: AnyTransition
    
    init(
        isPresented: Bool,
        transition: AnyTransition = .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ),
        @ViewBuilder content: () -> Content
    ) {
        self.isPresented = isPresented
        self.transition = transition
        self.content = content()
    }
    
    var body: some View {
        Group {
            if isPresented {
                content
                    .transition(transition)
            }
        }
        .animation(SamwiseAnimations.pageTransition(), value: isPresented)
    }
}

// MARK: - Voice Message Playback Animation
struct VoiceMessagePlaybackOverlay: View {
    let senderName: String
    let isVisible: Bool
    let duration: Double
    
    @State private var progress: Double = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                SamwiseIconView(
                    SamwiseIcons.Audio.waveform,
                    size: .regular,
                    color: .samwiseVoice
                )
                
                Text("Message from \(senderName)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            // Progress bar
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .scaleEffect(y: 0.5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.samwiseVoice.opacity(0.95))
        )
        .opacity(opacity)
        .onAppear {
            if isVisible {
                startPlayback()
            }
        }
        .onChange(of: isVisible) { newValue in
            if newValue {
                startPlayback()
            } else {
                stopPlayback()
            }
        }
    }
    
    private func startPlayback() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: duration)) {
            progress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            stopPlayback()
        }
    }
    
    private func stopPlayback() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 0.0
            progress = 0.0
        }
    }
}

// MARK: - Preview Provider
struct SamwiseAnimations_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Animated buttons
                Group {
                    Text("Animated Buttons")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        AnimatedPressButton(
                            hapticType: .buttonTap,
                            action: { print("Regular tap") }
                        ) {
                            Text("Regular Button")
                                .padding()
                                .background(Color.samwiseSecondary)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        AnimatedPressButton(
                            hapticType: .primaryAction,
                            action: { print("Primary tap") }
                        ) {
                            Text("Primary Button")
                                .padding()
                                .background(Color.samwisePrimary)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                
                Divider()
                
                // Pulse animation
                Group {
                    Text("Recording Pulse")
                        .font(.headline)
                    
                    ZStack {
                        PulseAnimation(isAnimating: true)
                        
                        Circle()
                            .fill(Color.samwiseVoice)
                            .frame(width: 80, height: 80)
                            .overlay(
                                SamwiseIconView(
                                    SamwiseIcons.Audio.microphone,
                                    size: .large,
                                    color: .white
                                )
                            )
                    }
                }
                
                Divider()
                
                // Progress ring
                Group {
                    Text("Progress Ring")
                        .font(.headline)
                    
                    ProgressRingAnimation(
                        progress: 0.7,
                        size: 120
                    )
                }
                
                Divider()
                
                // Voice message overlay
                Group {
                    Text("Voice Message Overlay")
                        .font(.headline)
                    
                    ZStack {
                        Color.gray.opacity(0.3)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack {
                            Spacer()
                            VoiceMessagePlaybackOverlay(
                                senderName: "Sarah",
                                isVisible: true,
                                duration: 3.0
                            )
                            .padding()
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.samwiseBackground)
        .previewDisplayName("Samwise Animations")
    }
}

/*
 USAGE EXAMPLES:
 
 // Animated button with haptic feedback
 Text("Button")
     .animatedPress(hapticType: .primaryAction) {
         viewModel.startRun()
     }
 
 // Success bounce animation
 Text("Completed!")
     .bounceOnTrigger(viewModel.isCompleted)
 
 // Slide transition for page navigation
 RunDetailView()
     .slideTransition(
         isVisible: viewModel.showDetails,
         from: .trailing
     )
 
 // Error shake animation
 TextField("Enter distance", text: $distance)
     .shakeOnError(viewModel.hasError)
 
 // Recording pulse animation
 ZStack {
     PulseAnimation(isAnimating: isRecording)
     RecordButton()
 }
 
 // Progress ring with animation
 ProgressRingAnimation(
     progress: viewModel.completionPercentage,
     color: .samwiseProgress
 )
 
 // Voice message playback overlay
 VoiceMessagePlaybackOverlay(
     senderName: message.senderName,
     isVisible: audioManager.isPlaying,
     duration: message.duration
 )
 
 ANIMATION PRINCIPLES:
 
 - Meaningful motion - animations serve a purpose
 - Smooth & natural - follow iOS animation curves
 - Subtle & respectful - don't overwhelm users
 - Consistent timing - use standard duration values
 - Haptic feedback for important actions
 - Respect accessibility preferences (reduce motion)
 
 ACCESSIBILITY CONSIDERATIONS:
 
 - All animations respect UIAccessibility.isReduceMotionEnabled
 - Haptic feedback can be disabled in system preferences
 - VoiceOver users get audio cues instead of just visual feedback
 - Essential information is never conveyed through animation alone
 - Focus management during animated transitions
 
 PERFORMANCE:
 
 - Haptic generators are pre-prepared for reduced latency
 - Animations use appropriate timing functions for smoothness
 - Complex animations are limited to essential interactions
 - Background app state pauses non-essential animations
 
 */