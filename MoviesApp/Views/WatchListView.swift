import SwiftUI

struct WatchListView: View {
    
    @EnvironmentObject private var watchlistViewModel: WatchListViewModel
    @State private var showDeleteAllAlert = false // New state property for the alert

    var body: some View {
        
        NavigationView {
           
                List {
                    ForEach(watchlistViewModel.watchlist, id: \.id) { movie in
                        NavigationLink(destination: DetailView(movie: movie, watchlistViewModel: watchlistViewModel)) {
                            
                            HStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")")) { image in
                                    image
                                        .resizable()
                                        .frame(width: 80, height: 105)
                                        .cornerRadius(15)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(movie.original_title ?? "Unknown Title")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    
                                    Text(movie.release_date ?? "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(movie.vote_average, specifier: "%.1f") ★")
                                        .font(.subheadline)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let movie = watchlistViewModel.watchlist[index]
                            watchlistViewModel.removeFromWatchlist(movie)
                        }
                    }
                }
                .navigationTitle("Watch List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HStack {
                        EditButton()
                        
                        Button(action: {
                            showDeleteAllAlert = true // Show confirmation alert
                        }) {
                            Text("Delete All")
                        }
                    }
                }
                .onAppear {
                    watchlistViewModel.fetchWatchlist()
                }
                .alert(isPresented: $showDeleteAllAlert) {
                    Alert(
                        title: Text("Confirm Delete All"),
                        message: Text("Are you sure you want to delete all movies from the watch list?"),
                        primaryButton: .destructive(Text("Delete All")) {
                            watchlistViewModel.removeAllFromWatchlist()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }

