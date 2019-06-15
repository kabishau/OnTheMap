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
    
    init(latitude: Double, longitude: Double, mapString: String) {
        self.createdAt = ""
        self.firstName = ""
        self.lastName = ""
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = ""
        self.objectId = ""
        self.uniqueKey = ""
        self.updatedAt = ""
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
