import SwiftUI

struct DetailView: View {
    var movie: MoviesDB?
    
    @ObservedObject var watchlistViewModel: WatchListViewModel
    @State private var showAddedAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(movie?.backdrop_path ?? "")")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
            } placeholder: {
                ProgressView()
            }
            
            HStack {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?.poster_path ?? "")")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 150)
                        .cornerRadius(10)
                        .padding(.leading, 16)
                        .padding(.top, -50)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie?.original_title ?? "Unknown Title")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    HStack {
                        Text(movie?.release_date ?? "N/A")
                        Text(" | ")
                        Text("\(movie?.vote_average ?? 0, specifier: "%.1f") ★")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .padding(.leading, 12)
            }
            
            VStack(alignment: .leading) {
                Text("About Movie")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Text(movie?.overview ?? "No description available.")
                    .font(.body)
                    .padding(.top, 5)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.leading, 24)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button(action: {
                
            }) {
                Image(systemName: "bookmark")
                    .foregroundColor(.white)
            }
        )

        .alert(isPresented: $showAddedAlert) {
            Alert(
                title: Text("Added to Watch List"),
                message: Text("The movie has been added to your watch list."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                watchlistViewModel.addToWatchlist(movie)
                showAddedAlert = true
            }
        }
    }
}
