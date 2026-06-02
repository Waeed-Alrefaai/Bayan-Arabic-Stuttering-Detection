//
//  MainViewModel.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI
internal import Combine
import AVFoundation

class MainViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var showPrivacy = false
    @Published var result: String? = nil
    @Published var audioURL: URL?
    @Published var detectedLabels: [String] = []
    @Published var confidence: Double = 0.0
    var recorder: AVAudioRecorder?

    func startRecording() {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("recording.wav")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsFloatKey: false
            ]
            
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            
            audioURL = url
            
            isRecording = true
            
        } catch {
            print("Recording failed:", error)
        }
    }

    func stopRecording() {
        recorder?.stop()
        isRecording = false
    }

    func acceptPrivacy() {
        showPrivacy = false
    }

    func refusePrivacy() {
        showPrivacy = false
    }
    
    func processAudio(fileURL: URL, allowVoiceData: Bool, onFinish: @escaping () -> Void) {
        
        APIService.shared.sendAudio(
            fileURL: fileURL,
            allowVoiceData: allowVoiceData
        ) { result in
            
            DispatchQueue.main.async {
                
                guard let result = result else {
                    onFinish()
                    return
                }
                
                self.detectedLabels = result["predicted_labels"] as? [String] ?? []
                
                if let probs = result["probabilities"] as? [String: Double] {
                    let strongSignals = probs.values.filter { $0 > 0.5 }
                    self.confidence = strongSignals.reduce(0, +) / max(Double(strongSignals.count), 1)
                }
                
                onFinish()
            }
        }
    }
}
