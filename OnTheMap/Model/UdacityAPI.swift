import Foundation

class UdacityAPI {
    
    struct Auth {
        static var uniqueKey = ""
        //static var isRegistered = false
        static var sessionId = ""
        //static var expiration = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case postLocation
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .postLocation:
                return Endpoints.base + "/StudentLocation"
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
                    MemberModel.user.uniqueKey = responseObject.account.key
                    print(MemberModel.user.uniqueKey)
                    Auth.sessionId = responseObject.session.id
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
    
    class func postLocation(completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: UdacityAPI.Endpoints.postLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // replace with convenience init
        let body = PostLocationRequest(uniqueKey: MemberModel.user.uniqueKey, firstName: MemberModel.user.firstName, lastName: MemberModel.user.lastName, mediaURL: MemberModel.user.mediaURL, mapString: MemberModel.user.mapString, latitude: MemberModel.user.latitude, longitude: MemberModel.user.longitude)

        request.httpBody = try! JSONEncoder().encode(body)
        print(body.uniqueKey)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(PostLocationResponse.self, from: data)
                MemberModel.user.createdAt = responseObject.createdAt
                MemberModel.user.objectId = responseObject.objectId
                completion(true, nil)
            } catch {
                print(error.localizedDescription)
                completion(false, error)
            }
        }
        task.resume()
        
    }
}
