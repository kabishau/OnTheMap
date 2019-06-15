import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UdacityAPI.getStudentLocations(completion: handleGelLocationRequest(students:error:))
    }
    
    @objc override func reloadLocations() {
        UdacityAPI.getStudentLocations(completion: handleGelLocationRequest(students:error:))
    }
    
    func handleGelLocationRequest(students: [Student], error: Error?) {
        if students != [] {
            MemberModel.students = students
            self.tableView.reloadData()
        } else {
            if let error = error {
                self.showDataFailure(message: error.localizedDescription)
            } else {
                self.showDataFailure(message: "Unknown error. Check your connection and reload data.")
            }
        }
        
    }
    
    func showDataFailure(message: String) {
        let alertController = UIAlertController(title: "Loading Data Failed", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = MemberModel.students[indexPath.row]
        if let url = URL(string: student.mediaURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alertController = UIAlertController(title: "User Profile cannot be open.", message: "User didn't provide valid Profile URL.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemberModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let student = MemberModel.students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = student.mediaURL
        
        
        return cell
    }
    
    
}
