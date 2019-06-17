import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var user: Student! = nil
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
        let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
        
        if let index = MemberModel.students.firstIndex(where: { $0.uniqueKey == UdacityAPI.Auth.uniqueKey}), MemberModel.students[index].objectId != "" {
            
            UdacityAPI.updateLocation(mapString: user.mapString, location: location, profileLink: user.mediaURL) { (updated, error) in
                if error != nil {
                    self.showAlert(title: "Location Update Failed", message: "Please check you Internet connection and try again.")
                }
                if updated {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(title: "Location Update Failed", message: "Please check you Internet connection and try again.")
                }
            }
        } else {
            
            UdacityAPI.postLocation(mapString: user.mapString, location: location, profileLink: user.mediaURL) { (created, error) in
                if error != nil {
                    self.showAlert(title: "Location Creation Failed", message: "Please check you Internet connection and try again.")
                }
                if created {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(title: "Location Creation Failed", message: "Please check you Internet connection and try again.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let location = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 0.9, longitudinalMeters: 0.9)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension LocationViewController: MKMapViewDelegate {
    
}
