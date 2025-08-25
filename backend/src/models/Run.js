const mongoose = require('mongoose');

const voiceMessageSchema = new mongoose.Schema({
  distanceMarker: {
    type: Number,
    required: true,
    min: 0
  },
  audioFilePath: {
    type: String,
    required: false
  },
  senderName: {
    type: String,
    required: true,
    trim: true,
    maxlength: 50
  },
  message: {
    type: String,
    maxlength: 500
  },
  isPlayed: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

const runSchema = new mongoose.Schema({
  shareId: {
    type: String,
    unique: true,
    required: true
  },
  title: {
    type: String,
    required: true,
    trim: true,
    maxlength: 100
  },
  targetDistance: {
    type: Number,
    required: true,
    min: 0.1,
    max: 1000
  },
  status: {
    type: String,
    enum: ['created', 'active', 'completed'],
    default: 'created'
  },
  actualDistance: {
    type: Number,
    default: 0,
    min: 0
  },
  duration: {
    type: Number,
    default: 0,
    min: 0
  },
  completedAt: {
    type: Date
  },
  voiceMessages: [voiceMessageSchema],
  expiresAt: {
    type: Date,
    default: () => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    expires: 0
  }
}, {
  timestamps: true
});

runSchema.methods.getPublicData = function() {
  return {
    shareId: this.shareId,
    title: this.title,
    targetDistance: this.targetDistance,
    status: this.status,
    actualDistance: this.actualDistance,
    duration: this.duration,
    completedAt: this.completedAt,
    messageCount: this.voiceMessages.length,
    createdAt: this.createdAt
  };
};

module.exports = mongoose.model('Run', runSchema);