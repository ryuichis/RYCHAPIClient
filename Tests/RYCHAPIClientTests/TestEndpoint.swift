/*
   Copyright 2016 Ryuichi Creative

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
import RYCHAPIClient

struct TestEndpoint: RYCHAPIEndpoint {
  let _baseURL: URL
  let _path: String
  let _method: RYCHAPIRequestMethod
  let _parameters: [String: Any]?
  let _parameterEncoding: RYCHAPIParameterEncoding
  let _customHTTPHeaders: [String: String]?

  init(
    baseURL: URL = URL(string: "https://example.com")!,
    path: String = "/",
    method: RYCHAPIRequestMethod = .get,
    parameters: [String: Any]? = nil,
    parameterEncoding: RYCHAPIParameterEncoding = .url,
    customHTTPHeaders: [String: String]? = nil) {
    _baseURL = baseURL
    _path = path
    _method = method
    _parameters = parameters
    _parameterEncoding = parameterEncoding
    _customHTTPHeaders = customHTTPHeaders
  }

  var baseURL: URL {
    return _baseURL
  }

  var path: String {
    return _path
  }

  var method: RYCHAPIRequestMethod {
    return _method
  }

  var parameters: [String: Any]? {
    return _parameters
  }

  var parameterEncoding: RYCHAPIParameterEncoding {
    return _parameterEncoding
  }

  var customHTTPHeaders: [String: String]? {
    return _customHTTPHeaders
  }
}
