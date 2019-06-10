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
    
}

extension UserViewController: UITableViewDataSource {
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemberModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let student = MemberModel.students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mapString
        
        return cell
    }
    
    
}
