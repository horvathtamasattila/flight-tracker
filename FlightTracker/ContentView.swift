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
          VStack(spacing: .zero) {
//              Text(String(format: "%02d:%02d", (viewModel.counter / 3600), (viewModel.counter % 3600 / 60)))
//                  .font(.largeTitle)
//                  .foregroundColor(.white)
//                  .padding(8)
//                  .background(Color.green)
//                  .cornerRadius(16)
//                  .padding(.top, 80)
//              Spacer()
//              bottomCard
              Spacer()
              bottomCard
//              FTButton(text: "Takeoff", action: viewModel.toggleFlightMode)
//                  .visible(!viewModel.isFlightModeOn)
          }
          //.padding(.bottom, 48)
          .edgesIgnoringSafeArea(.all)
          //.visible(viewModel.selectedRoute != nil)
      }
  }

    var bottomCard: some View {
//        VStack {
//            Text(viewModel.selectedCities.first?.city_code ?? "")
//            Text(viewModel.selectedCities.second?.city_code ?? "")
//        }
//        .visible(viewModel.selectedRoute != nil)
        CustomShape(cutoutModifier: !viewModel.isFlightModeOn ? 118.0: 250)
            .fill(Color.purple, style: FillStyle(eoFill: true, antialiased: true))
            .overlay(

        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(alignment: .leading) {
                    Text(viewModel.selectedCities.first?.city_code ?? "")
                        .font(.largeTitle)
                    Text(viewModel.selectedCities.first?.name ?? "")
                }
                .padding(.leading, 40)
                Spacer()
                VStack(spacing: .zero) {
                    Image("airplane-logo")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: -10))
                        .overlay(
                            Circle()
                                .trim(from: 0.5, to: 1)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .frame(width: 60, height: 60)
                        )
                    Text(String(format: "%02d hrs %02d min", (viewModel.counter / 3600), (viewModel.counter % 3600 / 60)))
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(viewModel.selectedCities.second?.city_code ?? "")
                        .font(.largeTitle)
                    Text(viewModel.selectedCities.second?.name ?? "")
                }
                .padding(.trailing, 40)
            }
            .padding(.vertical, 32)

            Line()
              .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
              .frame(height: 1)
              .padding(.bottom, 20)
              .padding(.horizontal, 16)
              .visible(!viewModel.isFlightModeOn)

            FTButton(text: "Takeoff", action: viewModel.toggleFlightMode)
                .visible(!viewModel.isFlightModeOn)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
        }
        )
            .frame(width: UIScreen.main.bounds.width - 32, height: !viewModel.isFlightModeOn ? 280: 180)
            .cornerRadius(24)
            .visible(viewModel.selectedRoute != nil)
            .animation(.easeOut(duration: 0.25))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
