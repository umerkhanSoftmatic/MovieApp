import Foundation

// MARK: - MoviesModel
struct MoviesModel: Codable , Hashable{
    var page: Int = 0
    var results: [MoviesDB]? = []
    var total_pages, total_results: Int
}

// MARK: - Result (stored in enitity in core data)
//struct Result: Codable , Hashable{
//    var adult: Bool
//    var backdrop_path: String?
//    var genreIDS: [Int]
//    var id: Int
//    var original_language: String
//    var original_title, overview: String
//    var popularity: Double
//    var poster_path, release_date, title: String?
//    var video: Bool
//    var vote_average: Double
//    var vote_count: Int
//}


