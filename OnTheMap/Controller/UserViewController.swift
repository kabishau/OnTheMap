import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [Student]()
    var instuctors = [Student]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        students.append(Student(createdAt: "", firstName: "Aleksey", lastName: "Kabishau", latitude: 0.00, longitude: 0.00, mapString: "Philadelphia", mediaURL: "Udacity.com", objectId: "", uniqueKey: "", updatedAt: ""))
        
        navigationItem.title = "Udacity Members"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchJSON()
        
        
    }
    
    func fetchJSON() {
        //let urlString = "http://video.udacity-data.com.s3.amazonaws.com/topher/2016/June/57583b20_get-student-locations/get-student-locations.json"
        if let url = Bundle.main.url(forResource: "instructors", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }
        
        print("Error")
        // TODO: - showError using performSelector method
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonStudents = try? decoder.decode(Students.self, from: json) {
            instuctors = jsonStudents.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            // showError using performSelector
        }
    }
}

extension UserViewController: UITableViewDelegate {
    
}

extension UserViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // different types of members or use multidimensional array
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        if section == 0 {
            label.text = "Instructors"
        } else {
            label.text = "Students"
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return instuctors.count
        }
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let member = indexPath.section == 0 ? instuctors[indexPath.row] : students[indexPath.row]
        
        cell.textLabel?.text = member.firstName
        cell.detailTextLabel?.text = member.mediaURL
        
        return cell
    }
    
    
}
