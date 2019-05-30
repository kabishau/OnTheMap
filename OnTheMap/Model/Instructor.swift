import Foundation

struct Instuctor: Codable {
    
    let createdAt: String
    let firstname: String
    let lastname: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectID: String
    let uniqueKey: String
    let updatedAt: String
    
}

struct Instructors: Codable {
    var results: [Instuctor]
}
