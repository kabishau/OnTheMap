import Foundation

struct Credentials: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: Credentials
}
