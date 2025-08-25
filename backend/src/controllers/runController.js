const { v4: uuidv4 } = require('uuid');
const Run = require('../models/Run');

exports.createRun = async (req, res) => {
  try {
    const { title, targetDistance } = req.body;
    
    if (!title || !targetDistance) {
      return res.status(400).json({ 
        error: 'Title and target distance are required' 
      });
    }
    
    if (targetDistance <= 0 || targetDistance > 1000) {
      return res.status(400).json({ 
        error: 'Target distance must be between 0.1 and 1000 km' 
      });
    }
    
    const run = new Run({
      shareId: uuidv4(),
      title: title.trim(),
      targetDistance: parseFloat(targetDistance)
    });
    
    await run.save();
    
    res.status(201).json({
      success: true,
      run: run.getPublicData(),
      shareLink: `/share/${run.shareId}`
    });
  } catch (error) {
    console.error('Create run error:', error);
    res.status(500).json({ error: 'Failed to create run' });
  }
};

exports.getRunByShareId = async (req, res) => {
  try {
    const { shareId } = req.params;
    
    const run = await Run.findOne({ shareId });
    if (!run) {
      return res.status(404).json({ error: 'Run not found' });
    }
    
    res.json({
      success: true,
      run: run.getPublicData()
    });
  } catch (error) {
    console.error('Get run error:', error);
    res.status(500).json({ error: 'Failed to retrieve run' });
  }
};

exports.startRun = async (req, res) => {
  try {
    const { shareId } = req.params;
    
    const run = await Run.findOne({ shareId });
    if (!run) {
      return res.status(404).json({ error: 'Run not found' });
    }
    
    if (run.status !== 'created') {
      return res.status(400).json({ 
        error: 'Run can only be started from created status' 
      });
    }
    
    run.status = 'active';
    await run.save();
    
    res.json({
      success: true,
      run: run.getPublicData()
    });
  } catch (error) {
    console.error('Start run error:', error);
    res.status(500).json({ error: 'Failed to start run' });
  }
};

exports.completeRun = async (req, res) => {
  try {
    const { shareId } = req.params;
    const { actualDistance, duration } = req.body;
    
    const run = await Run.findOne({ shareId });
    if (!run) {
      return res.status(404).json({ error: 'Run not found' });
    }
    
    if (run.status !== 'active') {
      return res.status(400).json({ 
        error: 'Only active runs can be completed' 
      });
    }
    
    run.status = 'completed';
    run.actualDistance = parseFloat(actualDistance) || 0;
    run.duration = parseInt(duration) || 0;
    run.completedAt = new Date();
    
    await run.save();
    
    res.json({
      success: true,
      run: run.getPublicData()
    });
  } catch (error) {
    console.error('Complete run error:', error);
    res.status(500).json({ error: 'Failed to complete run' });
  }
};

exports.addVoiceMessage = async (req, res) => {
  try {
    const { shareId } = req.params;
    const { distanceMarker, senderName, message, audioFilePath } = req.body;
    
    const run = await Run.findOne({ shareId });
    if (!run) {
      return res.status(404).json({ error: 'Run not found' });
    }
    
    if (run.status === 'completed') {
      return res.status(400).json({ 
        error: 'Cannot add messages to completed runs' 
      });
    }
    
    if (!distanceMarker || !senderName) {
      return res.status(400).json({ 
        error: 'Distance marker and sender name are required' 
      });
    }
    
    if (distanceMarker <= 0 || distanceMarker > run.targetDistance) {
      return res.status(400).json({ 
        error: `Distance marker must be between 0 and ${run.targetDistance} km` 
      });
    }
    
    const voiceMessage = {
      distanceMarker: parseFloat(distanceMarker),
      senderName: senderName.trim(),
      message: message?.trim(),
      audioFilePath: audioFilePath
    };
    
    run.voiceMessages.push(voiceMessage);
    await run.save();
    
    const addedMessage = run.voiceMessages[run.voiceMessages.length - 1];
    
    res.status(201).json({
      success: true,
      message: {
        id: addedMessage._id,
        distanceMarker: addedMessage.distanceMarker,
        senderName: addedMessage.senderName,
        message: addedMessage.message,
        audioFilePath: addedMessage.audioFilePath,
        createdAt: addedMessage.createdAt
      }
    });
  } catch (error) {
    console.error('Add voice message error:', error);
    res.status(500).json({ error: 'Failed to add voice message' });
  }
};

exports.getVoiceMessages = async (req, res) => {
  try {
    const { shareId } = req.params;
    
    const run = await Run.findOne({ shareId });
    if (!run) {
      return res.status(404).json({ error: 'Run not found' });
    }
    
    const messages = run.voiceMessages
      .sort((a, b) => a.distanceMarker - b.distanceMarker)
      .map(msg => ({
        id: msg._id,
        distanceMarker: msg.distanceMarker,
        senderName: msg.senderName,
        message: msg.message,
        audioFilePath: msg.audioFilePath,
        isPlayed: msg.isPlayed,
        createdAt: msg.createdAt
      }));
    
    res.json({
      success: true,
      messages: messages
    });
  } catch (error) {
    console.error('Get voice messages error:', error);
    res.status(500).json({ error: 'Failed to retrieve voice messages' });
  }
};

exports.markMessageAsPlayed = async (req, res) => {
  try {
    const { shareId, messageId } = req.params;
    
    const run = await Run.findOne({ shareId });
    if (!run) {
      return res.status(404).json({ error: 'Run not found' });
    }
    
    const message = run.voiceMessages.id(messageId);
    if (!message) {
      return res.status(404).json({ error: 'Message not found' });
    }
    
    message.isPlayed = true;
    await run.save();
    
    res.json({
      success: true,
      message: 'Message marked as played'
    });
  } catch (error) {
    console.error('Mark message as played error:', error);
    res.status(500).json({ error: 'Failed to mark message as played' });
  }
};