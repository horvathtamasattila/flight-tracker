import Combine
import SwiftUI
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let mapView: MKMapView
    var planeMarker: MKPointAnnotation?
    var polyline: MKGeodesicPolyline
    let viewModel = MapViewModel.shared

    var cancellables: Set<AnyCancellable> = []

    init() {
        self.mapView = MKMapView()
        self.polyline = MKGeodesicPolyline()
        super.init(nibName: nil, bundle: nil)
        mapView.delegate = self
        view = mapView

        unowned let unownedSelf = self
        viewModel.$selectedCities
            .filter { !$0.isEmpty }
            .sink { cities in
                if let _ = (unownedSelf.mapView.overlays.first(where: { $0 is MKPolyline })) as? MKPolyline {
                    unownedSelf.mapView.removeAnnotations(unownedSelf.mapView.annotations)
                    unownedSelf.mapView.removeOverlays(unownedSelf.mapView.overlays)
                }
                for city in cities {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lng)
                    annotation.title = city.name
                    unownedSelf.mapView.addAnnotation(annotation)
                }

                if cities.count == 2 {
                    unownedSelf.polyline = MKGeodesicPolyline(coordinates: cities.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }, count: cities.count)
                    unownedSelf.mapView.addOverlay(unownedSelf.polyline)
                    let planeMarkerAnnotation = MKPointAnnotation()
                    planeMarkerAnnotation.coordinate = CLLocationCoordinate2D(latitude: unownedSelf.polyline.coordinates.first!.latitude, longitude: unownedSelf.polyline.coordinates.first!.longitude)
                    planeMarkerAnnotation.title = "Current Location"
                    
                    unownedSelf.mapView.addAnnotation(planeMarkerAnnotation)
                    unownedSelf.planeMarker = planeMarkerAnnotation
                    UIView.animate(withDuration: 0.5) {
                        unownedSelf.mapView.region = MKCoordinateRegion(coordinates: cities.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) })
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$counter
            .filter { _ in self.polyline.coordinates.count > 0 && self.viewModel.startTime > 0 }
            .sink { time in
                let idx = Int(modf(Double(self.polyline.coordinates.count) / Double(self.viewModel.startTime) * (Double(self.viewModel.startTime) + Double(-time))).0)
                UIView.animate(withDuration: 0.5) {
                    unownedSelf.planeMarker?.coordinate = unownedSelf.polyline.coordinates[min(idx, self.polyline.coordinates.count - 1)]
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }

        guard annotation.title == "Current Location" else { return nil }
        let annotationIdentifier = "PlaneMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }

        let pinImage = UIImage(named: "plane")
        annotationView!.image = pinImage
        return annotationView
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

struct MapView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapViewController

    func makeUIViewController(context _: Context) -> MapViewController {
        return MapViewController()
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) { }
}

extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D], spanMultiplier: CLLocationDistance = 1.2) {
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
