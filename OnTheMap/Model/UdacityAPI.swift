import Foundation


class UdacityAPI {
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(udacity: Credentials(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data?.subdata(in: 5..<data!.count) else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LoginResponse.self, from: data)
                if responseObject.account.registered {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                    // send error message to user - put it in login vc
                }
                
            } catch {
                print(error.localizedDescription)
                completion(false, error)
            }
            
        }
        task.resume()
        
        
        
    }
}
