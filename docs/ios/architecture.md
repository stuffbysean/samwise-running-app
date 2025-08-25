# iOS Architecture Documentation

## Overview
The Samwise iOS app is built using SwiftUI with an MVVM (Model-View-ViewModel) architecture pattern, emphasizing separation of concerns and testability.

## Architecture Pattern

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Views       │───▶│   ViewModels    │───▶│     Models      │
│   (SwiftUI)     │    │  (ObservableO)  │    │   (Codable)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         │                        ▼                        │
         │              ┌─────────────────┐                │
         └─────────────▶│    Services     │◀───────────────┘
                        │ (Business Logic)│
                        └─────────────────┘
```

## Project Structure

```
Samwise/
├── SamwiseApp.swift           # App entry point
├── ContentView.swift          # Root view
├── Models/                    # Data models
│   ├── Run.swift             # Run and VoiceMessage models
│   └── User.swift            # Future user models
├── Views/                     # SwiftUI views
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Run/
│   │   ├── RunSetupView.swift
│   │   ├── ActiveRunView.swift
│   │   └── RunHistoryView.swift
│   ├── Share/
│   │   └── ShareView.swift
│   └── Components/           # Reusable UI components
│       ├── AudioPlayerView.swift
│       ├── DistanceDisplayView.swift
│       └── MessageCard.swift
├── ViewModels/               # Business logic
│   ├── RunViewModel.swift
│   ├── ShareViewModel.swift
│   └── AudioViewModel.swift
└── Services/                 # Core services
    ├── LocationManager.swift # GPS tracking
    ├── AudioManager.swift    # Audio playback/recording
    ├── APIService.swift      # Backend communication
    └── PersistenceService.swift # Local data storage
```

## Core Components

### Models
Data structures conforming to `Codable` for JSON serialization:

```swift
struct Run: Identifiable, Codable {
    let id = UUID()
    var title: String
    var targetDistance: Double
    var shareLink: String?
    var isActive: Bool
    var messages: [VoiceMessage]
    // ...
}

struct VoiceMessage: Identifiable, Codable {
    let id = UUID()
    var distanceMarker: Double
    var senderName: String
    var audioURL: URL?
    var isPlayed: Bool
    // ...
}
```

### Services

#### LocationManager
Handles GPS tracking and distance calculations:
- Core Location integration
- Privacy-focused distance tracking
- Real-time location updates
- Background location support

```swift
class LocationManager: NSObject, ObservableObject {
    @Published var totalDistance: Double = 0.0
    @Published var isTracking = false
    
    func startTracking()
    func stopTracking()
    // Distance calculation without storing coordinates
}
```

#### AudioManager
Manages voice message playback and recording:
- AVFoundation integration
- Background audio playback
- Audio session management
- File compression and optimization

#### APIService
Handles all backend communication:
- RESTful API integration
- Multipart form uploads for audio
- Error handling and retry logic
- Network reachability monitoring

#### PersistenceService
Local data storage and caching:
- UserDefaults for settings
- File system for temporary audio cache
- No sensitive location data stored

### ViewModels

Observable objects that manage view state and business logic:

```swift
class RunViewModel: ObservableObject {
    @Published var currentRun: Run?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    private let locationManager = LocationManager()
    
    func createRun(title: String, distance: Double)
    func startRun()
    func completeRun()
    // ...
}
```

## Key Features Implementation

### GPS Distance Tracking
- Uses Core Location's `CLLocationManager`
- Calculates distance incrementally using `distance(from:)`
- No coordinate storage for privacy
- Background tracking capability

### Voice Message Triggering
- Monitors distance in real-time
- Triggers messages when distance markers are reached
- Prevents duplicate playback with `isPlayed` flag
- Sorted message queue by distance

### Audio Playback
- AVAudioPlayer for local file playback
- URLSession for streaming remote audio
- Background audio session configuration
- Interrupt handling for phone calls

### Share Link Generation
- Backend generates unique UUID-based share links
- Deep linking support for message recording
- No authentication required for privacy

## Privacy Implementation

### No Location Storage
```swift
// GOOD: Calculate distance only
let distance = newLocation.distance(from: lastLocation)
totalDistance += distance

// BAD: Never store coordinates
// ❌ locations.append(newLocation.coordinate)
```

### Minimal Data Persistence
- Only essential run data stored locally
- Audio files cached temporarily
- No user tracking or analytics
- Automatic data cleanup

### Permission Handling
- Location permission requested on-demand
- Clear usage descriptions in Info.plist
- Graceful degradation without permissions

## Performance Considerations

### Memory Management
- Weak references in delegates
- Proper cleanup of audio players
- Efficient image and audio caching

### Battery Optimization
- Optimized GPS accuracy settings
- Background task management
- Audio compression for smaller files

### Network Efficiency
- Request batching where possible
- Automatic retry with exponential backoff
- Offline capability for core features

## Testing Strategy

### Unit Tests
- Model validation and serialization
- Service layer business logic
- Distance calculation accuracy
- Audio playback functionality

### UI Tests
- User flow validation
- Accessibility compliance
- Performance benchmarking
- Device-specific testing

### Integration Tests
- API communication
- Location service integration
- Audio system integration
- Background operation testing

## Future Enhancements

### Planned Features
- Apple Watch companion app
- Siri Shortcuts integration
- Custom distance intervals
- Social sharing improvements

### Technical Debt
- Migrate to async/await pattern
- Improve error handling granularity
- Add comprehensive logging
- Implement analytics (privacy-preserving)