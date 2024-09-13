import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $searchText)
                .padding(.vertical, 15)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal)
        .background(Color(.systemGray5))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}
