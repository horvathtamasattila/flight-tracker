import Foundation

struct CityResponse: Decodable {
    let response: [City]
}

struct City: Decodable {
    let name: String
    let city_code: String
    var airport: Airport?
    let lat: Double
    let lng: Double
}
