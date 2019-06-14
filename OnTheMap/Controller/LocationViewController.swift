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
        //MemberModel.user.latitude = location.coordinate.latitude
        //MemberModel.user.longitude = location.coordinate.longitude
        
        if let index = MemberModel.students.firstIndex(where: { $0.uniqueKey == MemberModel.user.uniqueKey}) {
            if MemberModel.students[index].objectId == "" {
                // create location
            } else {
                // update location
            }
        } else {
            // add user with created location to array
        }
        
        
        
        let objectId = MemberModel.user.objectId
        // get student first and then object id
        
        if objectId == "" {
            UdacityAPI.postLocation(location: location) { (created, error) in
                
                    if created {
                        print("Created")
                    } else {
                        print(error?.localizedDescription)
                    }
                
            }
        } else {
            UdacityAPI.updateLocation { (updated, error) in
                // check for errors - what is in response?
                    if updated {
                        print("updated")
                        if let index = MemberModel.students.firstIndex(where: { $0.objectId == objectId }) {
                            MemberModel.students[index].latitude = location.coordinate.latitude
                            MemberModel.students[index].longitude = location.coordinate.longitude
                            
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print("Error trying update location")
                        }
                    }
            }
        }
        
        /*
        if MemberModel.user.objectId != "" {
            UdacityAPI.updateLocation { (updated, error) in
                if updated {
                    print("updated")
                    
                    //TODO: - Use firstIndex(where) to update location on array and update annotations
                    // if there is no location - add user's location to array
                    // if it exist - update it in array and in user
                    self.dismiss(animated: true, completion: nil)
                } else {
                    //TODO: enable to update location
                }
            }
        } else {
            UdacityAPI.postLocation { (created, error) in
                if created {
                    print("created")
                    //TODO: -  main queue? download data again or just add one annotation
                    self.dismiss(animated: true, completion: nil)
                } else {
                    //TODO: enable to post location
                }
            }
        }
        */
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
