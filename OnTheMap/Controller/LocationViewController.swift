import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
    var profileLink: String = ""
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        //TODO: - use real location and url
        guard let location = location else {
            print("there are no coordinates")
            return
        }
        
        if let index = MemberModel.students.firstIndex(where: { $0.uniqueKey == MemberModel.user.uniqueKey}), MemberModel.students[index].objectId != "" {
            
            UdacityAPI.updateLocation(location: location) { (updated, error) in
                if updated {
                    MemberModel.students[index].latitude = location.coordinate.latitude
                    MemberModel.students[index].longitude = location.coordinate.longitude
                    print(MemberModel.students.count)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            
            UdacityAPI.postLocation(location: location) { (created, error) in
                if created {
                    MemberModel.user.latitude = location.coordinate.latitude
                    MemberModel.user.longitude = location.coordinate.longitude
                    MemberModel.user.mediaURL = self.profileLink
                    MemberModel.students.insert(MemberModel.user, at: 0)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        guard let location = location else { return }
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
