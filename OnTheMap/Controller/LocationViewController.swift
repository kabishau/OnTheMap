import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var user: Student! = nil
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
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
        
        let location = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        let region = MKCoordinateRegion(center: location, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
    }
}

extension LocationViewController: MKMapViewDelegate {
    
}
