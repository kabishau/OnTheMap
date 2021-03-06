import UIKit
import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileLinkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
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
        
        setupUI(for: self.user)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        title = "Add Location"

        
    }
    
    func setGeocoding(_ geocoding: Bool) {
        if geocoding {
            activityIndicator.startAnimating()
            findLocationButton.setTitle("", for: .normal)
        } else {
            activityIndicator.stopAnimating()
            findLocationButton.setTitle("FIND LOCATION", for: .normal)
        }
        locationTextField.isEnabled = !geocoding
        profileLinkTextField.isEnabled = !geocoding
        findLocationButton.isEnabled = !geocoding
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupUI(for user: Student?) {
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
        setGeocoding(true)
        guard let mapString = locationTextField.text else { return }
        
        geocoder.geocodeAddressString(mapString) { [weak self] (placemarks, error) in
            self?.setGeocoding(false)
            if error != nil {
                self?.showAlert(title: "Invalid Location", message: "Can't find provided location. Please check it and try again.")
                return
            }
            if let location = placemarks?.first?.location {
                self?.user = Student(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, mapString: mapString)
            }
            self?.performSegue(withIdentifier: "LocationViewController", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user.mediaURL = profileLinkTextField.text!
        if let destinationViewController = segue.destination as? LocationViewController {
            destinationViewController.user = user
        }
    }
}
