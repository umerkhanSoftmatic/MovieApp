import SwiftUI

struct MovieCard: View {
    var movie: MoviesDB?
    @ObservedObject var viewModel: MoviesViewModel
    @ObservedObject var watchlistViewModel: WatchListViewModel
    @State var count: Int

    var body: some View {
        NavigationLink(destination: DetailView(movie: movie, watchlistViewModel: watchlistViewModel)) {
            VStack {
                if let posterPath = movie?.poster_path {
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
            .frame(width: 150, height: 200)
        }
    }
}

//#Preview {
//    MovieCard(movie: Pagination(), viewModel: MoviesViewModel(), count: 0)
//}
