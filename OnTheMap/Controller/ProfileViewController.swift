import UIKit
import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileUrl: UITextField!
    
    var location: CLLocation?
    
    lazy var geocoder = CLGeocoder()
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        if profileUrl.text == "" {
            showAlert(title: "Profile Link is blank", message: "Please enter your Profile Link")
        }
        if locationTextField.text == "" {
            showAlert(title: "Location is blank", message: "Please enter your Location")
        }
        geocodeLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationTextField.text = MemberModel.user.mapString
        profileUrl.text = MemberModel.user.mediaURL
        setLabels()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        title = "Add Location"

        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)    }
    
    func setLabels() {
        if MemberModel.user.mapString == "" {
            locationLabel.text = "Add Your Location"
        } else {
            locationLabel.text = "Update Your Location"
        }
        
        if MemberModel.user.mediaURL == "" {
            profileLabel.text = "Add Your Profile Link"
        } else {
            profileLabel.text = "Update Your Profile Link"
        }
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
            destinationViewController.profileLink = profileUrl.text
        }
    }
}
