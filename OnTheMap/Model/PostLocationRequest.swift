import Foundation
import CoreLocation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mediaURL: String
    let mapString: String
    let latitude: Double
    let longitude: Double
    
    init(mapString: String, location: CLLocation, profileLink: String) {
        self.uniqueKey = UdacityAPI.Auth.uniqueKey
        self.firstName = MemberModel.user!.firstname
        self.lastName = MemberModel.user!.lastname
        self.mediaURL = profileLink
        self.mapString = mapString
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
    }
}
