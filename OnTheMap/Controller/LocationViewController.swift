import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        //TODO: - use real location and url
        guard let location = location else {
            print("there are no coordinates")
            return
        }
        MemberModel.user.latitude = location.coordinate.latitude
        MemberModel.user.longitude = location.coordinate.longitude
        
        UdacityAPI.postLocation { (created, error) in
            if created {
                print("Created")
            }
            //TODO: -  main queue? download data again or just add one annotation
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    // finish button that submit data on server and reload table and map view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        guard let location = location else { return }
        let regionRadius: CLLocationDistance = 100000.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.addAnnotation(annotation)

    }
}

extension LocationViewController: MKMapViewDelegate {
    
}
