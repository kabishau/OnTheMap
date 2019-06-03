import Foundation
import MapKit

class Student: NSObject, Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    init(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, uniqueKey: String, updatedAt: String) {
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
    
}

struct Students: Codable {
    let results: [Student]
}

extension Student: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        let location =  CLLocation(latitude: latitude, longitude: longitude)
        return location.coordinate
    }
    
    var title: String? {
        return firstName
    }
    
    var subtitle: String? {
        return mediaURL
    }
}
