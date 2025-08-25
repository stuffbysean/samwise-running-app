import Foundation
import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject {
    
    @Published var isPlaying = false
    @Published var currentMessage: VoiceMessage?
    @Published var downloadProgress: Double = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var audioSession: AVAudioSession
    private var downloadTask: URLSessionDownloadTask?
    private let session = URLSession.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        self.audioSession = AVAudioSession.sharedInstance()
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try audioSession.setCategory(.playback, options: [.mixWithOthers, .duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
}

// MARK: - Audio Playback
extension AudioManager {
    
    func playMessage(_ message: VoiceMessage, completion: @escaping (Bool) -> Void) {
        currentMessage = message
        
        if let audioURL = message.audioURL {
            playAudioFromURL(audioURL) { [weak self] success in
                if !success && message.message != nil {
                    self?.speakText(message.message!, completion: completion)
                } else {
                    completion(success)
                }
            }
        } else if let text = message.message {
            speakText(text, completion: completion)
        } else {
            completion(false)
        }
    }
    
    private func playAudioFromURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        if url.isFileURL {
            playLocalAudio(url, completion: completion)
        } else {
            downloadAndPlayAudio(url, completion: completion)
        }
    }
    
    private func playLocalAudio(_ url: URL, completion: @escaping (Bool) -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            
            let success = audioPlayer?.play() ?? false
            isPlaying = success
            completion(success)
        } catch {
            print("Failed to play local audio: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func downloadAndPlayAudio(_ url: URL, completion: @escaping (Bool) -> Void) {
        downloadProgress = 0
        
        downloadTask = session.downloadTask(with: url) { [weak self] localURL, response, error in
            DispatchQueue.main.async {
                guard let self = self,
                      let localURL = localURL,
                      error == nil else {
                    print("Failed to download audio: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                    return
                }
                
                let tempURL = self.createTempAudioFile(from: localURL)
                if let tempURL = tempURL {
                    self.playLocalAudio(tempURL, completion: completion)
                } else {
                    completion(false)
                }
            }
        }
        
        downloadTask?.resume()
    }
    
    private func createTempAudioFile(from sourceURL: URL) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        
        do {
            try FileManager.default.copyItem(at: sourceURL, to: tempURL)
            return tempURL
        } catch {
            print("Failed to create temp audio file: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func speakText(_ text: String, completion: @escaping (Bool) -> Void) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 0.8
        
        let synthesizer = AVSpeechSynthesizer()
        
        let delegate = SpeechDelegate { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
        
        synthesizer.delegate = delegate
        synthesizer.speak(utterance)
        
        isPlaying = true
        
        objc_setAssociatedObject(synthesizer, &AssociatedKeys.delegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        downloadTask?.cancel()
        isPlaying = false
        currentMessage = nil
        downloadProgress = 0
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resumePlayback() {
        let success = audioPlayer?.play() ?? false
        isPlaying = success
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.currentMessage = nil
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio decode error: \(error?.localizedDescription ?? "Unknown error")")
        DispatchQueue.main.async {
            self.isPlaying = false
            self.currentMessage = nil
        }
    }
}

// MARK: - Audio Session Management
extension AudioManager {
    
    func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let interruptionTypeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue) else {
            return
        }
        
        switch interruptionType {
        case .began:
            pausePlayback()
        case .ended:
            if let interruptionOptionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let interruptionOptions = AVAudioSession.InterruptionOptions(rawValue: interruptionOptionsValue)
                if interruptionOptions.contains(.shouldResume) {
                    resumePlayback()
                }
            }
        @unknown default:
            break
        }
    }
    
    func configureForRunning() {
        do {
            try audioSession.setCategory(.playback, options: [.duckOthers, .allowBluetoothA2DP])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session for running: \(error.localizedDescription)")
        }
    }
}

// MARK: - Speech Synthesis Delegate
private class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    private let completion: (Bool) -> Void
    
    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion(true)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        completion(false)
    }
}

// MARK: - Associated Object Keys
private struct AssociatedKeys {
    static var delegateKey = "SpeechDelegateKey"
}

// MARK: - Audio File Management
extension AudioManager {
    
    func clearTemporaryAudioFiles() {
        let tempDirectory = FileManager.default.temporaryDirectory
        
        do {
            let tempFiles = try FileManager.default.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: nil)
            
            for file in tempFiles {
                if file.pathExtension == "m4a" || file.pathExtension == "mp3" || file.pathExtension == "wav" {
                    try? FileManager.default.removeItem(at: file)
                }
            }
        } catch {
            print("Failed to clear temporary audio files: \(error.localizedDescription)")
        }
    }
    
    func getCacheSize() -> Int64 {
        let tempDirectory = FileManager.default.temporaryDirectory
        var totalSize: Int64 = 0
        
        do {
            let tempFiles = try FileManager.default.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: [.fileSizeKey])
            
            for file in tempFiles {
                if file.pathExtension == "m4a" || file.pathExtension == "mp3" || file.pathExtension == "wav" {
                    let resourceValues = try file.resourceValues(forKeys: [.fileSizeKey])
                    totalSize += Int64(resourceValues.fileSize ?? 0)
                }
            }
        } catch {
            print("Failed to calculate cache size: \(error.localizedDescription)")
        }
        
        return totalSize
    }
}

// MARK: - Preview Support
extension AudioManager {
    
    static func createPreviewManager() -> AudioManager {
        let manager = AudioManager()
        return manager
    }
    
    func playTestMessage() {
        let testMessage = VoiceMessage(distanceMarker: 1.0, senderName: "Test", message: "This is a test message for Samwise!")
        
        playMessage(testMessage) { success in
            print("Test message played successfully: \(success)")
        }
    }
}