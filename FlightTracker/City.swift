import Foundation

struct CityResponse: Decodable {
    let response: [City]
}

struct City: Decodable {
    let name: String
    let city_code: String
    let lat: Double
    let lng: Double
}
