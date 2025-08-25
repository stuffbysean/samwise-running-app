# System Design Documentation

## Overview
Samwise is designed as a privacy-first, serverless-friendly running companion app that connects runners with their support network through location-triggered voice messages.

## High-Level Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   iOS Client    │───▶│   Backend API   │───▶│    Database     │
│   (SwiftUI)     │    │ (Node.js/Express)│    │   (MongoDB)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         │                        ▼                        ▼
         │              ┌─────────────────┐    ┌─────────────────┐
         └─────────────▶│  File Storage   │    │  TTL Cleanup    │
                        │   (Local FS)    │    │  (Automatic)    │
                        └─────────────────┘    └─────────────────┘
```

## Core Components

### iOS Application
**Technology:** Swift/SwiftUI, iOS 17.0+
**Responsibilities:**
- GPS distance tracking (no coordinate storage)
- Voice message playback during runs
- Run creation and sharing interface
- Audio recording for message creation
- Local data caching and offline support

### Backend API
**Technology:** Node.js, Express.js
**Responsibilities:**
- Run lifecycle management (create, start, complete)
- Voice message storage and retrieval
- Audio file upload and serving
- Share link generation and validation
- Rate limiting and security

### Database
**Technology:** MongoDB with TTL indexes
**Responsibilities:**
- Run metadata and message storage
- Automatic cleanup after 7 days
- Embedded voice messages for atomic operations
- Privacy-compliant data model (no locations)

### File Storage
**Technology:** Local filesystem with plans for S3
**Responsibilities:**
- Audio file storage with size limits
- Automatic cleanup with TTL synchronization
- Secure file serving with validation

## Data Flow

### Run Creation Flow
```
1. User creates run in iOS app
2. API generates unique shareId (UUID)
3. Run stored in MongoDB with 7-day TTL
4. Share link returned to user
5. Link shared with friends/family
```

### Message Recording Flow
```
1. Friend opens share link
2. Records voice message with distance marker
3. Audio uploaded to file storage
4. Message metadata stored in run document
5. Confirmation sent to friend
```

### Active Run Flow
```
1. Runner starts run in app
2. GPS tracking begins (distance only)
3. Messages retrieved and cached locally
4. Distance monitoring triggers message playback
5. Played messages marked in database
6. Run completion updates final statistics
```

## Privacy-by-Design

### No Location Storage
- GPS coordinates never leave device
- Only distance calculations transmitted
- No route tracking or location history
- Real-time distance calculation only

### Minimal Data Collection
- No user accounts or registration
- Anonymous share-based system
- No analytics or tracking pixels
- Automatic data expiration (7 days)

### Secure by Default
- HTTPS/TLS encryption in transit
- Rate limiting to prevent abuse
- File upload validation and limits
- No personal information required

## Scalability Considerations

### Horizontal Scaling
- Stateless API servers enable load balancing
- MongoDB sharding by shareId for distribution
- CDN integration for audio file delivery
- Microservices architecture ready

### Performance Optimization
- Embedded messages reduce query complexity
- TTL indexes minimize storage overhead
- Audio compression reduces bandwidth
- Local caching improves responsiveness

### Resource Management
- File size limits (10MB per message)
- Rate limiting (100 req/15min per IP)
- Automatic cleanup prevents storage bloat
- Memory-efficient audio streaming

## Security Architecture

### Threat Model
**Protected Assets:**
- Voice messages and personal encouragement
- Run statistics and achievements
- User privacy and location data

**Threat Actors:**
- Malicious users attempting abuse
- Unauthorized access to voice messages
- Privacy attacks through location inference

### Mitigation Strategies

#### Input Validation
```javascript
// Distance marker validation
if (distanceMarker <= 0 || distanceMarker > run.targetDistance) {
  return res.status(400).json({ error: 'Invalid distance marker' });
}

// File upload validation
const allowedMimeTypes = ['audio/mpeg', 'audio/wav', 'audio/mp4'];
if (!allowedMimeTypes.includes(file.mimetype)) {
  return cb(new Error('Invalid file type'), false);
}
```

#### Rate Limiting
- 100 requests per 15 minutes per IP
- File upload size limits (10MB)
- Automatic temporary IP blocking for abuse

#### Data Sanitization
- Message content length limits
- HTML/script tag removal
- File type validation
- Secure filename generation

## Deployment Architecture

### Development Environment
```
localhost:3000  ← Backend API
localhost:3001  ← Frontend (future web interface)
MongoDB Local   ← Database
Xcode Simulator ← iOS app testing
```

### Production Environment
```
api.samwise.app     ← Load-balanced API servers
files.samwise.app   ← CDN for audio delivery
MongoDB Atlas       ← Managed database cluster
iOS App Store       ← Native app distribution
```

## Monitoring and Observability

### Key Metrics
- API response times and error rates
- Audio upload success/failure rates
- Database query performance
- Storage usage and cleanup efficiency

### Logging Strategy
```javascript
// Structured logging without sensitive data
logger.info('Run created', {
  shareId: run.shareId,
  targetDistance: run.targetDistance,
  messageCount: run.voiceMessages.length,
  timestamp: new Date().toISOString()
  // Note: No location data logged
});
```

### Health Checks
- Database connectivity monitoring
- File system health checks
- API endpoint availability
- iOS app crash reporting

## Disaster Recovery

### Data Backup
- MongoDB automated backups with point-in-time recovery
- Audio file backups to secondary storage
- Configuration and deployment automation

### Recovery Procedures
- Automated failover for database clusters
- Blue-green deployment for zero-downtime updates
- Rollback procedures for problematic releases

## Future Architecture Considerations

### Planned Enhancements
- WebRTC for real-time audio streaming
- Push notifications for message availability
- Apple Watch companion app integration
- Multi-language support

### Technical Debt Management
- Migration to TypeScript for better type safety
- Containerization with Docker/Kubernetes
- Comprehensive API testing suite
- Performance monitoring and alerting

### Compliance Preparation
- GDPR compliance for European users
- COPPA considerations for younger users
- Accessibility standards (WCAG 2.1)
- App Store privacy nutrition labels