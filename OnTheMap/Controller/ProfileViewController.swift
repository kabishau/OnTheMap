import UIKit
import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileLinkTextField: UITextField!
    
    var location: CLLocation?
    var user: Student! = nil
    
    lazy var geocoder = CLGeocoder()
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        if locationTextField.text == "" {
            showAlert(title: "Location is blank", message: "Please enter your Location")
            return
        }
        if profileLinkTextField.text == "" {
            showAlert(title: "Profile Link is blank", message: "Please enter your Profile Link")
            return
        }
        
        geocodeLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = MemberModel.students.firstIndex(where: { $0.uniqueKey == UdacityAPI.Auth.uniqueKey }) {
            self.user = MemberModel.students[index]
        }
        
        setUI(for: self.user)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        title = "Add Location"

        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func setUI(for user: Student?) {
        if let user = user {
            locationLabel.text = "Update Your Location"
            locationTextField.text = user.mapString
            profileLabel.text = "Update Your Profile Link"
            profileLinkTextField.text = user.mediaURL
        } else {
            locationLabel.text = "Add Your Location"
            locationTextField.text = ""
            profileLabel.text = "Add Your Profile Link"
            profileLinkTextField.text = ""
        }
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func geocodeLocation() {
        guard let mapString = locationTextField.text else { return }
        
        geocoder.geocodeAddressString(mapString) { [weak self] (placemarks, error) in
            if error != nil {
                self?.showAlert(title: "Invalid Location", message: "Can't find provided location. Please check it and try again.")
                return
            }
            guard let placemark = placemarks?.first else { return }
            if let location = placemark.location {
                self?.user = Student(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, mapString: mapString)

            } else {
                // show error alert
                print("Can't geocode address")
            }
            self?.performSegue(withIdentifier: "LocationViewController", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.user.mediaURL = profileLinkTextField.text!
        if let destinationViewController = segue.destination as? LocationViewController {
            destinationViewController.user = self.user
        }
    }
}
