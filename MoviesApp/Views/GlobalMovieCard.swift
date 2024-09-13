import SwiftUI

struct GlobalMovieCard: View {
    var movie: MoviesDB 
    @ObservedObject var viewModel: MoviesViewModel
    @ObservedObject var watchistViewModel: WatchListViewModel
    
    @State var count: Int

    var body: some View {
        NavigationLink(destination: DetailView(movie: movie, watchlistViewModel: watchistViewModel)) {
            VStack {
                if let posterPath = movie.poster_path {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(15)
                            .shadow(radius: 15)
                            .frame(width: 150, height: 200)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 200)
                            .tint(.white)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Ensure it looks like a card and not a button
        .frame(width: 150, height: 200)
        .onAppear {
            viewModel.movieCount = count + 1
            Task {
                await viewModel.loadmoreDataForMovies()
            }
        }
    }
}
