require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const mongoose = require('mongoose');
const path = require('path');
const { startTestDb } = require('./utils/setupTestDb');

const runRoutes = require('./routes/runRoutes');
const audioRoutes = require('./routes/audioRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests from this IP, please try again later.'
});

app.use(helmet({
  contentSecurityPolicy: false, // Allow inline scripts for our web interface
}));
app.use(compression());
app.use(morgan('combined'));
app.use(limiter);
// CORS configuration for development and production
const allowedOrigins = [
  'http://localhost:3001',
  'http://192.168.2.16:3001',
  'http://192.168.2.16:3000'
];

// Add production origins if in production
if (process.env.NODE_ENV === 'production') {
  allowedOrigins.push(process.env.FRONTEND_URL);
  // Allow Railway subdomain pattern
  allowedOrigins.push(/\.railway\.app$/);
}

app.use(cors({
  origin: allowedOrigins,
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Serve static files from public directory
app.use(express.static(path.join(__dirname, '../public')));

// Start MongoDB connection (with fallback to in-memory for development)
const connectToDatabase = async () => {
  try {
    // Try connecting to the configured MongoDB URI first
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/samwise', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000, // 5 second timeout
    });
    console.log('Connected to MongoDB:', process.env.MONGODB_URI || 'mongodb://localhost:27017/samwise');
  } catch (error) {
    console.log('Local MongoDB not available, starting in-memory database for development...');
    try {
      // Start in-memory MongoDB for development
      const memoryDbUri = await startTestDb();
      await mongoose.connect(memoryDbUri, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      });
      console.log('Connected to in-memory MongoDB:', memoryDbUri);
    } catch (memError) {
      console.error('Failed to start in-memory MongoDB:', memError);
      process.exit(1);
    }
  }
};

connectToDatabase();

app.use('/api/runs', runRoutes);
app.use('/api/audio', audioRoutes);

// Share page route - serve the web interface for specific share links
app.get('/share/:shareId', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  
  // Handle JSON parsing errors specifically
  if (err.statusCode === 400) {
    return res.status(400).json({ 
      error: 'Invalid request format',
      message: err.message
    });
  }
  
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

const HOST = process.env.NODE_ENV === 'production' ? undefined : '0.0.0.0';

app.listen(PORT, HOST, () => {
  console.log(`Samwise server running on port ${PORT}`);
  if (process.env.NODE_ENV !== 'production') {
    console.log(`Local: http://localhost:${PORT}`);
    console.log(`Network: http://192.168.2.16:${PORT}`);
  }
});