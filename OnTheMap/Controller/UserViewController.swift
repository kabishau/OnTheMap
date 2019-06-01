import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [Student]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        students.append(Student(createdAt: "", firstName: "Aleksey", lastName: "Kabishau", latitude: 39.9526, longitude: -75.1652, mapString: "Philadelphia, US", mediaURL: "https://www.linkedin.com/in/aleksey-kabishau-568638133/", objectId: "", uniqueKey: "", updatedAt: ""))
        
        navigationItem.title = "Udacity Students"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ParseAPI.getStudentLocations { (students, error) in
            self.students += students
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
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    
}
