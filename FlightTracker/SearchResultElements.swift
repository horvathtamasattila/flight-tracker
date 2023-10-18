import SwiftUI

struct SearchResultElementView: View {
    var searchResults: [String]
    let rowTapped: (String) async -> Void
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            ScrollView(.vertical, showsIndicators: true, content: {
                LazyVStack(alignment: .leading, spacing: .zero) {
                    ForEach(searchResults, id: \.self) { result in
                        VStack(alignment: .leading, spacing: .zero) {
                            Text(result)
                                //.font(.body3)
                                .padding(.leading, 16)
                                .padding(.vertical, 16)
                            Divider()
                        }
                        .onTapGesture {
                            Task { await rowTapped(result) }
                            hideKeyboard()
                        }
                    }
                }
            })
        }
        .edgesIgnoringSafeArea(.bottom)
        .animation(searchResults.count > 1 ? .linear(duration: 0.1) : nil)
    }
}

struct SearchResultViewElement_Preview: PreviewProvider {
    static var previews: some View {
        SearchResultElementView(
            searchResults: ["Steak", "Salmon", "Butter"],
            rowTapped: { _ in }
        )
    }
}
