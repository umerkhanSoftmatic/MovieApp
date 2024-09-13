import Foundation

@MainActor
class UpcomingViewModel: ObservableObject {
    
    @Published var UpcomingMoviesModel: MoviesModel?
    @Published var UpcomingMovies: [MoviesDB] = []
    @Published var UpcomingMoviesCount: Int = 0
    @Published var UpcomingMoviesPageNumber: Int = 1
    
    init() {
        Task {
            await fetchUpcomingMovies()
        }
    }
    
    func fetchUpcomingMovies() async {
        do {
            self.UpcomingMoviesModel = try await UpcomingServices.shared.fetchUpcomingMovies(page: UpcomingMoviesPageNumber)
            DispatchQueue.main.async {
                if let newMovies = self.UpcomingMoviesModel?.results, !newMovies.isEmpty {
                    self.UpcomingMovies.append(contentsOf: newMovies)
                } else {
                    print("No more movies to fetch")
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    func UpcomingMoviesDataForMovies() async {
        let preheadcount = UpcomingMoviesCount + 4
        
        if preheadcount <= UpcomingMoviesModel?.total_results ?? 0 {
            
            if preheadcount >= 20 * UpcomingMoviesPageNumber {
                UpcomingMoviesPageNumber += 1
                let moreMovies = await UpcomingMoviesForPage(pageNumber: UpcomingMoviesPageNumber)
                UpcomingMovies = UpcomingMovies + (moreMovies ?? [])
            }
        }
    }

    func UpcomingMoviesForPage(pageNumber: Int) async -> [MoviesDB]? {
        do {
            let tempMovieModel = try await Services.shared.fetchMovies(page: pageNumber)
            return tempMovieModel.results
        } catch {
            print("Error fetching movies for page \(pageNumber): \(error)")
            return []
        }
    }
    
}
