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
        
        let regionRadius: CLLocationDistance = 5000000.0
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
        
        annotationView?.canShowCallout = true
        
        let linkedInButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        linkedInButton.setBackgroundImage(UIImage(named: "linkedIn"), for: .normal)
        annotationView?.rightCalloutAccessoryView = linkedInButton
        
        annotationView?.animatesWhenAdded = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                //app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                UIApplication.shared.open(URL(string: toOpen)!, options: [:]) { (success) in
                    if !success {
                        let alertController = UIAlertController(title: "User Profile cannot be open.", message: "User didn't provide valid Profile URL.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
