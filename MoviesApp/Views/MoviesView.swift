import SwiftUI

struct MoviesView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @ObservedObject var searchModel: SearchViewModel
    @ObservedObject var watchistViewModel: WatchListViewModel
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var moviesToDisplay: [MoviesDB] {
        searchModel.searchText.isEmpty ? viewModel.movies : searchModel.searchMovies
    }
    
    @State var text = ""
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $searchModel.searchText)
                .onChange(of: searchModel.debouncedText) { newValue in
                    print(newValue)
                    Task{
                        await searchModel.searchMovies(query: newValue)
                    }
                    
                }
            
            if !searchModel.searchMovies.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 10,
                        pinnedViews: [.sectionHeaders]
                    ) {
                        Section(header:
                                    HStack {
                            Text("Movies")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.headline.weight(.bold))
                                .font(.largeTitle)
                        }
                            .frame(maxWidth: .infinity)
                        ) {
                            ForEach(Array(searchModel.searchMovies.enumerated()), id: \.offset) { index, movie in
                                GlobalMovieCard(movie: movie, viewModel: viewModel, watchistViewModel: watchistViewModel, count: index)
                                    .frame(width: 150, height: 220)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                }
            }else{
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 10,
                        pinnedViews: [.sectionHeaders]
                    ) {
                        Section(header:
                                    HStack {
                            Text("Movies")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.headline.weight(.bold))
                                .font(.largeTitle)
                        }
                            .frame(maxWidth: .infinity)
                        ) {
                            ForEach(Array(moviesToDisplay.enumerated()), id: \.offset) { index, movie in
                                
                                GlobalMovieCard(movie: movie, viewModel: viewModel, watchistViewModel: watchistViewModel, count: index)
                                    .frame(width: 150, height: 220)
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            
            
        }
    }
}

#Preview {
    MoviesView(viewModel: MoviesViewModel(), searchModel: SearchViewModel(), watchistViewModel: WatchListViewModel())
}
