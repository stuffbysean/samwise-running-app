class SamwiseWebApp {
    constructor() {
        this.shareId = null;
        this.runData = null;
        this.mediaRecorder = null;
        this.audioChunks = [];
        this.recordedBlob = null;
        this.recordingStartTime = null;
        this.recordingTimer = null;
        
        this.init();
    }

    init() {
        this.extractShareId();
        this.bindEvents();
        this.loadRunData();
    }

    extractShareId() {
        const path = window.location.pathname;
        const match = path.match(/\/share\/([a-f0-9\-]+)/);
        if (match) {
            this.shareId = match[1];
        } else {
            this.showError('Invalid share link. Please check the URL and try again.');
        }
    }

    bindEvents() {
        // Recording controls
        document.getElementById('record-btn').addEventListener('click', () => this.startRecording());
        document.getElementById('stop-btn').addEventListener('click', () => this.stopRecording());
        document.getElementById('play-btn').addEventListener('click', () => this.playRecording());
        document.getElementById('reset-btn').addEventListener('click', () => this.resetRecording());
        
        // Form submission
        document.getElementById('message-form').addEventListener('submit', (e) => this.submitMessage(e));
        
        // Success actions
        document.getElementById('send-another').addEventListener('click', () => this.resetForm());
        
        // Distance marker validation
        document.getElementById('distance-marker').addEventListener('input', (e) => this.validateDistanceMarker(e));
    }

    async loadRunData() {
        if (!this.shareId) return;

        try {
            this.showLoading();
            
            const response = await fetch(`/api/runs/${this.shareId}`);
            if (!response.ok) {
                throw new Error('Run not found');
            }
            
            const data = await response.json();
            this.runData = data.run;
            
            await this.loadExistingMessages();
            this.populateRunInfo();
            this.showMainContent();
            
        } catch (error) {
            console.error('Failed to load run data:', error);
            this.showError('Could not load run information. Please check the link and try again.');
        }
    }

    async loadExistingMessages() {
        try {
            const response = await fetch(`/api/runs/${this.shareId}/messages`);
            if (response.ok) {
                const data = await response.json();
                this.populateExistingMessages(data.messages || []);
            }
        } catch (error) {
            console.error('Failed to load existing messages:', error);
        }
    }

    populateRunInfo() {
        document.getElementById('run-title').textContent = this.runData.title;
        document.getElementById('run-distance').textContent = `${this.runData.targetDistance} km`;
        document.getElementById('run-date').textContent = this.formatDate(this.runData.createdAt);
        document.getElementById('message-count').textContent = `${this.runData.messageCount} messages`;
        
        // Update status badge
        const statusBadge = document.getElementById('run-status-badge');
        statusBadge.textContent = this.getStatusText(this.runData.status);
        statusBadge.className = `status-badge status-${this.runData.status}`;
        
        // Set max distance marker
        document.getElementById('distance-marker').max = this.runData.targetDistance;
    }

    populateExistingMessages(messages) {
        const messagesSection = document.getElementById('existing-messages');
        const messagesList = document.getElementById('messages-list');
        
        if (messages.length === 0) {
            messagesSection.classList.add('hidden');
            return;
        }
        
        messagesSection.classList.remove('hidden');
        messagesList.innerHTML = '';
        
        // Sort messages by distance marker
        messages.sort((a, b) => a.distanceMarker - b.distanceMarker);
        
        messages.forEach(message => {
            const messageEl = document.createElement('div');
            messageEl.className = 'message-item';
            messageEl.innerHTML = `
                <div class="message-header">
                    <strong>${this.escapeHtml(message.senderName)}</strong>
                    <span class="distance-tag">${message.distanceMarker} km</span>
                </div>
                ${message.message ? `<p class="message-text">${this.escapeHtml(message.message)}</p>` : ''}
                <div class="message-meta">
                    <i class="fas fa-${message.audioFilePath ? 'microphone' : 'comment'}"></i>
                    <span>${message.audioFilePath ? 'Voice message' : 'Text message'}</span>
                </div>
            `;
            messagesList.appendChild(messageEl);
        });
    }

    async startRecording() {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ 
                audio: {
                    echoCancellation: true,
                    noiseSuppression: true,
                    sampleRate: 44100
                } 
            });
            
            this.mediaRecorder = new MediaRecorder(stream, {
                mimeType: MediaRecorder.isTypeSupported('audio/webm') ? 'audio/webm' : 'audio/mp4'
            });
            
            this.audioChunks = [];
            
            this.mediaRecorder.ondataavailable = (event) => {
                this.audioChunks.push(event.data);
            };
            
            this.mediaRecorder.onstop = () => {
                this.recordedBlob = new Blob(this.audioChunks, { 
                    type: this.mediaRecorder.mimeType 
                });
                this.setupAudioPreview();
                this.updateUIAfterRecording();
            };
            
            this.mediaRecorder.start();
            this.recordingStartTime = Date.now();
            this.startRecordingTimer();
            this.updateUIForRecording();
            
        } catch (error) {
            console.error('Failed to start recording:', error);
            this.showError('Could not access microphone. Please check your permissions and try again.');
        }
    }

    stopRecording() {
        if (this.mediaRecorder && this.mediaRecorder.state === 'recording') {
            this.mediaRecorder.stop();
            this.mediaRecorder.stream.getTracks().forEach(track => track.stop());
            this.stopRecordingTimer();
        }
    }

    playRecording() {
        const audioPreview = document.getElementById('audio-preview');
        audioPreview.play();
    }

    resetRecording() {
        this.recordedBlob = null;
        this.audioChunks = [];
        
        const audioPreview = document.getElementById('audio-preview');
        audioPreview.src = '';
        
        this.resetRecordingUI();
    }

    setupAudioPreview() {
        const audioPreview = document.getElementById('audio-preview');
        const url = URL.createObjectURL(this.recordedBlob);
        audioPreview.src = url;
        audioPreview.classList.remove('hidden');
    }

    startRecordingTimer() {
        this.recordingTimer = setInterval(() => {
            const elapsed = Date.now() - this.recordingStartTime;
            const seconds = Math.floor(elapsed / 1000);
            const minutes = Math.floor(seconds / 60);
            const remainingSeconds = seconds % 60;
            
            document.getElementById('recording-timer').textContent = 
                `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
        }, 1000);
    }

    stopRecordingTimer() {
        if (this.recordingTimer) {
            clearInterval(this.recordingTimer);
            this.recordingTimer = null;
        }
    }

    updateUIForRecording() {
        document.getElementById('record-btn').classList.add('hidden');
        document.getElementById('stop-btn').classList.remove('hidden');
        document.getElementById('recording-indicator').classList.add('recording');
        document.getElementById('recording-text').textContent = 'Recording...';
        document.getElementById('recording-timer').classList.remove('hidden');
    }

    updateUIAfterRecording() {
        document.getElementById('stop-btn').classList.add('hidden');
        document.getElementById('play-btn').classList.remove('hidden');
        document.getElementById('reset-btn').classList.remove('hidden');
        document.getElementById('submit-btn').classList.remove('hidden');
        
        document.getElementById('recording-indicator').classList.remove('recording');
        document.getElementById('recording-text').textContent = 'Recording completed';
    }

    resetRecordingUI() {
        document.getElementById('record-btn').classList.remove('hidden');
        document.getElementById('stop-btn').classList.add('hidden');
        document.getElementById('play-btn').classList.add('hidden');
        document.getElementById('reset-btn').classList.add('hidden');
        document.getElementById('submit-btn').classList.add('hidden');
        
        document.getElementById('recording-indicator').classList.remove('recording');
        document.getElementById('recording-text').textContent = 'Ready to record';
        document.getElementById('recording-timer').classList.add('hidden');
        document.getElementById('audio-preview').classList.add('hidden');
    }

    validateDistanceMarker(event) {
        const value = parseFloat(event.target.value);
        const maxDistance = this.runData ? this.runData.targetDistance : Infinity;
        
        if (value > maxDistance) {
            event.target.setCustomValidity(`Distance cannot exceed ${maxDistance} km`);
        } else if (value <= 0) {
            event.target.setCustomValidity('Distance must be greater than 0');
        } else {
            event.target.setCustomValidity('');
        }
    }

    async submitMessage(event) {
        event.preventDefault();
        
        const formData = new FormData();
        const senderName = document.getElementById('sender-name').value.trim();
        const distanceMarker = parseFloat(document.getElementById('distance-marker').value);
        // Normalize the message text to handle potential control characters
        const messageText = document.getElementById('message-text').value.trim().replace(/\r\n/g, '\n').replace(/\r/g, '\n');
        
        if (!senderName) {
            this.showError('Please enter your name');
            return;
        }
        
        if (!distanceMarker || distanceMarker <= 0) {
            this.showError('Please enter a valid distance marker');
            return;
        }
        
        this.showSubmitting();
        
        try {
            let audioFilePath = null;
            
            // Upload audio file if recorded
            if (this.recordedBlob) {
                audioFilePath = await this.uploadAudioFile();
            }
            
            // Submit message
            const messageData = {
                senderName: senderName,
                distanceMarker: distanceMarker,
                message: messageText || null,
                audioFilePath: audioFilePath
            };
            
            // Debug logging
            console.log('Message data:', messageData);
            console.log('JSON string:', JSON.stringify(messageData));
            
            const response = await fetch(`/api/runs/${this.shareId}/messages`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(messageData)
            });
            
            if (!response.ok) {
                throw new Error('Failed to submit message');
            }
            
            this.showSuccess(distanceMarker);
            
        } catch (error) {
            console.error('Failed to submit message:', error);
            this.showError('Failed to send message. Please try again.');
        }
    }

    async uploadAudioFile() {
        const formData = new FormData();
        const fileName = `voice-message-${Date.now()}.webm`;
        formData.append('audio', this.recordedBlob, fileName);
        
        const response = await fetch('/api/audio/upload', {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            throw new Error('Failed to upload audio file');
        }
        
        const data = await response.json();
        return data.path;
    }

    showSuccess(distance) {
        document.getElementById('main-content').classList.add('hidden');
        document.getElementById('success-message').classList.remove('hidden');
        document.getElementById('success-distance').textContent = `${distance} km`;
    }

    resetForm() {
        document.getElementById('message-form').reset();
        this.resetRecording();
        document.getElementById('success-message').classList.add('hidden');
        document.getElementById('main-content').classList.remove('hidden');
        this.loadExistingMessages(); // Refresh message list
    }

    showSubmitting() {
        const submitBtn = document.getElementById('submit-btn');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
    }

    showLoading() {
        document.getElementById('loading').classList.remove('hidden');
        document.getElementById('main-content').classList.add('hidden');
        document.getElementById('error').classList.add('hidden');
    }

    showMainContent() {
        document.getElementById('loading').classList.add('hidden');
        document.getElementById('main-content').classList.remove('hidden');
        document.getElementById('error').classList.add('hidden');
    }

    showError(message) {
        document.getElementById('loading').classList.add('hidden');
        document.getElementById('main-content').classList.add('hidden');
        document.getElementById('error').classList.remove('hidden');
        document.getElementById('error-message').textContent = message;
    }

    getStatusText(status) {
        switch (status) {
            case 'created': return 'Ready for Messages';
            case 'active': return 'Run in Progress';
            case 'completed': return 'Run Completed';
            default: return 'Unknown Status';
        }
    }

    formatDate(dateString) {
        const date = new Date(dateString);
        const today = new Date();
        const diffTime = Math.abs(today - date);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        
        if (diffDays === 1) return 'Today';
        if (diffDays === 2) return 'Yesterday';
        if (diffDays <= 7) return `${diffDays - 1} days ago`;
        
        return date.toLocaleDateString();
    }

    escapeHtml(unsafe) {
        return unsafe
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new SamwiseWebApp();
});