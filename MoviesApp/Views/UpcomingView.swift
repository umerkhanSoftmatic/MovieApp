import SwiftUI

struct UpcomingView: View {

    @ObservedObject var viewModel: MoviesViewModel
    @ObservedObject var UpcomingModel: UpcomingViewModel
    @ObservedObject var watchistViewModel: WatchListViewModel
    
    
    var body: some View {
        
        SearchBarView(searchText: $viewModel.searchText)
            .onChange(of: viewModel.debouncedText) { newValue in
                print(newValue)
                viewModel.searchFromLocals(name: newValue)
            }
        
        Section(header:
                       HStack {
                           Text("Upcoming Movies")
                               .padding()
                               .frame(maxWidth: .infinity, alignment: .leading)
                               .foregroundColor(.white)
                               .font(.headline.weight(.bold))
                               .font(.largeTitle)
                       }
                       .frame(maxWidth: .infinity)
        ) {
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 60) {
                    ForEach(Array(UpcomingModel.UpcomingMovies.enumerated()), id: \.offset) { index, movie in
                        UpcomingMovieCard(movie: movie, UpcomingModel: UpcomingModel, watchistViewModel: watchistViewModel, count: index)
                    }
                }
                
            }
        }
        
        if viewModel.filteredMoviesFromLocal.isEmpty {
            LocalMoviesView(viewModel: viewModel, watchistViewModel: watchistViewModel)
        }else {
            LocalMoviesFilterView(viewModel: viewModel, watchistViewModel: watchistViewModel)
        }
        
    
    }
    
}
