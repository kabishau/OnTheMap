import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [Student]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            print(jsonStudents)
            students = jsonStudents.results
            print(students)
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            // showError using performSelector
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
        cell.textLabel?.text = students[indexPath.row].firstName
        cell.detailTextLabel?.text = students[indexPath.row].mediaURL
        return cell
    }
    
    
}
