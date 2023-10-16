import Combine

class MapViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isEditingSearchbar: Bool = false
    @Published var searchResults: [String] = []
    @Published var selectedResults: [String] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        unowned let unownedSelf = self
        $searchText
            .sink {
                unownedSelf.searchResults = [$0]
            }
            .store(in: &cancellables)
    }

    func deleteDidTap() {
        searchText = ""
    }

    func searchResultRowDidTap(result: String) {
        searchText = ""
        selectedResults.append(result)
    }
}
