import Foundation
import CoreData

@objc(MoviesDB)
public class MoviesDB: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case adult
        //case visited
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    // Initializer for decoding
    required convenience public init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "MoviesDB", in: context) else {
            fatalError("Failed to find entity description for Pagination")
        }
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        self.backdrop_path = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id) ?? 0
        self.original_language = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
        self.original_title = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.release_date = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        self.vote_average = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        self.vote_count = try container.decodeIfPresent(Int64.self, forKey: .voteCount) ?? 0
    }

    // Method for encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adult, forKey: .adult)
        //try container.encode(visited, forKey: .visited)
        try container.encodeIfPresent(backdrop_path, forKey: .backdropPath)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(original_language, forKey: .originalLanguage)
        try container.encodeIfPresent(original_title, forKey: .originalTitle)
        try container.encodeIfPresent(overview, forKey: .overview)
        try container.encode(popularity, forKey: .popularity)
        try container.encodeIfPresent(poster_path, forKey: .posterPath)
        try container.encodeIfPresent(release_date, forKey: .releaseDate)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(video, forKey: .video)
        try container.encode(vote_average, forKey: .voteAverage)
        try container.encode(vote_count, forKey: .voteCount)
        //try container.encodeIfPresent(genre_ids, forKey: .genreIds)
        //try container.encodeIfPresent(timestamp, forKey: .timestamp)
    }
}
