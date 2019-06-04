import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Udacity Students"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
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
        //cell.detailTextLabel?.text = "\(String(student.latitude)), \(String(student.longitude))"
        cell.detailTextLabel?.text = student.mapString
        print(student.coordinate)
        print(student.mapString)
        print(student.uniqueKey)
        
        return cell
    }
    
    
}
