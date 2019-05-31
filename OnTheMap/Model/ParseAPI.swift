import Foundation

class ParseAPI {
    
    
    
    class func getStudentLocations(completion: @escaping ([Student], Error?) -> Void) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=10&order=-updatedAt")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Students.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
}
