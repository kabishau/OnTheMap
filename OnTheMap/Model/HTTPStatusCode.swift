import Foundation

enum HTTPStatusCode: Int, Error {
    enum ResponseType {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case undefined
    }
    
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case requestTimeout = 408
    case internalServerError = 500
    case serviceUnavailable = 503
    
    var responseType: ResponseType {
        switch self.rawValue {
        case 100..<200:
            return .informational
        case 200..<300:
            return .success
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .undefined
        }
    }
}

extension HTTPURLResponse {
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
}
