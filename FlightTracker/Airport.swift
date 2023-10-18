import Foundation

struct AirportResponse: Decodable {
    let response: Airports
}

struct Airports: Decodable {
    let airports: [Airport]
}

struct Airport: Decodable {
    let iata_code: String?
    let popularity: Int
}
