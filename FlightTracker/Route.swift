import Foundation

struct RouteResponse: Decodable {
    let response: [Route]
}

struct Route: Decodable {
    let duration: Int
}
