import SwiftUI
import MapKit

struct ContentView: View {
    @State private var time = 0
    @StateObject var timer = MyTimer()
    @StateObject var viewModel = MapViewModel.shared

    let tfs = CLLocationCoordinate2D(latitude: 28.047477135170762, longitude: -16.572272806214418)
    let london = CLLocationCoordinate2D(latitude: 51.507277135170762, longitude: 0.127672806214418)
    private var lineCoordinates: [CLLocationCoordinate2D]
    init() {
        self.lineCoordinates = [tfs, london]
    }
  var body: some View {
      ZStack {
          MapView(
            time: time,
            lineCoordinates: lineCoordinates
          )
          .edgesIgnoringSafeArea(.all)
          .onReceive(timer.currentTimePublisher) { newCurrentTime in
              self.time += 1
          }
          VStack(spacing: .zero) {
              SearchBar(
                isEditing: $viewModel.isEditingSearchbar,
                text: $viewModel.searchText,
                placeholder: "Search",
                deleteDidTap: viewModel.deleteDidTap,
                returnDidTap: { viewModel.searchResultRowDidTap(result: viewModel.searchText) }
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
