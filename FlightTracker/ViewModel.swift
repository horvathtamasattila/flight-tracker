import Combine
import Foundation

class MapViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isEditingSearchbar: Bool = false
    @Published var searchResults: [String] = []
    @Published var selectedCities: [City] = []

    private let listOfCities: [City]
    private var cancellables = Set<AnyCancellable>()

    static let shared = MapViewModel()

    init() {
        let decoder = JSONDecoder()
        let url = Bundle.main.url(forResource: "Cities", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        let result = try! decoder.decode(CityResponse.self, from: data)
        listOfCities = result.response

        unowned let unownedSelf = self
        $searchText
            .sink { text in
                unownedSelf.searchResults = unownedSelf.listOfCities.filter { $0.name.starts(with: text) }.map { $0.name } 
            }
            .store(in: &cancellables)

        $selectedCities
            .filter { $0.count == 2 }
            .sink { cities in
                Task {
                    let dep = cities[0]
                    let arr = cities[1]
                    let url = URL(string: "https://airlabs.co/api/v9/routes?api_key=b936de64-13c7-4af7-8f15-cae554ba9726&dep_iata=\(dep.city_code)&arr_iata=\(arr.city_code)")!
                    let (data, _) = try! await URLSession.shared.data(from: url)
                    let result = try JSONDecoder().decode(RouteResponse.self, from: data)
                    print(result)
                }
            }
            .store(in: &cancellables)
    }

    func deleteDidTap() {
        searchText = ""
    }

    @MainActor
    func searchResultRowDidTap(result: String) async {
        searchText = ""
        guard var city = listOfCities.first(where: { $0.name == result }) else { return }
        print(city)
        let url = URL(string: "https://airlabs.co/api/v9/nearby?lat=\(city.lat)&lng=\(city.lng)&distance=50&api_key=b936de64-13c7-4af7-8f15-cae554ba9726")!
        let (data, _) = try! await URLSession.shared.data(from: url)
        let apiResult = try! JSONDecoder().decode(AirportResponse.self, from: data).response.airports.filter { $0.iata_code != nil }.sorted { $0.popularity > $1.popularity }
        city.airport = apiResult.first

        if selectedCities.count <= 1 {
            selectedCities.append(city)
        } else {
            selectedCities[1] = city
        }
    }
}
