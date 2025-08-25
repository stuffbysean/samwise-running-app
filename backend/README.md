# Samwise Backend API

Express.js backend for the Samwise running companion app.

## Quick Start

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up environment:
   ```bash
   cp .env.example .env
   # Edit .env with your MongoDB connection string
   ```

3. Start development server:
   ```bash
   npm run dev
   ```

## Environment Variables

Create a `.env` file with these variables:

```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/samwise
FRONTEND_URL=http://localhost:3001
JWT_SECRET=your-super-secret-jwt-key
```

## API Documentation

See [docs/api/endpoints.md](../docs/api/endpoints.md) for complete API documentation.

## Development

- `npm run dev` - Start development server with nodemon
- `npm start` - Start production server
- `npm test` - Run test suite
- `npm test:watch` - Run tests in watch mode

## Project Structure

```
src/
├── controllers/    # Request handlers
├── models/        # Database models
├── routes/        # API routes
├── middleware/    # Custom middleware
├── services/      # Business logic
├── utils/         # Utility functions
└── server.js      # Application entry point
```

## Features

- RESTful API design
- MongoDB integration with Mongoose
- File upload handling with Multer
- Rate limiting and security headers
- Automatic data cleanup with TTL
- CORS configuration
- Error handling and logging

## Database

The app uses MongoDB with automatic cleanup:
- Runs expire after 7 days
- Voice messages are embedded in run documents
- No location data is stored (privacy-first design)