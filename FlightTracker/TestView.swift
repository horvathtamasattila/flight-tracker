import SwiftUI

struct BottomView: View {
    var body: some View {
        CustomShape(cutoutModifier: 20.0)
            .fill(Color.purple, style: FillStyle(eoFill: true, antialiased: true))
            .background(Color.purple)
            .frame(width: 200, height: 200, alignment: .center)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CustomShape: Shape {
    let cutoutModifier: CGFloat

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addArc(center: CGPoint(x: rect.minX, y: rect.maxY - cutoutModifier), radius: rect.height/20, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270), clockwise: true)
            path.addArc(center: CGPoint(x: rect.maxX, y: rect.maxY - cutoutModifier), radius: rect.height/20, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 90), clockwise: true)
            path.addRects([CGRect(x: rect.minX, y: rect.maxY - cutoutModifier - rect.height / 20, width: rect.width, height: rect.height / 10)])
            path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height))

        }

    }
}
