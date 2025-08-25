const express = require('express');
const router = express.Router();
const runController = require('../controllers/runController');

router.post('/', runController.createRun);

router.get('/:shareId', runController.getRunByShareId);

router.patch('/:shareId/start', runController.startRun);

router.patch('/:shareId/complete', runController.completeRun);

router.post('/:shareId/messages', runController.addVoiceMessage);

router.get('/:shareId/messages', runController.getVoiceMessages);

router.patch('/:shareId/messages/:messageId/played', runController.markMessageAsPlayed);

module.exports = router;