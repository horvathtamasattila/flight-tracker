import Combine
import SwiftUI
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let mapView: MKMapView
    let polyline: MKGeodesicPolyline
    let viewModel = MapViewModel.shared

    var cancellables: Set<AnyCancellable> = []

    init(time: Int, lineCoordinates: [CLLocationCoordinate2D]) {
        self.mapView = MKMapView()
        self.polyline = MKGeodesicPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        super.init(nibName: nil, bundle: nil)
        mapView.delegate = self
        view = mapView

        unowned let unownedSelf = self
        viewModel.$selectedCities
            .filter { !$0.isEmpty }
            .sink { cities in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: cities.last!.lat, longitude: cities.last!.lng)
                annotation.title = cities.last!.name
                unownedSelf.mapView.addAnnotation(annotation)

                if cities.count >= 2 {
                    let polyline = MKGeodesicPolyline(coordinates: cities.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }, count: cities.count)
                    unownedSelf.mapView.addOverlay(polyline)
                }
            }
            .store(in: &cancellables)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let routePolyline = overlay as? MKPolyline {
        let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 10
        return renderer
      }
      return MKOverlayRenderer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

struct MapView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapViewController

    let time: Int
    let lineCoordinates: [CLLocationCoordinate2D]

    func makeUIViewController(context _: Context) -> MapViewController {
        return MapViewController(time: time, lineCoordinates: lineCoordinates)
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) { }
}

//struct MapView: UIViewRepresentable {
//  let time: Int
//  let lineCoordinates: [CLLocationCoordinate2D]
//
//  func makeUIView(context: Context) -> MKMapView {
//    let mapView = MKMapView()
//    mapView.delegate = context.coordinator
//    mapView.region = MKCoordinateRegion(coordinates: lineCoordinates)
//
//    let polyline = MKGeodesicPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
//      mapView.addOverlay(polyline)
//      let annotation = MKPointAnnotation()
//      annotation.coordinate = polyline.coordinates[polyline.coordinates.count / 100 * time]
//      annotation.title = "Current position"
//      mapView.addAnnotation(annotation)
//
//    return mapView
//  }
//
//  func updateUIView(_ view: MKMapView, context: Context) {
//      view.removeAnnotation(view.annotations.last!)
//      let polyline = (view.overlays.first(where: { $0 is MKPolyline })) as! MKPolyline
//      let annotation = MKPointAnnotation()
//      annotation.coordinate = polyline.coordinates[polyline.coordinates.count / 100 * time]
//      annotation.title = "Current position"
//      view.addAnnotation(annotation)
//      print(time)
//  }
//
//}

extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D], spanMultiplier: CLLocationDistance = 1.3) {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)

        for coordinate in coordinates {
            topLeftCoord.longitude = min(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = max(topLeftCoord.latitude, coordinate.latitude)

            bottomRightCoord.longitude = max(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = min(bottomRightCoord.latitude, coordinate.latitude)
        }

        let cent = CLLocationCoordinate2D.init(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5, longitude: topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5)
        let span = MKCoordinateSpan.init(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * spanMultiplier, longitudeDelta: abs(bottomRightCoord.longitude - topLeftCoord.longitude) * spanMultiplier)

        self.init(center: cent, span: span)
    }
}

public extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
