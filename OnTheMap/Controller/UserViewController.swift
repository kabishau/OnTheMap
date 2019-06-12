import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc override func reloadLocations() {
        UdacityAPI.getStudentLocations { (students, error) in
            MemberModel.students = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
