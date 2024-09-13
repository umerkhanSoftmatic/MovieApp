import SwiftUI

struct LocalMoviesFilterView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @ObservedObject var watchistViewModel: WatchListViewModel
    
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 10,
                pinnedViews: [.sectionHeaders]
            ) {
                Section(header:
                            HStack {
                    Text("Local Movies")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.headline.weight(.bold))
                        .font(.largeTitle)
                }
                    .frame(maxWidth: .infinity)
                ) {
                        ForEach(Array(viewModel.filteredMoviesFromLocal.enumerated()), id: \.offset) { index, movie in
                            MovieCard(movie: movie, viewModel: viewModel, watchlistViewModel: watchistViewModel, count: index)
                                .frame(width: 150, height: 220)
                        }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

//#Preview {
//    LocalMoviesView(viewModel: MoviesViewModel())
//}
