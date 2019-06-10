import UIKit

extension UIViewController {
    
    func setupNavigationItem() {
        self.navigationItem.title = "Test"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadLocations))
        ]
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
        UdacityAPI.getStudentLocations { (students, error) in
            MemberModel.students = students
        }
    }
    
    @objc func logout() {
        
    }
}
