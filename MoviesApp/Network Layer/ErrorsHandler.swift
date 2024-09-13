import Foundation

enum ErrorsHandler: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL Found"
            
        case .invalidResponse:
            return "Invalid response found"
            
        case .invalidData:
            return "Invalid data"
        }
    }
}
