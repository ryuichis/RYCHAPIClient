/*
   Copyright 2016 Ryuichi Saito, LLC

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

import XCTest
@testable import RYCHAPIClient

class ClientRequestTests: XCTestCase {
  func test200Request() {
    let testEndpoint = TestEndpoint(baseURL: URL(string: "https://ryuichisaito.com")!)

    let successException = expectation(description: "Receive a 200 response.")

    RYCHAPIClient.shared.request(testEndpoint) { response in
      if case .success(_, let statusCode) = response, statusCode == 200 {
        successException.fulfill()
      }
    }

    waitForExpectations(timeout: 10)
  }

  func test404Request() {
    let testEndpoint = TestEndpoint(baseURL: URL(string: "https://ryuichisaito.com")!, path: "/404")

    let notFoundExpectation = expectation(description: "Receive a 404 response.")

    RYCHAPIClient.shared.request(testEndpoint) { response in
      if case .success(_, let statusCode) = response, statusCode == 404 {
        notFoundExpectation.fulfill()
      }
    }

    waitForExpectations(timeout: 10)
  }

  func testErrorRequest() {
    let testEndpoint = TestEndpoint(baseURL: URL(string: "https://abc.xyz.foo.bar")!)

    let errorResponseExpectation = expectation(description: "Receive an error response.")

    RYCHAPIClient.shared.request(testEndpoint) { response in
      if case .failure(_) = response {
        errorResponseExpectation.fulfill()
      }
    }

    waitForExpectations(timeout: 10)
  }
}
