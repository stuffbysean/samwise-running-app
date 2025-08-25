# Samwise - Running Companion App

A running companion app that plays voice messages from friends and family at specific distance markers during runs. Named after the loyal companion who provides support during difficult journeys.

## Project Structure

```
Samwise - Running App/
├── ios/                          # iOS SwiftUI Application
│   ├── Samwise.xcodeproj/        # Xcode project file
│   └── Samwise/                  # iOS source code
│       ├── Models/               # Data models
│       ├── Views/                # SwiftUI views
│       ├── Services/             # Business logic services
│       └── Preview Content/      # Preview assets
├── backend/                      # Node.js/Express API
│   ├── src/
│   │   ├── controllers/          # Request handlers
│   │   ├── models/              # Database models
│   │   ├── routes/              # API routes
│   │   ├── middleware/          # Custom middleware
│   │   ├── services/            # Business logic
│   │   └── utils/               # Utility functions
│   └── uploads/                 # Audio file storage
├── docs/                        # Project documentation
└── PLANNING.md                  # Detailed project planning
```

## Core Features

- **Run Creation**: Runners create runs with distance goals and generate shareable links
- **Voice Messages**: Friends record voice messages for specific distance markers
- **GPS Tracking**: Real-time distance tracking triggers message playback
- **Privacy-Focused**: No location data storage, only distance calculations
- **Audio Playback**: Seamless voice message delivery during runs

## Getting Started

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

### iOS Setup

1. Open the Xcode project:
   ```bash
   open ios/Samwise.xcodeproj
   ```

2. Build and run the project in Xcode

## API Endpoints

### Runs
- `POST /api/runs` - Create a new run
- `GET /api/runs/:shareId` - Get run details
- `PATCH /api/runs/:shareId/start` - Start a run
- `PATCH /api/runs/:shareId/complete` - Complete a run

### Voice Messages
- `POST /api/runs/:shareId/messages` - Add voice message
- `GET /api/runs/:shareId/messages` - Get all messages for a run
- `PATCH /api/runs/:shareId/messages/:messageId/played` - Mark message as played

### Audio
- `POST /api/audio/upload` - Upload audio file
- `GET /api/audio/files/:filename` - Get audio file

## Technology Stack

**iOS:**
- Swift 5.0+
- SwiftUI
- Core Location (GPS tracking)
- AVFoundation (audio playback)

**Backend:**
- Node.js
- Express.js
- MongoDB with Mongoose
- Multer (file uploads)

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.