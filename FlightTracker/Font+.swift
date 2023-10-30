import SwiftUI

public extension Font {
    enum FontType: String {
        case regular = "Poppins-Regular"
        case bold = "AmstradRegular"
    }

    static func font(type: FontType, size: CGFloat) -> Font {
        Font.custom(type.rawValue, size: size)
    }
}
