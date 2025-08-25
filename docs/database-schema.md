# Database Schema

## Overview
The Samwise app uses MongoDB to store run data and voice messages. The schema is designed with privacy in mind - no location data is stored, only distance calculations.

## Collections

### Runs Collection

```javascript
{
  _id: ObjectId,
  shareId: String,           // Unique UUID for sharing (indexed)
  title: String,             // User-defined run title
  targetDistance: Number,    // Target distance in kilometers
  status: String,            // 'created', 'active', 'completed'
  actualDistance: Number,    // Completed distance in kilometers (default: 0)
  duration: Number,          // Run duration in seconds (default: 0)
  completedAt: Date,         // When the run was completed (optional)
  voiceMessages: [           // Embedded voice messages array
    {
      _id: ObjectId,
      distanceMarker: Number,    // Distance in km when to play (0.1 - targetDistance)
      audioFilePath: String,     // Path to uploaded audio file (optional)
      senderName: String,        // Name of message sender (max 50 chars)
      message: String,           // Text message (optional, max 500 chars)
      isPlayed: Boolean,         // Whether message has been played (default: false)
      createdAt: Date,           // When message was added
      updatedAt: Date            // When message was last modified
    }
  ],
  expiresAt: Date,           // Auto-deletion date (7 days from creation)
  createdAt: Date,           // Run creation timestamp
  updatedAt: Date            // Last modification timestamp
}
```

### Indexes

```javascript
// Runs collection indexes
{
  "shareId": 1,              // Unique index for fast lookups
  "expiresAt": 1,            // TTL index for automatic cleanup
  "status": 1,               // For filtering active/completed runs
  "createdAt": -1            // For chronological ordering
}

// Voice messages within runs are automatically indexed by _id
```

## Data Constraints

### Runs
- `shareId`: Must be unique UUID v4 format
- `title`: Required, max 100 characters, trimmed
- `targetDistance`: Required, 0.1 - 1000 km
- `status`: Enum ['created', 'active', 'completed']
- `actualDistance`: 0+ km, defaults to 0
- `duration`: 0+ seconds, defaults to 0
- `expiresAt`: Defaults to 7 days from creation

### Voice Messages
- `distanceMarker`: Required, 0 < marker <= targetDistance
- `senderName`: Required, max 50 characters, trimmed
- `message`: Optional, max 500 characters, trimmed
- `audioFilePath`: Optional, validated server-side
- `isPlayed`: Boolean, defaults to false

## Privacy Features

### No Location Storage
- GPS coordinates are never stored in database
- Only distance calculations are persisted
- No tracking of routes or specific locations

### Automatic Cleanup
- TTL index automatically deletes runs after 7 days
- Uploaded audio files are cleaned up with database records
- No long-term data retention

### Data Minimization
- Only essential data for app functionality is stored
- No user accounts or personal information required
- Anonymous usage via share links

## File Storage

Audio files are stored in the filesystem with the following structure:

```
backend/uploads/
├── voice-message-{timestamp}-{random}.mp3
├── voice-message-{timestamp}-{random}.wav
└── voice-message-{timestamp}-{random}.m4a
```

- Files are named with timestamp and random suffix for uniqueness
- Only audio MIME types are accepted
- Maximum file size: 10MB per message
- Files are deleted when parent run expires

## API Data Models

### Public Run Data (returned by API)
```javascript
{
  shareId: String,
  title: String,
  targetDistance: Number,
  status: String,
  actualDistance: Number,
  duration: Number,
  completedAt: Date,
  messageCount: Number,
  createdAt: Date
}
```

### Voice Message API Format
```javascript
{
  id: String,
  distanceMarker: Number,
  senderName: String,
  message: String,
  audioFilePath: String,
  isPlayed: Boolean,
  createdAt: Date
}
```

## Performance Considerations

- Embedded voice messages for atomic operations
- Indexed shareId for O(1) run lookups
- TTL index for automatic cleanup without maintenance
- File size limits prevent storage abuse
- Rate limiting prevents database overload