import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let students = [Students]()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseAPI.getStudentLocations { (students, error) in
            MemberModel.students += students
        }
        
        let philadelphia = CLLocation(latitude: 39.9526, longitude: -75.1652)
        let regionRadius: CLLocationDistance = 500000.0
        let region = MKCoordinateRegion(center: philadelphia.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
