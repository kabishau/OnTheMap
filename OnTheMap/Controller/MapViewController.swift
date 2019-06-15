import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        
        UdacityAPI.getStudentLocations(completion: handleGetLocationRequest(students:error:))

        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadAnnotations()
        
        let regionRadius: CLLocationDistance = 1000000.0
        if let index = MemberModel.students.firstIndex(where: { $0.uniqueKey == MemberModel.user.uniqueKey}) {
            let user = MemberModel.students[index]
            let userLocation = CLLocation(latitude: user.coordinate.latitude, longitude: user.coordinate.longitude)
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func handleGetLocationRequest(students: [Student], error: Error?) {
        if students != [] {
            MemberModel.students = students
            self.reloadAnnotations()
        } else {
            if let error = error {
                self.showDataFailure(message: error.localizedDescription)
            } else {
                self.showDataFailure(message: "Unknown error. Check your connection and reload data.")
            }
        }
    }
    
    @objc override func reloadLocations() {
        UdacityAPI.getStudentLocations(completion: handleGetLocationRequest(students:error:))
        reloadAnnotations()
    }
    
    
    
    func reloadAnnotations() {
        self.mapView.removeAnnotations(MemberModel.students)
        self.mapView.addAnnotations(MemberModel.students)
    }
    
    func showDataFailure(message: String) {
        let alertController = UIAlertController(title: "Loading Data Failed", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
