import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mediaURL: String
    let mapString: String
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.uniqueKey = MemberModel.user.uniqueKey
        self.firstName = MemberModel.user.firstName
        self.lastName = MemberModel.user.lastName
        self.mediaURL = MemberModel.user.mediaURL
        self.mapString = MemberModel.user.mapString
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
