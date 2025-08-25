# Samwise Project Planning Document

## Project Overview

Samwise is a running companion app that connects runners with their support network through voice messages delivered at precise distance markers during runs. The app embodies the values of being loyal, supportive, intimate, personal, reliable, trustworthy, and journey-focused.

### Vision Statement
To create the most supportive running experience by bringing the encouragement of friends and family directly into the runner's journey, making every run feel less solitary and more connected to the people who care.

### Core Value Proposition
- **For Runners**: Receive perfectly timed encouragement from loved ones during runs
- **For Supporters**: Send meaningful support without needing to be physically present
- **For Relationships**: Strengthen bonds through shared running journeys

## Current Status (January 2025)

### ✅ Completed Features

#### Backend Infrastructure (Node.js/Express)
- Complete REST API with run management endpoints
- MongoDB database with automatic data cleanup (7-day TTL)
- Audio file upload and storage system
- Voice message management with distance markers
- Share link generation and validation
- Privacy-focused design (no location storage)

#### iOS Application (SwiftUI)
- Run creation and setup interface
- GPS distance tracking (no coordinate storage)
- Real-time voice message playback during runs
- Share link generation and distribution
- Complete run lifecycle management
- SwiftUI preview system with mock data

#### Web Interface (HTML/CSS/JavaScript)
- Responsive voice message recording interface
- Audio recording using MediaRecorder API
- Real-time audio preview and re-recording
- Form validation and submission
- Mobile-optimized design
- Integration with backend API

#### Design System
- Comprehensive brand identity and visual guidelines
- Complete color system with semantic usage
- SwiftUI component documentation
- User flow patterns and interaction guidelines
- Accessibility considerations

### 🔄 Current Architecture

```
iOS App (SwiftUI) ←→ Backend API (Node.js/Express) ←→ MongoDB + File Storage
                           ↕
                    Web Interface (Browser)
```

## Development Roadmap

### Phase 1: Design System Integration (Next 2-4 weeks)
**Goal**: Apply the new design system throughout the existing application

#### iOS App Updates
- [ ] Integrate `colors.swift` into all existing views
- [ ] Replace current blue/green color scheme with Forest Green/Sage Green palette
- [ ] Update all button components to use design system colors
- [ ] Implement new status badge colors (created/active/completed)
- [ ] Apply Sunrise Orange to voice message indicators
- [ ] Update progress bars to use Gentle Blue
- [ ] Ensure all typography follows design system hierarchy

#### Component Refactoring  
- [ ] Create reusable `StatCard` component with design system colors
- [ ] Build `MessageCard` component with new styling
- [ ] Implement `StatusBadge` component with semantic colors
- [ ] Create button component library (Primary, Secondary, Recording, Destructive)
- [ ] Build form input components with design system styling

#### Web Interface Updates
- [ ] Update CSS to match iOS design system colors
- [ ] Apply Forest Green/Sage Green palette to web interface
- [ ] Ensure consistent Sunrise Orange for recording controls
- [ ] Update typography to match brand guidelines
- [ ] Implement responsive design improvements

### Phase 2: User Experience Enhancement (4-6 weeks)
**Goal**: Improve user flows based on design system guidelines

#### Onboarding & First-Time Experience
- [ ] Create welcoming first-run experience
- [ ] Implement permission request flows with clear context
- [ ] Add helpful tips and guidance throughout setup
- [ ] Create empty states that encourage first run creation

#### Run Creation Flow Improvements
- [ ] Add run preview functionality
- [ ] Implement better distance input validation
- [ ] Create run templates for common distances
- [ ] Add estimated completion time calculations

#### Active Run Enhancements
- [ ] Improve GPS accuracy monitoring
- [ ] Add better audio mixing for voice messages
- [ ] Implement run pause/resume functionality
- [ ] Create better progress visualization

#### Message Recording Experience
- [ ] Add audio quality feedback during recording
- [ ] Implement recording suggestions based on distance
- [ ] Create message scheduling for future runs
- [ ] Add message preview for runners before run

### Phase 3: Advanced Features (6-10 weeks)
**Goal**: Add features that deepen the supportive experience

#### Enhanced Voice Messages
- [ ] Multiple message support per distance marker
- [ ] Message mixing and crossfading
- [ ] Background music integration
- [ ] Audio effects and enhancement

#### Supporter Experience  
- [ ] Run progress notifications to supporters
- [ ] Post-run message delivery confirmations
- [ ] Supporter dashboard for multiple runs
- [ ] Message analytics and impact feedback

#### Runner Analytics
- [ ] Journey-focused metrics (not competitive)
- [ ] Message impact tracking
- [ ] Run completion celebrations
- [ ] Personal milestone recognition

#### Social Features (Privacy-First)
- [ ] Close friends groups for message sharing
- [ ] Run completion sharing (optional)
- [ ] Thank you messages to supporters
- [ ] Anniversary and milestone notifications

### Phase 4: Platform Expansion (10-16 weeks)
**Goal**: Expand platform reach while maintaining core values

#### iOS Enhancements
- [ ] Apple Watch app for run tracking
- [ ] HealthKit integration for holistic fitness data
- [ ] Siri Shortcuts for quick run creation
- [ ] iOS widget for active runs

#### Web Platform Evolution
- [ ] Progressive Web App (PWA) functionality
- [ ] Offline message recording capability
- [ ] Desktop web interface optimization
- [ ] Integration with calendar apps

#### Audio Platform Integration
- [ ] Spotify/Apple Music integration
- [ ] Podcast app compatibility
- [ ] Custom audio mixing preferences
- [ ] Voice message transcription for accessibility

## Technical Considerations

### Performance Priorities
1. **GPS Accuracy**: Ensure precise distance tracking for message timing
2. **Audio Quality**: High-quality voice message playback during runs
3. **Battery Optimization**: Minimize battery drain during long runs
4. **Network Resilience**: Handle poor connectivity gracefully

### Privacy & Security
- **Data Minimization**: Only collect necessary data for functionality
- **Automatic Cleanup**: All data expires after 7 days
- **No Location Storage**: Calculate distances without storing coordinates
- **Audio Privacy**: Secure voice message handling and storage

### Scalability Planning
- **Database Optimization**: MongoDB indexing for share link lookups
- **CDN Integration**: Fast audio file delivery globally
- **Caching Strategy**: Reduce API calls during runs
- **Load Testing**: Ensure system handles concurrent runs

## Quality Assurance Strategy

### Testing Priorities
1. **GPS Accuracy**: Test distance calculations across various routes
2. **Audio Timing**: Verify precise message playback at distance markers
3. **Cross-Platform**: Ensure consistent experience between iOS and web
4. **Error Recovery**: Test network interruption and GPS loss scenarios
5. **Battery Impact**: Long-term battery usage testing

### User Testing Focus Areas
- **First-time onboarding experience**
- **Voice message recording flow usability**
- **Active run interface during actual runs**
- **Error states and recovery processes**
- **Accessibility with screen readers and motor limitations**

### Performance Benchmarks
- **GPS Update Frequency**: Maximum 5-meter accuracy
- **Audio Playback Latency**: <500ms from trigger to playback
- **Battery Usage**: <10% drain per hour of active tracking
- **Network Efficiency**: <1MB data usage per completed run

## Success Metrics

### User Engagement
- **Run Completion Rate**: >85% of started runs completed
- **Message Recording Rate**: >60% of shared links result in messages
- **Return Usage**: >50% of users create multiple runs
- **Message Impact**: >90% of runners report messages helped during runs

### Technical Performance  
- **App Stability**: <0.1% crash rate during active runs
- **API Reliability**: 99.9% uptime for core endpoints
- **Audio Quality**: <1% failed message playback rate
- **GPS Accuracy**: 95% of messages triggered within 50 meters of target

### Business Impact
- **User Retention**: 30-day retention >40%
- **Organic Growth**: >30% of new users from referrals
- **Feature Adoption**: >70% of runs include voice messages
- **User Satisfaction**: >4.5/5.0 average app store rating

## Risk Assessment & Mitigation

### Technical Risks
1. **GPS Accuracy Issues**
   - *Risk*: Poor GPS signal affects message timing
   - *Mitigation*: Implement GPS confidence scoring and backup timing methods

2. **Battery Drain Concerns**
   - *Risk*: Continuous GPS tracking drains battery quickly
   - *Mitigation*: Optimize location update frequency, add power management

3. **Audio Playback Interruption**
   - *Risk*: System audio mixing conflicts with voice messages
   - *Mitigation*: Comprehensive audio session management, fallback options

### User Experience Risks
1. **Complex Onboarding**
   - *Risk*: Users abandon app due to setup complexity
   - *Mitigation*: Streamlined setup flow, clear value demonstration

2. **Empty Message State**
   - *Risk*: Runners start runs with no messages, poor first experience
   - *Mitigation*: Default encouraging messages, better sharing guidance

3. **Permission Anxiety**
   - *Risk*: Users concerned about location/microphone privacy
   - *Mitigation*: Clear privacy explanations, transparent data handling

### Business Risks
1. **Platform Policy Changes**
   - *Risk*: App store policy changes affect functionality
   - *Mitigation*: Stay current with guidelines, diversified platform strategy

2. **Competitive Features**
   - *Risk*: Major fitness apps add similar voice message features
   - *Mitigation*: Focus on unique brand values and user experience quality

## Development Resources

### Team Structure (Current/Ideal)
- **iOS Developer**: SwiftUI expertise, CoreLocation experience
- **Backend Developer**: Node.js/Express, MongoDB, audio processing
- **Frontend Developer**: Responsive web, audio APIs, progressive web apps
- **UX/UI Designer**: Mobile-first design, accessibility expertise
- **QA Engineer**: Mobile testing, GPS testing, audio quality validation

### Technology Stack
#### Current Stack
- **iOS**: SwiftUI, CoreLocation, AVAudioPlayer
- **Backend**: Node.js, Express.js, MongoDB, Multer
- **Web**: Vanilla JavaScript, MediaRecorder API, responsive CSS
- **Infrastructure**: Local development, file storage

#### Planned Additions
- **iOS**: HealthKit, WatchKit, CallKit integration
- **Backend**: Redis caching, CDN integration, analytics
- **Web**: PWA capabilities, IndexedDB, Service Workers
- **Infrastructure**: Cloud hosting, automated testing, monitoring

### Development Environment
- **Version Control**: Git with feature branch workflow
- **Testing**: iOS Simulator + physical device testing required
- **Deployment**: Staged deployment (development → staging → production)
- **Monitoring**: Error tracking, performance monitoring, user analytics

## Conclusion

Samwise represents a unique approach to running apps by focusing on human connection and emotional support rather than competition and metrics. The comprehensive design system and development roadmap outlined above provide a clear path toward building a product that truly embodies the values of being loyal, supportive, intimate, and journey-focused.

The next immediate priority is integrating the design system into the existing functional application, followed by user experience enhancements that make every interaction feel warm, encouraging, and authentically supportive. Success will be measured not just by technical performance, but by the genuine positive impact on runners' experiences and their connections with their support networks.