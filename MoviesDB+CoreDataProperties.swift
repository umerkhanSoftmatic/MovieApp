import Foundation
import CoreData


extension MoviesDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesDB> {
        return NSFetchRequest<MoviesDB>(entityName: "MoviesDB")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var isInWatchlist: Bool
    @NSManaged public var backdrop_path: String?
    @NSManaged public var id: Int64
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int64

}

extension MoviesDB : Identifiable {

}
