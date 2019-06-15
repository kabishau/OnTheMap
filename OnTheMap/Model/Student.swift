import Foundation
import MapKit

class Student: NSObject, Codable {
    
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
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
        return firstName + " " + lastName
    }
    
    var subtitle: String? {
        return mediaURL
    }
}
