import SwiftUI

public struct FTButton: View {
    let text: String
    let isEnabled: Bool
    let action: () -> Void

    public init(
        text: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(
            action: {
                if isEnabled {
                    action()
                }
            },
            label: {
                Text(text)
                    .font(.font(type: .bold, size: 18))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 48)
            }
        )
        .disabled(!isEnabled)
        .background(Color.button)
        .opacity(isEnabled ? 1 : 0.4)
        .cornerRadius(8)
        .buttonStyle(DefaultButtonStyle())
    }
}

struct RAButton_Previews: PreviewProvider {
    static var previews: some View {
        FTButton(text: "Takeoff", action: {})
            .padding(.horizontal, 16)
    }
}
