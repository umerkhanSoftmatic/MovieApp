import SwiftUI

@main
struct MoviesAppApp: App {
    @StateObject private var viewModel = MoviesViewModel()
    @StateObject private var SearchModel = SearchViewModel()
    @StateObject private var UpcomingModel = UpcomingViewModel()
    @StateObject private var watchistViewModel = WatchListViewModel()
   

    var body: some Scene {
        WindowGroup {
            TabView  {
                NavigationView {
                    ScrollView {
                        UpcomingView(viewModel: viewModel, UpcomingModel: UpcomingModel, watchistViewModel: watchistViewModel)
                    }
                    
                }
                .tabItem {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                    Text("Home view")
                }
                .tag(0)
                
                NavigationView {
                    MoviesView(viewModel: viewModel, searchModel: SearchModel, watchistViewModel: watchistViewModel)
                    
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
                
                NavigationView {
                    WatchListView()
                        .environmentObject(watchistViewModel)
                       
                }
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Watch List")
                }
                .badge(watchistViewModel.watchlistCount)
                .tag(2)
            }
        }
    }
}
