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

import XCTest
@testable import RYCHAPIClient

class EndpointRequestMethodTests: XCTestCase {
  func testGet() {
    let testEndpoint = TestEndpoint(method: .get)
    let httpMethod = testEndpoint.urlRequest.httpMethod
    XCTAssertEqual(httpMethod, "GET")
  }

  func testPut() {
    let testEndpoint = TestEndpoint(method: .post)
    let httpMethod = testEndpoint.urlRequest.httpMethod
    XCTAssertEqual(httpMethod, "POST")
  }

  func testDelete() {
    let testEndpoint = TestEndpoint(method: .delete)
    let httpMethod = testEndpoint.urlRequest.httpMethod
    XCTAssertEqual(httpMethod, "DELETE")
  }
}
