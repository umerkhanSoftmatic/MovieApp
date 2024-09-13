import CoreData
import Combine

class WatchListViewModel: ObservableObject {
    @Published var watchlist: [MoviesDB] = []
    @Published var alertMessage: String?
    @Published var showAlert: Bool = false
    @Published var watchlistCount: Int = 0 

    private let context = CoreDataStack.shared.context
    
    init() {
        fetchWatchlist()
    }

    func fetchWatchlist() {
        let fetchRequest: NSFetchRequest<MoviesDB> = MoviesDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isInWatchlist == %@", NSNumber(value: true))
        
        do {
            let fetchedMovies = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.watchlist = fetchedMovies
                self.watchlistCount = fetchedMovies.count // Update count
            }
        } catch {
            print("Error fetching watchlist: \(error.localizedDescription)")
            self.alertMessage = "Failed to fetch watchlist."
            self.showAlert = true
        }
    }

    func addToWatchlist(_ movie: MoviesDB?) {
            guard let movie = movie else { return }
            
            let fetchRequest: NSFetchRequest<MoviesDB> = MoviesDB.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
            
            do {
                let existingMovies = try context.fetch(fetchRequest)
                if existingMovies.isEmpty {
                   
                    let newMovie = MoviesDB(context: self.context)
                    newMovie.adult = movie.adult
                    newMovie.backdrop_path = movie.backdrop_path
                    newMovie.id = movie.id
                    newMovie.original_language = movie.original_language
                    newMovie.original_title = movie.original_title
                    newMovie.overview = movie.overview
                    newMovie.popularity = movie.popularity
                    newMovie.poster_path = movie.poster_path
                    newMovie.release_date = movie.release_date
                    newMovie.title = movie.title
                    newMovie.video = movie.video
                    newMovie.vote_average = movie.vote_average
                    newMovie.vote_count = movie.vote_count
                    newMovie.isInWatchlist = true
                    
                    try? self.context.save()
                    DispatchQueue.main.async {
                        self.watchlist.append(newMovie)
                    }
                    self.alertMessage = "Added Movies to Watch List."
                    self.showAlert = true
                } else {
                 
                    let existingMovie = existingMovies.first
                    existingMovie?.isInWatchlist = true
                    
                    try? self.context.save()
                    if let updatedMovie = existingMovie {
                        DispatchQueue.main.async {
                            self.watchlist.append(updatedMovie)
                        }
                    }
                    self.alertMessage = "Already in Watch List."
                    self.showAlert = true
                }
            } catch {
                print("Error adding movie to watchlist: \(error)")
            }
        }

    func removeFromWatchlist(_ movie: MoviesDB) {
        let fetchRequest: NSFetchRequest<MoviesDB> = MoviesDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let moviesToUpdate = try context.fetch(fetchRequest)
            for movieToUpdate in moviesToUpdate {
                movieToUpdate.isInWatchlist = false
            }
            try context.save()
            
            DispatchQueue.main.async {
                self.watchlist.removeAll { $0.id == movie.id }
                self.watchlistCount -= 1 // Update count
            }
        } catch {
            print("Error updating movie watchlist status: \(error)")
        }
    }
    
    func removeAllFromWatchlist() {
        let fetchRequest: NSFetchRequest<MoviesDB> = MoviesDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isInWatchlist == %@", NSNumber(value: true))
        
        do {
            let moviesToUpdate = try context.fetch(fetchRequest)
            for movieToUpdate in moviesToUpdate {
                movieToUpdate.isInWatchlist = false
            }
            try context.save()
            
            DispatchQueue.main.async {
                self.watchlist.removeAll()
                self.watchlistCount = 0
            }
        } catch {
            print("Error removing all movies from watchlist: \(error)")
        }
    }
}
