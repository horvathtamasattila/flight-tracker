import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = MapViewModel.shared

  var body: some View {
      ZStack {
          MapView()
          .edgesIgnoringSafeArea(.all)
          VStack(spacing: .zero) {
              SearchBar(
                isEditing: $viewModel.isEditingSearchbar,
                text: $viewModel.searchText,
                placeholder: "Search",
                deleteDidTap: viewModel.deleteDidTap
              )
                  .background(Color.green)
              SearchResultElementView(
                  searchResults: viewModel.searchResults,
                  rowTapped: viewModel.searchResultRowDidTap
              )
              .opacity(viewModel.isEditingSearchbar ? 1 : 0)
              //.animation(.easeOut(duration: 0.25))
          }
          VStack {
              Spacer()
              FTButton(text: "Takeoff", action: {})
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 48)
      }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
