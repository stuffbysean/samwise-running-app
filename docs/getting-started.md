# Getting Started with Samwise

Welcome to Samwise, the running companion app that brings your support network along for every run. This guide will help you set up the development environment and understand the core concepts.

## Prerequisites

### For iOS Development
- macOS 14.0+ (Sonoma)
- Xcode 15.0+
- iOS 17.0+ device or simulator
- Apple Developer account (for device testing)

### For Backend Development
- Node.js 18.0+
- MongoDB 7.0+ (local or MongoDB Atlas)
- npm or yarn package manager

## Development Environment Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd samwise-running-app
```

### 2. Backend Setup

Navigate to the backend directory:
```bash
cd backend
```

Install dependencies:
```bash
npm install
```

Set up environment variables:
```bash
cp .env.example .env
```

Edit `.env` with your configuration:
```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/samwise
FRONTEND_URL=http://localhost:3001
JWT_SECRET=your-super-secret-jwt-key-here
```

Start MongoDB (if running locally):
```bash
# macOS with Homebrew
brew services start mongodb-community

# Or use Docker
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```

Start the development server:
```bash
npm run dev
```

The API will be available at `http://localhost:3000`

### 3. iOS Setup

Open the Xcode project:
```bash
cd ios
open Samwise.xcodeproj
```

In Xcode:
1. Select your development team in project settings
2. Choose a device or simulator
3. Build and run the project (⌘+R)

## Core Concepts

### How Samwise Works

1. **Run Creation**: A runner creates a run with a target distance and gets a shareable link
2. **Message Recording**: Friends use the share link to record voice messages for specific distance markers
3. **Active Running**: During the run, GPS tracks distance and triggers message playback at exact markers
4. **Privacy First**: No location coordinates are stored, only distance calculations

### Key Features

- **Privacy-Focused**: No user accounts, no location storage, automatic data cleanup
- **GPS Distance Tracking**: Accurate distance measurement without coordinate storage  
- **Voice Message Delivery**: Friends record encouragement for specific distance markers
- **Share-Based System**: Simple link sharing without registration requirements
- **Automatic Cleanup**: All data expires after 7 days for privacy

## Architecture Overview

```
iOS App (SwiftUI)
    ↕ HTTPS API calls
Backend (Node.js/Express)
    ↕ MongoDB queries  
Database (MongoDB + TTL)
    ↕ File system
Audio Storage (Local/S3)
```

## Your First Run

### Creating a Run (iOS App)
1. Open Samwise on your iOS device
2. Tap "Start a Run"
3. Enter run title and target distance
4. Share the generated link with friends

### Adding Messages (Web/Share Link)
1. Friends open the shared link
2. Choose a distance marker (e.g., 2.5 km)
3. Record a voice message
4. Submit the encouragement

### Running with Messages
1. Start the run in the iOS app
2. Begin running with GPS tracking
3. Messages automatically play at distance markers
4. Complete the run to see final statistics

## Development Workflow

### Backend Development
```bash
# Start development server with auto-reload
npm run dev

# Run tests
npm test

# Check code style (when linter is added)
npm run lint
```

### iOS Development
- Use Xcode's built-in tools for development
- Test on device for GPS accuracy
- Use simulator for UI development
- Check location permissions in Settings

### Testing the Integration
1. Start the backend server (`npm run dev`)
2. Run the iOS app in simulator
3. Create a test run
4. Use the backend API directly to add test messages:

```bash
# Create a run
curl -X POST http://localhost:3000/api/runs \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Run","targetDistance":5.0}'

# Add a test message
curl -X POST http://localhost:3000/api/runs/{shareId}/messages \
  -H "Content-Type: application/json" \
  -d '{"distanceMarker":1.0,"senderName":"Test Friend","message":"You got this!"}'
```

## Common Development Tasks

### Adding New API Endpoints
1. Define the route in `backend/src/routes/`
2. Implement the controller in `backend/src/controllers/`
3. Add data validation
4. Update API documentation in `docs/api/endpoints.md`

### Adding New iOS Views
1. Create SwiftUI view in appropriate `ios/Samwise/Views/` subdirectory
2. Add ViewModel if needed in `ios/Samwise/ViewModels/`
3. Update navigation in `ContentView.swift`
4. Add preview for development

### Database Schema Changes
1. Update model in `backend/src/models/`
2. Add migration logic if needed
3. Update documentation in `docs/database-schema.md`
4. Test with existing data

## Troubleshooting

### Backend Issues
- **MongoDB connection failed**: Check if MongoDB is running and connection string is correct
- **Port already in use**: Change PORT in `.env` or kill process using port 3000
- **File upload fails**: Check `backend/uploads/` directory permissions

### iOS Issues
- **Location not updating**: Enable location permissions in Settings > Privacy > Location Services
- **Audio not playing**: Check device volume and silent mode
- **Build fails**: Clean build folder (Product → Clean Build Folder)

### API Communication Issues
- **Network requests fail**: Check backend server is running on correct port
- **CORS errors**: Verify FRONTEND_URL in backend `.env` matches iOS app expectations

## Next Steps

1. **Explore the codebase**: Check out the models, services, and views
2. **Run the test suite**: Understand the testing approach
3. **Read the documentation**: Browse `docs/` for detailed architecture information
4. **Try the API**: Use Postman or curl to interact with endpoints
5. **Build a feature**: Start with a small enhancement or bug fix

## Resources

- [API Documentation](api/endpoints.md)
- [iOS Architecture](ios/architecture.md) 
- [Database Schema](database-schema.md)
- [System Design](architecture/system-design.md)

## Getting Help

- Check existing documentation in the `docs/` directory
- Review code comments and inline documentation
- Look at similar implementations in the codebase
- Test API endpoints with curl or Postman