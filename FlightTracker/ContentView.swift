import SwiftUI
import MapKit

struct ContentView: View {
    @State private var time = 0
    @StateObject var timer = MyTimer()
    @StateObject var viewModel = MapViewModel.shared

  var body: some View {
      ZStack {
          MapView()
          .edgesIgnoringSafeArea(.all)
          .onReceive(timer.currentTimePublisher) { newCurrentTime in
              self.time += 1
          }
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
      }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
