# API Endpoints Documentation

Base URL: `http://localhost:3000/api`

## Health Check

### GET /health
Check server status and uptime.

**Response:**
```json
{
  "status": "OK",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 3600.5
}
```

## Run Management

### POST /runs
Create a new run with shareable link.

**Request Body:**
```json
{
  "title": "Morning 5K Run",
  "targetDistance": 5.0
}
```

**Response (201):**
```json
{
  "success": true,
  "run": {
    "shareId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "title": "Morning 5K Run",
    "targetDistance": 5.0,
    "status": "created",
    "actualDistance": 0,
    "duration": 0,
    "messageCount": 0,
    "createdAt": "2024-01-15T10:30:00.000Z"
  },
  "shareLink": "/share/f47ac10b-58cc-4372-a567-0e02b2c3d479"
}
```

### GET /runs/:shareId
Get run details by share ID.

**Response (200):**
```json
{
  "success": true,
  "run": {
    "shareId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "title": "Morning 5K Run",
    "targetDistance": 5.0,
    "status": "created",
    "actualDistance": 0,
    "duration": 0,
    "messageCount": 2,
    "createdAt": "2024-01-15T10:30:00.000Z"
  }
}
```

### PATCH /runs/:shareId/start
Start an active run (changes status from 'created' to 'active').

**Response (200):**
```json
{
  "success": true,
  "run": {
    "shareId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "status": "active"
    // ... other run data
  }
}
```

### PATCH /runs/:shareId/complete
Complete a run with final statistics.

**Request Body:**
```json
{
  "actualDistance": 5.2,
  "duration": 1800
}
```

**Response (200):**
```json
{
  "success": true,
  "run": {
    "shareId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "status": "completed",
    "actualDistance": 5.2,
    "duration": 1800,
    "completedAt": "2024-01-15T11:00:00.000Z"
    // ... other run data
  }
}
```

## Voice Messages

### POST /runs/:shareId/messages
Add a voice message to a run.

**Request Body:**
```json
{
  "distanceMarker": 2.5,
  "senderName": "Alex",
  "message": "You're doing great! Keep it up!",
  "audioFilePath": "/api/audio/files/voice-message-1705315800-123456.mp3"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": {
    "id": "60d5ecb74b24a1b3f8d4e5f6",
    "distanceMarker": 2.5,
    "senderName": "Alex",
    "message": "You're doing great! Keep it up!",
    "audioFilePath": "/api/audio/files/voice-message-1705315800-123456.mp3",
    "createdAt": "2024-01-15T10:45:00.000Z"
  }
}
```

### GET /runs/:shareId/messages
Get all voice messages for a run, sorted by distance marker.

**Response (200):**
```json
{
  "success": true,
  "messages": [
    {
      "id": "60d5ecb74b24a1b3f8d4e5f6",
      "distanceMarker": 1.0,
      "senderName": "Mom",
      "message": "Go get 'em champ!",
      "audioFilePath": "/api/audio/files/voice-message-1705315700-123455.wav",
      "isPlayed": false,
      "createdAt": "2024-01-15T10:40:00.000Z"
    },
    {
      "id": "60d5ecb74b24a1b3f8d4e5f7",
      "distanceMarker": 2.5,
      "senderName": "Alex",
      "message": "You're doing great! Keep it up!",
      "audioFilePath": "/api/audio/files/voice-message-1705315800-123456.mp3",
      "isPlayed": false,
      "createdAt": "2024-01-15T10:45:00.000Z"
    }
  ]
}
```

### PATCH /runs/:shareId/messages/:messageId/played
Mark a voice message as played during a run.

**Response (200):**
```json
{
  "success": true,
  "message": "Message marked as played"
}
```

## Audio Management

### POST /audio/upload
Upload an audio file for use in voice messages.

**Request:** Multipart form data with `audio` field

**Response (200):**
```json
{
  "success": true,
  "filename": "voice-message-1705315800-123456.mp3",
  "originalName": "message.mp3",
  "size": 245760,
  "path": "/api/audio/files/voice-message-1705315800-123456.mp3"
}
```

### GET /audio/files/:filename
Download/stream an audio file.

**Response:** Audio file stream with appropriate MIME type

## Error Responses

All endpoints may return these error formats:

**400 Bad Request:**
```json
{
  "error": "Title and target distance are required"
}
```

**404 Not Found:**
```json
{
  "error": "Run not found"
}
```

**500 Internal Server Error:**
```json
{
  "error": "Failed to create run",
  "message": "Detailed error message (development only)"
}
```

## Rate Limiting

- 100 requests per 15 minutes per IP address
- File uploads limited to 10MB per request
- Audio files limited to standard formats (MP3, WAV, M4A, AAC, OGG)

## CORS Policy

- Configured to allow requests from frontend origin
- Credentials supported for future authentication
- Preflight requests handled automatically