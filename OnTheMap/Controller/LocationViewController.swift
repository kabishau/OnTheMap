import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var user: Student! = nil
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        //TODO: - use real location and url
        let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
        
        if let index = MemberModel.students.firstIndex(where: { $0.uniqueKey == UdacityAPI.Auth.uniqueKey}), MemberModel.students[index].objectId != "" {
            
            UdacityAPI.updateLocation(mapString: user.mapString, location: location, profileLink: user.mediaURL) { (updated, error) in
                if updated {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            
            UdacityAPI.postLocation(mapString: user.mapString, location: location, profileLink: user.mediaURL) { (created, error) in
                if created {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
        let regionRadius: CLLocationDistance = 500000.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.addAnnotation(annotation)
        
    }
}

extension LocationViewController: MKMapViewDelegate {
    
}
