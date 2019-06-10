import UIKit

extension UIViewController {
    
    func setupNavigationItem() {
        self.navigationItem.title = "On The Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadLocations))
        ]
    }
    
    @objc func addNewLocation() {

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
        UdacityAPI.logout { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    //TODO: - It's not clear what to do here.
                }
            }
        }
    }
}
