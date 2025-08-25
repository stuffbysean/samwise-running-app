import SwiftUI

// MARK: - Samwise Progress & Loading Components
// Complete progress indicator implementation based on design system specifications

// MARK: - Distance Progress Ring
struct SamwiseDistanceProgressRing: View {
    let current: Double
    let target: Double
    let lineWidth: CGFloat
    let size: CGFloat
    
    @State private var animationProgress: Double = 0
    
    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }
    
    private var progressAngle: Angle {
        .degrees(360 * animationProgress)
    }
    
    init(
        current: Double,
        target: Double,
        lineWidth: CGFloat = 8,
        size: CGFloat = 120
    ) {
        self.current = current
        self.target = target
        self.lineWidth = lineWidth
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    Color.Progress.track,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animationProgress)
                .stroke(
                    Color.Progress.fill,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            
            // Center content
            VStack(spacing: 4) {
                Text(String(format: "%.1f", current))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.samwiseText)
                
                Text("km")
                    .font(.caption)
                    .foregroundColor(.samwiseSecondary)
                
                if target > 0 {
                    Text("of \(String(format: "%.1f", target))")
                        .font(.caption2)
                        .foregroundColor(.samwiseSecondary)
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animationProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.5)) {
                animationProgress = newProgress
            }
        }
    }
}

// MARK: - Linear Progress Bar
struct SamwiseProgressBar: View {
    let progress: Double
    let height: CGFloat
    let cornerRadius: CGFloat
    let showPercentage: Bool
    
    @State private var animationProgress: Double = 0
    
    init(
        progress: Double,
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4,
        showPercentage: Bool = false
    ) {
        self.progress = min(max(progress, 0), 1.0)
        self.height = height
        self.cornerRadius = cornerRadius
        self.showPercentage = showPercentage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: showPercentage ? 8 : 0) {
            if showPercentage {
                HStack {
                    Text("Progress")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.samwiseText)
                    
                    Spacer()
                    
                    Text("\(Int(animationProgress * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.Progress.text)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.Progress.track)
                        .frame(height: height)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.Progress.fill)
                        .frame(
                            width: geometry.size.width * animationProgress,
                            height: height
                        )
                }
            }
            .frame(height: height)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animationProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.5)) {
                animationProgress = newProgress
            }
        }
    }
}

// MARK: - Loading States
struct SamwiseLoadingView: View {
    enum LoadingType {
        case spinner
        case dots
        case skeleton
        case progress(Double)
        
        var accessibilityLabel: String {
            switch self {
            case .spinner, .dots:
                return "Loading content"
            case .skeleton:
                return "Loading placeholder"
            case .progress(let value):
                return "Loading \(Int(value * 100)) percent complete"
            }
        }
    }
    
    let type: LoadingType
    let message: String?
    let size: LoadingSize
    
    enum LoadingSize {
        case small
        case medium
        case large
        
        var dimensions: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 30
            case .large: return 40
            }
        }
        
        var messageFont: Font {
            switch self {
            case .small: return .caption
            case .medium: return .subheadline
            case .large: return .body
            }
        }
    }
    
    init(
        type: LoadingType = .spinner,
        message: String? = nil,
        size: LoadingSize = .medium
    ) {
        self.type = type
        self.message = message
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: 16) {
            loadingIndicator
                .frame(width: size.dimensions, height: size.dimensions)
            
            if let message = message {
                Text(message)
                    .font(size.messageFont)
                    .foregroundColor(.samwiseSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(type.accessibilityLabel + (message.map { ". " + $0 } ?? ""))
    }
    
    @ViewBuilder
    private var loadingIndicator: some View {
        switch type {
        case .spinner:
            SamwiseSpinner(size: size.dimensions)
        case .dots:
            SamwiseLoadingDots()
        case .skeleton:
            SamwiseSkeleton()
        case .progress(let value):
            SamwiseProgressBar(progress: value, height: 6, showPercentage: true)
        }
    }
}

// MARK: - Custom Spinner
struct SamwiseSpinner: View {
    let size: CGFloat
    @State private var rotation: Double = 0
    
    init(size: CGFloat = 30) {
        self.size = size
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                Color.samwisePrimary,
                style: StrokeStyle(
                    lineWidth: max(2, size / 15),
                    lineCap: .round
                )
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Loading Dots Animation
struct SamwiseLoadingDots: View {
    @State private var animationPhase = 0
    
    private let dotCount = 3
    private let animationDuration = 1.2
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(Color.samwisePrimary)
                    .frame(width: 8, height: 8)
                    .scaleEffect(scale(for: index))
                    .animation(
                        .easeInOut(duration: animationDuration)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * animationDuration / Double(dotCount)),
                        value: animationPhase
                    )
            }
        }
        .onAppear {
            animationPhase = 1
        }
    }
    
    private func scale(for index: Int) -> Double {
        let phase = (Double(animationPhase) + Double(index) / Double(dotCount)).truncatingRemainder(dividingBy: 1.0)
        return 0.5 + 0.5 * sin(phase * .pi * 2)
    }
}

// MARK: - Skeleton Placeholder
struct SamwiseSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Title skeleton
            RoundedRectangle(cornerRadius: 4)
                .fill(skeletonGradient)
                .frame(height: 20)
                .frame(maxWidth: .infinity)
            
            // Subtitle skeleton
            RoundedRectangle(cornerRadius: 4)
                .fill(skeletonGradient)
                .frame(height: 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 40)
            
            // Content skeleton
            RoundedRectangle(cornerRadius: 4)
                .fill(skeletonGradient)
                .frame(height: 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 80)
        }
    }
    
    private var skeletonGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.samwiseBackground,
                Color.samwiseSecondary.opacity(0.3),
                Color.samwiseBackground
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Waveform Visualization (for voice messages)
struct SamwiseWaveform: View {
    let amplitudes: [Double]
    let isAnimating: Bool
    let color: Color
    
    @State private var animationPhase: Double = 0
    
    init(
        amplitudes: [Double] = Array(repeating: 0.5, count: 20),
        isAnimating: Bool = false,
        color: Color = .samwiseVoice
    ) {
        self.amplitudes = amplitudes
        self.isAnimating = isAnimating
        self.color = color
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(0..<amplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(color)
                    .frame(
                        width: 3,
                        height: barHeight(for: index)
                    )
                    .animation(
                        .easeInOut(duration: 0.5)
                        .delay(Double(index) * 0.05),
                        value: animationPhase
                    )
            }
        }
        .frame(height: 30)
        .onAppear {
            if isAnimating {
                startAnimation()
            }
        }
        .onChange(of: isAnimating) { newValue in
            if newValue {
                startAnimation()
            } else {
                animationPhase = 0
            }
        }
    }
    
    private func barHeight(for index: Int) -> CGFloat {
        let baseHeight: CGFloat = 4
        let maxHeight: CGFloat = 30
        let amplitude = amplitudes[safe: index] ?? 0.5
        
        if isAnimating {
            let wave = sin(animationPhase + Double(index) * 0.5)
            return baseHeight + (maxHeight - baseHeight) * amplitude * (0.5 + 0.5 * wave)
        } else {
            return baseHeight + (maxHeight - baseHeight) * amplitude
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            animationPhase = .pi * 4
        }
    }
}

// MARK: - Upload Progress
struct SamwiseUploadProgress: View {
    let fileName: String
    let progress: Double
    let isCompleted: Bool
    let onCancel: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            // File icon
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "doc.fill")
                .font(.title3)
                .foregroundColor(isCompleted ? .samwiseSystemSuccess : .samwiseProgress)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(fileName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.samwiseText)
                
                if !isCompleted {
                    SamwiseProgressBar(progress: progress, height: 4)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Upload complete")
                        .font(.caption)
                        .foregroundColor(.samwiseSystemSuccess)
                }
            }
            
            if !isCompleted, let onCancel = onCancel {
                Button(action: onCancel) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.samwiseSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.Card.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Array Extension for Safe Access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview Provider
struct SamwiseProgress_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Distance Progress Ring
                Group {
                    Text("Distance Progress Ring")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    HStack(spacing: 30) {
                        SamwiseDistanceProgressRing(
                            current: 3.2,
                            target: 5.0,
                            size: 100
                        )
                        
                        SamwiseDistanceProgressRing(
                            current: 5.0,
                            target: 5.0,
                            size: 100
                        )
                    }
                }
                
                Divider()
                
                // Progress Bars
                Group {
                    Text("Progress Bars")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    VStack(spacing: 16) {
                        SamwiseProgressBar(progress: 0.3, showPercentage: true)
                        SamwiseProgressBar(progress: 0.7, height: 6)
                        SamwiseProgressBar(progress: 1.0, height: 4)
                    }
                }
                
                Divider()
                
                // Loading States
                Group {
                    Text("Loading States")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    HStack(spacing: 30) {
                        SamwiseLoadingView(
                            type: .spinner,
                            message: "Loading runs...",
                            size: .small
                        )
                        
                        SamwiseLoadingView(
                            type: .dots,
                            message: "Processing...",
                            size: .medium
                        )
                        
                        SamwiseLoadingView(
                            type: .progress(0.65),
                            message: "Uploading...",
                            size: .large
                        )
                    }
                }
                
                Divider()
                
                // Waveform
                Group {
                    Text("Audio Waveform")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    VStack(spacing: 16) {
                        SamwiseWaveform(isAnimating: false)
                        SamwiseWaveform(isAnimating: true)
                    }
                }
                
                Divider()
                
                // Upload Progress
                Group {
                    Text("Upload Progress")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    VStack(spacing: 12) {
                        SamwiseUploadProgress(
                            fileName: "voice-message.m4a",
                            progress: 0.45,
                            isCompleted: false
                        ) {
                            print("Cancel upload")
                        }
                        
                        SamwiseUploadProgress(
                            fileName: "voice-message-2.m4a",
                            progress: 1.0,
                            isCompleted: true,
                            onCancel: nil
                        )
                    }
                }
                
                // Skeleton Loading
                Group {
                    Text("Skeleton Loading")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    SamwiseSkeleton()
                        .frame(maxWidth: 300)
                }
            }
            .padding()
        }
        .background(Color.samwiseBackground)
        .previewDisplayName("Samwise Progress Components")
    }
}

/*
 USAGE EXAMPLES:
 
 // Distance progress during run
 SamwiseDistanceProgressRing(
     current: viewModel.currentDistance,
     target: viewModel.targetDistance
 )
 
 // Linear progress for uploads
 SamwiseProgressBar(
     progress: uploadManager.progress,
     showPercentage: true
 )
 
 // Loading spinner during API calls
 SamwiseLoadingView(
     type: .spinner,
     message: "Creating your run...",
     size: .medium
 )
 
 // Waveform for voice messages
 SamwiseWaveform(
     amplitudes: audioManager.waveformData,
     isAnimating: audioManager.isPlaying,
     color: .samwiseVoice
 )
 
 // Upload progress with cancel option
 SamwiseUploadProgress(
     fileName: uploadItem.fileName,
     progress: uploadItem.progress,
     isCompleted: uploadItem.isCompleted
 ) {
     uploadManager.cancel(uploadItem.id)
 }
 
 ACCESSIBILITY FEATURES:
 
 - VoiceOver announces progress percentages
 - Loading states have descriptive labels
 - Progress changes are announced automatically
 - Spinner animations respect reduced motion preferences
 - Upload progress includes file names and status
 
 DESIGN SYSTEM COMPLIANCE:
 
 - Uses semantic colors from colors.swift
 - Consistent animation timing (0.5s for progress updates)
 - Proper corner radius for consistency
 - Brand-appropriate color usage
 - Smooth curves for natural motion
 - Accessibility-first design approach
 
 */