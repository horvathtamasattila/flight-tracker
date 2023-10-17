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
    }

    func deleteDidTap() {
        searchText = ""
    }

    func searchResultRowDidTap(result: String) {
        searchText = ""
        if selectedCities.count <= 1 {
            selectedCities.append(listOfCities.first { $0.name == result }!)
        } else {
            selectedCities[1] = listOfCities.first { $0.name == result }!
        }
        //print(selectedCities)

//            let url = URL(string: "http://sampleurl.com/pages")!
//            let (data, response) = try! await URLSession.shared.data(from: url)
//            let asd = response as! HTTPURLResponse
//            let result = try JSONDecoder().decode([Model].self, from: data)
//            return result
    }
}
