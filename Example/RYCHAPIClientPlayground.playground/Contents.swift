//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum HTTPBinEndpoint {
    case status(statusCode: String)
    case get
    case post
}

extension HTTPBinEndpoint: RYCHAPIEndpoint {
    var baseURL: URL {
        return URL(string: "https://httpbin.org")!
    }
    
    var path: String {
        switch self {
        case .status(let statusCode):
            return "/status/\(statusCode)"
        case .get:
            return "/get"
        case .post:
            return "/post"
        }
    }
    
    var method: RYCHAPIRequestMethod {
        switch self {
        case .post:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .post:
            return ["foo": "bar"]
        default:
            return nil
        }
    }
    
    var parameterEncoding: RYCHAPIParameterEncoding {
        return .json
    }
    
    var customHTTPHeaders: [String: String]? {
        return nil
    }
}

RYCHAPIClient.shared.request(HTTPBinEndpoint.status(statusCode: "204")) { (response) in
    if case .success(_, let statusCode) = response, statusCode == 204 {
        print("No content!")
    }
}

RYCHAPIClient.shared.request(HTTPBinEndpoint.get) { (response) in
    if case .success(let data, let statusCode) = response {
        print("status code: \(statusCode)")
        print(String(data: data, encoding: .utf8))
    }
}

RYCHAPIClient.shared.request(HTTPBinEndpoint.post) { (response) in
    if case .success(let data, let statusCode) = response {
        print("status code: \(statusCode)")
        print(String(data: data, encoding: .utf8))
    }
}
