import Foundation

class UdacityAPI {
    
    struct Auth {
        
        //static var uniqueKey = ""
        static var sessionId = ""
        static var expiration = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/"

        case session
        case getLocations
        case postLocation
        case updateLocation
       
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "session"
            case .getLocations:
                return Endpoints.base + "StudentLocation" + "?limit=100&order=-updatedAt"
            case .postLocation:
                return Endpoints.base + "StudentLocation"
            case .updateLocation:
                return Endpoints.base + "StudentLocation/" + MemberModel.user.objectId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.session.url)
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

            do {
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if responseObject.account.registered {
                    MemberModel.user.uniqueKey = responseObject.account.key
                    Auth.sessionId = responseObject.session.id
                    Auth.expiration = responseObject.session.expiration
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
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data?.subdata(in: 5..<data!.count) else {
                completion(false, error)
                return
            }

            do {
                let reponseObject = try JSONDecoder().decode(LogoutResponse.self, from: data)
                //TODO: - Do I need to do something here?
                Auth.sessionId = ""
                Auth.expiration = ""
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([Student], Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getLocations.url) { data, response, error in
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
    
    class func postLocation(completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: UdacityAPI.Endpoints.postLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // replace with convenience init
        let body = PostLocationRequest(uniqueKey: MemberModel.user.uniqueKey, firstName: MemberModel.user.firstName, lastName: MemberModel.user.lastName, mediaURL: MemberModel.user.mediaURL, mapString: MemberModel.user.mapString, latitude: MemberModel.user.latitude, longitude: MemberModel.user.longitude)

        request.httpBody = try! JSONEncoder().encode(body)

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
    
    class func updateLocation(completion: @escaping (Bool, Error?) -> Void) {

        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PostLocationRequest(uniqueKey: MemberModel.user.uniqueKey, firstName: MemberModel.user.firstName, lastName: MemberModel.user.lastName, mediaURL: MemberModel.user.mediaURL, mapString: MemberModel.user.mapString, latitude: MemberModel.user.latitude, longitude: MemberModel.user.longitude)
        request.httpBody = try! JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(UpdateLocationResponse.self, from: data)
                MemberModel.user.updatedAt = responseObject.updatedAt
                completion(true, nil)
            } catch {
                print(error.localizedDescription)
                completion(false, error)
            }
        }
        task.resume()
    }
}
