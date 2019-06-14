import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct LogoutResponse: Codable {
    let session: Session
}

struct ErrorLoginResponse: Codable {
    let status: Int
    let error: String
}

extension ErrorLoginResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
