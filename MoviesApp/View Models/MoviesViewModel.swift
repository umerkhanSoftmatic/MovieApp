import Foundation
import CoreData

@MainActor
class MoviesViewModel: ObservableObject {
    
    @Published var moviesModel: MoviesModel?
    @Published var movies: [MoviesDB] = []
    @Published var movieCount: Int = 0
    
    @Published var moviePageNumber: Int = 1
    @Published var searchText = ""
    @Published var debouncedText = ""
    @Published var filteredMoviesFromLocal : [MoviesDB] = []
    

    
    init() {
        self.setupDebounce()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            Task {
                await self.fetchMovies()
            }
        }
    }
    
    private func setupDebounce() {
        self.debouncedText = searchText
        $searchText
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .assign(to: &$debouncedText)
    }
    
    
    func fetchMovies() async {
        
        do {
            self.moviesModel = try await Services.shared.fetchMovies(page: moviePageNumber)
                if let newMovies = self.moviesModel?.results, !newMovies.isEmpty {
                    self.movies = newMovies
                } else {
                    print("No more movies to fetch")
                }
        } catch {
                print("Error fetching movies: \(error.localizedDescription)")
        }
    }
    
    
    func loadmoreDataForMovies() async {
        let preheadcount = movieCount + 4
        
        if preheadcount <= moviesModel?.total_results ?? 0 {
            
            if preheadcount >= 20 * moviePageNumber {
                moviePageNumber += 1
               
                let moreMovies = await fetchMoviesForPage(pageNumber: moviePageNumber) ?? []
                movies.append(contentsOf: moreMovies)
            }
        }
    }
    

    func fetchMoviesForPage(pageNumber: Int) async -> [MoviesDB]? {
        do {
            let tempMovieModel = try await Services.shared.fetchMovies(page: pageNumber)
            return tempMovieModel.results
        } catch {
            print("Error fetching movies for page \(pageNumber): \(error)")
            return []
        }
    }
    
    
    
    func searchFromLocals(name: String) {
        if name.isEmpty {
            filteredMoviesFromLocal = []
        }else {
            filteredMoviesFromLocal = movies.filter { movie in
                if let title = movie.title?.lowercased() {
                    return title.contains(name.lowercased())
                }
                return false
            }
            print(filteredMoviesFromLocal)
        }
    }
    
  
    
}
