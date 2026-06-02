//
//  APIService.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 06/05/2026.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    func sendAudio(fileURL: URL, allowVoiceData: Bool, completion: @escaping ([String: Any]?) -> Void) {
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/predict")!)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let filename = fileURL.lastPathComponent
        guard let audioData = try? Data(contentsOf: fileURL) else {
            completion(nil)
            return
        }
        
        // File
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: audio/wav\r\n\r\n")
        body.append(audioData)
        body.append("\r\n")
        
        // Boolean flag
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"allow_voice_data\"\r\n\r\n")
        body.append(allowVoiceData ? "true" : "false")
        body.append("\r\n")
        
        // End boundary
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error:", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            completion(json)
            
            print(String(data: data, encoding: .utf8) ?? "nil")
            
        }.resume()
        
        print("ALLOW VOICE DATA:", allowVoiceData)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
