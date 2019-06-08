import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mediaURL: String
    let mapString: String
    let latitude: Double
    let longitude: Double
}
