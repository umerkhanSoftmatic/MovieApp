import Foundation
import CoreData
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var movies: [MoviesDB] = []
    @Published var searchText = ""
    @Published var searchMovies: [MoviesDB] = []
    @Published var debouncedText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDebounce()
    }
    
    func searchMovies(query: String) async {
        if query.isEmpty {
            searchMovies = []
        } else {
            do {
                let moviesModel = try await SearchServices.shared.searchMovies(query: query)
                DispatchQueue.main.async {
                    self.searchMovies = moviesModel.results ?? []
                }
            } catch {
                print("Error searching movies: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupDebounce() {
        self.debouncedText = searchText
        $searchText
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .assign(to: &$debouncedText)
    }
}
