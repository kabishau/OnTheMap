import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseAPI.getStudentLocations { (students, error) in
            MemberModel.students += students
        }
        
        let philadelphia = CLLocation(latitude: 39.9526, longitude: -75.1652)
        let regionRadius: CLLocationDistance = 5000000.0
        let region = MKCoordinateRegion(center: philadelphia.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        mapView.addAnnotations(MemberModel.students)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.addAnnotations(MemberModel.students)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "StudentLocation") as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "StudentLocation")
        } else {
            annotationView?.annotation = annotation
        }
        
        // customize annotation here
        annotationView?.glyphText = "👀"
        
        return annotationView
    }
}
