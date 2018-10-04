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

public struct RYCHAPIClient {
    public static var shared: RYCHAPIClient {
        return RYCHAPIClient()
    }

    public func request(_ endpoint: RYCHAPIEndpoint, completionHandler: @escaping (RYCHAPIResponse) -> ()) {
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: endpoint.urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    completionHandler(.success(data, response.statusCode))
                } else {
                    completionHandler(.failure(NSError(domain: "com.ryuichisaito.apiclient.internalerror", code: 500, userInfo: nil)))
                }
            }
        }
        task.resume()
    }
}
