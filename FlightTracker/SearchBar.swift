import SwiftUI

public struct SearchBar: View {
    @Binding var isEditing: Bool
    @Binding var text: String
    let placeholder: String
    let deleteDidTap: () -> Void
    let cancelDidTap: (() -> Void)?
    let returnDidTap: (() -> Void)?

    @State private var isButtonScaled = false

    public init(
        isEditing: Binding<Bool>,
        text: Binding<String>,
        placeholder: String,
        deleteDidTap: @escaping () -> Void,
        cancelDidTap: (() -> Void)? = nil,
        returnDidTap: (() -> Void)? = nil
    ) {
        self._isEditing = isEditing
        self._text = text
        self.placeholder = placeholder
        self.deleteDidTap = deleteDidTap
        self.cancelDidTap = cancelDidTap
        self.returnDidTap = returnDidTap
    }

    public var body: some View {
        HStack(spacing: .zero) {
            TextField(placeholder, text: $text)
                //.font(.body2)
                .padding(.leading, 48)
                .padding(.vertical, 12)
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.neutral1)
                        HStack(spacing: .zero) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.neutral1)
                                .padding(.leading, 16)
                            Spacer()
                            Button(
                                action: {
                                    deleteDidTap()
                                    if cancelDidTap == nil {
                                        withAnimation(.easeOut(duration: 0.25)) { self.isEditing = false }
                                        hideKeyboard()
                                    }
                                },
                                label: {
                                    Image(systemName: "multiply.circle.fill")
                                }
                            )
                            .foregroundColor(.neutral1)
                            .rotationEffect(.degrees(isEditing ? 360 : 0))
                            .opacity(isEditing ? 1 : 0)
                            .scaleEffect(isButtonScaled ? 2 : 1)
                            .onChange(of: isEditing, perform: { value in
                                if value {
                                    withAnimation(.linear(duration: 0.125)) {
                                        isButtonScaled.toggle()
                                        //after(0.125) {
                                            withAnimation(.linear(duration: 0.125)) { isButtonScaled.toggle() }
                                        //}
                                    }
                                }
                            })
                            .padding(.trailing, 8)
                        }
                    }
                )
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                    withAnimation(.easeOut(duration: 0.25)) {
                        self.isEditing = true
                    }
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                    withAnimation(.easeOut(duration: 0.25)) {
                        self.isEditing = false
                    }
                })
                .onSubmit {
                    returnDidTap?()
                }
                .transition(.move(edge: .trailing))
            Button("Cancel", action: {
                withAnimation(.easeOut(duration: 0.25)) { self.isEditing = false }
                cancelDidTap?()
                hideKeyboard()
            })
            //.font(.body2)
            .foregroundColor(.neutral1)
            .padding(.leading, 16)
            .transition(.move(edge: .trailing))
            .visible(isEditing)
            .visible(cancelDidTap != nil)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        return SearchBar(
            isEditing: .constant(false),
            text: .constant(""), placeholder: "placeholder",
            deleteDidTap: {},
            cancelDidTap: {}
        )
    }
}

extension Color {
    static let neutral1 = Color.white
}

extension View {
    @ViewBuilder func visible(_ visible: Bool, remove: Bool = true) -> some View {
        if visible {
            self
        } else {
            if !remove {
                self.hidden()
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
