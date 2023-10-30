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
              .animation(.easeOut(duration: 0.1))
          }
          VStack(spacing: .zero) {
              Spacer()
              bottomCard
          }
          .onAppear {
              for family in UIFont.familyNames.sorted() {
                  let names = UIFont.fontNames(forFamilyName: family)
                  print("Family: \(family) Font names: \(names)")
              }
          }
          .edgesIgnoringSafeArea(.all)
      }
      .alert(
        "Update flight time",
        isPresented: $viewModel.isShowingInputSheet,
        actions: {
            TextField("Minutes", text: $viewModel.manualFlightTime)
            Button("OK", action: { viewModel.modifyFlightTime() })
            Button("Cancel", action: {})
        },
        message: { Text("Before taking off the captain usually mentiones the expected flight time. Listen to the announcement and change the flight time to have a more realistic position during the flight.") }
      )
  }

    var bottomCard: some View {
        CustomShape(cutoutModifier: !viewModel.isFlightModeOn ? 94 : 250)
            .fill(Color.background, style: FillStyle(eoFill: true, antialiased: true))
            .overlay(
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(alignment: .leading) {
                    Text(viewModel.selectedCities.first?.city_code ?? "")
                        .font(.font(type: .bold, size: 56))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    Text(viewModel.selectedCities.first?.name ?? "")
                        .font(.font(type: .regular, size: 16))
                        .foregroundColor(.neutral1)
                }
                .padding(.leading, 16)
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
                        .foregroundColor(.neutral2)
                    Text(String(format: "%02d hrs %02d min", (viewModel.counter / 3600), (viewModel.counter % 3600 / 60)))
                        .foregroundColor(.neutral2)
                }
                .onTapGesture {
                    viewModel.isShowingInputSheet = true
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(viewModel.selectedCities.second?.city_code ?? "")
                        .font(.font(type: .bold, size: 56))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    Text(viewModel.selectedCities.second?.name ?? "")
                        .font(.font(type: .regular, size: 16))
                        .foregroundColor(.neutral1)
                }
                .padding(.trailing, 16)
            }
            .padding(.top, 32)
            Spacer()

            Line()
              .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
              .frame(height: 1)
              .foregroundColor(.dash)
              .padding(.bottom, 20)
              .padding(.horizontal, 24)
              .visible(!viewModel.isFlightModeOn)

            FTButton(text: "Takeoff", action: viewModel.toggleFlightMode)
                .visible(!viewModel.isFlightModeOn)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        )
            .frame(width: UIScreen.main.bounds.width - 48, height: !viewModel.isFlightModeOn ? 280: 180)
            .cornerRadius(24)
            .padding(.bottom, 24)
            //.visible(viewModel.selectedRoute != nil)
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
