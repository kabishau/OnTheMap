import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var user: Student?
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
    }
    // finish button that submit data on server and reload table and map view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regionRadius: CLLocationDistance = 100000.0
        
        guard let user = user else { return }
        
        
        let region = MKCoordinateRegion(center: user.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        
        mapView.addAnnotation(user)

    }
}

extension LocationViewController: MKMapViewDelegate {
    
}
