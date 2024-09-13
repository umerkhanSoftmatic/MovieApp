import SwiftUI

struct UpcomingMovieCard: View {
    var movie: MoviesDB?
    @ObservedObject var UpcomingModel: UpcomingViewModel
    @ObservedObject var watchistViewModel: WatchListViewModel
//    @ObservedObject var viewModel: MoviesViewModel
    
    @State var count: Int

    var body: some View {
        NavigationLink(destination: DetailView(movie: movie, watchlistViewModel: watchistViewModel )) {
            VStack {
                if let posterPath = movie?.poster_path {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(25)
                            .shadow(radius: 15)
                            .frame(width: 200, height: 250)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 250)
                    }
                }
            }
            .frame(width: 200, height: 250)
            .cornerRadius(25)
            .onAppear(perform: {
                UpcomingModel.UpcomingMoviesCount = count + 1
                Task{
                    await UpcomingModel.UpcomingMoviesDataForMovies()
                }
                
            })
            
        }
    }
}

#Preview {
    UpcomingMovieCard(movie: MoviesDB(), UpcomingModel: UpcomingViewModel(), watchistViewModel: WatchListViewModel(), count: 0)
}

