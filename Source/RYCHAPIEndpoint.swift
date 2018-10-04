/*
  Copyright 2015-2016 Ryuichi Creative

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import Foundation

public protocol RYCHAPIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: RYCHAPIRequestMethod { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: RYCHAPIParameterEncoding { get }
    var customHTTPHeaders: [String: String]? { get }
}

extension RYCHAPIEndpoint {
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }

    var urlRequest: URLRequest {
        var mutableUrlRequest = URLRequest(url: url)
        mutableUrlRequest.httpMethod = method.rawValue
        mutableUrlRequest.allHTTPHeaderFields = customHTTPHeaders

        switch parameterEncoding {
        case .url:
            guard let parameters = parameters else {
                return mutableUrlRequest
            }
            if method.encodesParametersInURL {
                if var urlComponents = URLComponents(url: mutableUrlRequest.url!, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                    let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                    urlComponents.percentEncodedQuery = percentEncodedQuery
                    mutableUrlRequest.url = urlComponents.url
                }
            } else  {
                mutableUrlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                mutableUrlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
            }
        case .json:
            guard let parameters = parameters else {
                return mutableUrlRequest
            }
            mutableUrlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .init(rawValue: 0))
            mutableUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .custom(let customClosure):
            mutableUrlRequest = customClosure(mutableUrlRequest, parameters)
        }

        return mutableUrlRequest
    }

    // Below three methods are modified from Alamofire project

    //
    //  ParameterEncoding.swift
    //
    //  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
    //
    //  Permission is hereby granted, free of charge, to any person obtaining a copy
    //  of this software and associated documentation files (the "Software"), to deal
    //  in the Software without restriction, including without limitation the rights
    //  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    //  copies of the Software, and to permit persons to whom the Software is
    //  furnished to do so, subject to the following conditions:
    //
    //  The above copyright notice and this permission notice shall be included in
    //  all copies or substantial portions of the Software.
    //
    //  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    //  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    //  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    //  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    //  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    //  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    //  THE SOFTWARE.
    //

    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }

        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }

    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        // rdar://26850776
        // Crash in Xcode 8 Seed 1 when trying to mutate a CharacterSet with remove
        var allowedCharacterSet = NSMutableCharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
}

private extension RYCHAPIRequestMethod {
    var encodesParametersInURL: Bool {
        switch self {
        case .get, .delete:
            return true
        default:
            return false
        }
    }
}
