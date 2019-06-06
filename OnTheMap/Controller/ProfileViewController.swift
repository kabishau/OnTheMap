import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        title = "Add Location"

        
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
