import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadLocations))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadLocations))
        ]
        
        ParseAPI.getStudentLocations { (students, error) in
            MemberModel.students = students
            DispatchQueue.main.async {
                self.mapView.addAnnotations(MemberModel.students)
            }
            
        }
        
        let philadelphia = CLLocation(latitude: 39.9526, longitude: -75.1652)
        let regionRadius: CLLocationDistance = 5000000.0
        let region = MKCoordinateRegion(center: philadelphia.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
    }
    
    @objc func addNewLocation() {
        // check if location already exist
        // exist - show alert controller with question to override it
        // doen't exist - new vc to enter it
        guard let profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
        let navigationController = UINavigationController(rootViewController: profileViewController)
        //navigationController?.pushViewController(profileViewController, animated: true)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func reloadLocations() {
        mapView.removeAnnotations(MemberModel.students)
        MemberModel.students = []
        
        ParseAPI.getStudentLocations { (students, error) in
            MemberModel.students = students
            DispatchQueue.main.async {
                self.mapView.addAnnotations(MemberModel.students)
            }
        }
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
        annotationView?.canShowCallout = true
        //TODO: - Custom icon of Ldn
        //annotationView?.detailCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView?.leftCalloutAccessoryView = UIButton(type: .roundedRect)
        
        annotationView?.animatesWhenAdded = true
        //annotationView?.isSelected = true
        
        return annotationView
    }
    /*
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    */
    
    /*
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let ac = UIAlertController(title: view.annotation?.title ?? "Unknown", message: view.annotation?.subtitle ?? "Uknown", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    */
}
