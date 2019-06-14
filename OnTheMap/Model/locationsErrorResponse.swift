import Foundation

struct ErrorGetLocationsResponse: Codable {
    let error: String
}

extension ErrorGetLocationsResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
