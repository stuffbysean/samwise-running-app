import Foundation

class APIService: ObservableObject {
    private let baseURL = "http://192.168.2.16:3000/api"
    private let session = URLSession.shared
    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError
        case serverError(String)
        case networkError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Failed to decode response"
            case .serverError(let message):
                return "Server error: \(message)"
            case .networkError(let message):
                return "Network error: \(message)"
            }
        }
    }
}

// MARK: - Run Management
extension APIService {
    
    func createRun(title: String, targetDistance: Double) async throws -> APIRunResponse {
        guard let url = URL(string: "\(baseURL)/runs") else {
            throw APIError.invalidURL
        }
        
        let requestBody = CreateRunRequest(title: title, targetDistance: targetDistance)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw APIError.decodingError
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 201 else {
                    if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw APIError.serverError(errorData.error)
                    }
                    throw APIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(APIRunResponse.self, from: data)
            return apiResponse
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
    
    func getRunByShareId(_ shareId: String) async throws -> APIRunDetailsResponse {
        guard let url = URL(string: "\(baseURL)/runs/\(shareId)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw APIError.serverError(errorData.error)
                    }
                    throw APIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(APIRunDetailsResponse.self, from: data)
            return apiResponse
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
    
    func startRun(shareId: String) async throws -> APIRunDetailsResponse {
        guard let url = URL(string: "\(baseURL)/runs/\(shareId)/start") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw APIError.serverError(errorData.error)
                    }
                    throw APIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(APIRunDetailsResponse.self, from: data)
            return apiResponse
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
    
    func completeRun(shareId: String, actualDistance: Double, duration: TimeInterval) async throws -> APIRunDetailsResponse {
        guard let url = URL(string: "\(baseURL)/runs/\(shareId)/complete") else {
            throw APIError.invalidURL
        }
        
        let requestBody = CompleteRunRequest(actualDistance: actualDistance, duration: Int(duration))
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw APIError.decodingError
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw APIError.serverError(errorData.error)
                    }
                    throw APIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(APIRunDetailsResponse.self, from: data)
            return apiResponse
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}

// MARK: - Voice Messages
extension APIService {
    
    func getVoiceMessages(for shareId: String) async throws -> APIVoiceMessagesResponse {
        guard let url = URL(string: "\(baseURL)/runs/\(shareId)/messages") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw APIError.serverError(errorData.error)
                    }
                    throw APIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
            
            let apiResponse = try JSONDecoder().decode(APIVoiceMessagesResponse.self, from: data)
            return apiResponse
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
    
    func markMessageAsPlayed(shareId: String, messageId: String) async throws {
        guard let url = URL(string: "\(baseURL)/runs/\(shareId)/messages/\(messageId)/played") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw APIError.serverError(errorData.error)
                    }
                    throw APIError.serverError("HTTP \(httpResponse.statusCode)")
                }
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}

// MARK: - API Data Models
struct CreateRunRequest: Codable {
    let title: String
    let targetDistance: Double
}

struct CompleteRunRequest: Codable {
    let actualDistance: Double
    let duration: Int
}

struct APIRunResponse: Codable {
    let success: Bool
    let run: APIRun
    let shareLink: String
}

struct APIRunDetailsResponse: Codable {
    let success: Bool
    let run: APIRun
}

struct APIVoiceMessagesResponse: Codable {
    let success: Bool
    let messages: [APIVoiceMessage]
}

struct APIErrorResponse: Codable {
    let error: String
}

struct APIRun: Codable {
    let shareId: String
    let title: String
    let targetDistance: Double
    let status: String
    let actualDistance: Double
    let duration: Int
    let messageCount: Int
    let createdAt: String
    let completedAt: String?
}

struct APIVoiceMessage: Codable {
    let id: String
    let distanceMarker: Double
    let senderName: String
    let message: String?
    let audioFilePath: String?
    let isPlayed: Bool
    let createdAt: String
}

// MARK: - Model Conversion Extensions
extension APIRun {
    func toLocalRun() -> Run {
        let run = Run(title: self.title, targetDistance: self.targetDistance)
        run.shareLink = "http://localhost:3000/share/\(self.shareId)"
        run.isActive = self.status == "active"
        run.actualDistance = self.actualDistance
        run.duration = TimeInterval(self.duration)
        
        // Parse dates
        if let createdDate = ISO8601DateFormatter().date(from: self.createdAt) {
            run.createdAt = createdDate
        }
        
        if let completedAtString = self.completedAt,
           let completedDate = ISO8601DateFormatter().date(from: completedAtString) {
            run.completedAt = completedDate
        }
        
        return run
    }
}

extension APIVoiceMessage {
    func toLocalVoiceMessage() -> VoiceMessage {
        let message = VoiceMessage(
            distanceMarker: self.distanceMarker,
            senderName: self.senderName,
            message: self.message
        )
        
        message.serverId = self.id
        message.isPlayed = self.isPlayed
        
        // Parse creation date
        if let createdDate = ISO8601DateFormatter().date(from: self.createdAt) {
            message.createdAt = createdDate
        }
        
        // Set audio URL if available
        if let audioFilePath = self.audioFilePath {
            message.audioURL = URL(string: "http://localhost:3000\(audioFilePath)")
        }
        
        return message
    }
}