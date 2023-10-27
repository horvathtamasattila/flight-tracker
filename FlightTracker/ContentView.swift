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
              .visible(!viewModel.isFlightModeOn)

              SearchResultElementView(
                  searchResults: viewModel.searchResults,
                  rowTapped: viewModel.searchResultRowDidTap
              )
              .opacity(viewModel.isEditingSearchbar ? 1 : 0)
              .animation(.easeOut(duration: 0.25))
          }
          VStack {
              Text(String(format: "%02d:%02d", (viewModel.counter / 3600), (viewModel.counter % 3600 / 60)))
                  .font(.largeTitle)
                  .foregroundColor(.white)
                  .padding(8)
                  .background(Color.green)
                  .cornerRadius(16)
                  .padding(.top, 80)
              Spacer()
              FTButton(text: "Takeoff", action: viewModel.toggleFlightMode)
                  .visible(!viewModel.isFlightModeOn)
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 48)
          .visible(viewModel.selectedRoute != nil)
      }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

