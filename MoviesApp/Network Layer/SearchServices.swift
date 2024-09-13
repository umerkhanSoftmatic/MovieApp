import Foundation
import CoreData

class SearchServices {
    static var shared = SearchServices()
    
    func searchMovies(query: String) async throws -> MoviesModel {
        guard let url = URL(string: "\(APIConstants.baseURL)/search/movie?api_key=\(APIConstants.apiKey)&query=\(query)&page=1") else {
            throw ErrorsHandler.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ErrorsHandler.invalidResponse
        }
        
        guard !data.isEmpty else {
            throw ErrorsHandler.invalidData
        }
        
        // Configure the JSONDecoder with the context
        let decoder = JSONDecoder()
        
        let moviesResponse = try decoder.decode(MoviesModel.self, from: data)
        return moviesResponse
    }
}
