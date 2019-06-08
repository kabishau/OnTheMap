import UIKit
import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var profileUrl: UITextField!
    
    var location: CLLocation?
    
    lazy var geocoder = CLGeocoder()
//    var user: Student = Student(createdAt: "", firstName: "Aleksey", lastName: "Kabishau", latitude: 0.0, longitude: 0.0, mapString: "", mediaURL: "", objectId: "", uniqueKey: "", updatedAt: "")
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        geocodeLocation()
        MemberModel.user.mapString = locationTextField.text!
        MemberModel.user.mediaURL = profileUrl.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationTextField.text = MemberModel.user.mapString
        profileUrl.text = MemberModel.user.mediaURL
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        title = "Add Location"

        
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func geocodeLocation() {
        guard let mapString = locationTextField.text else { return }
        
        geocoder.geocodeAddressString(mapString) { [weak self] (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemark = placemarks?.first else { return }
            if let location = placemark.location {
                self?.location = location
            } else {
                // show error alert
                print("Can't geocode address")
            }
            self?.performSegue(withIdentifier: "LocationViewController", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? LocationViewController {
            destinationViewController.location = location
        }
    }
}
