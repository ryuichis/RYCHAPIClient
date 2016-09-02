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

class EndpointCustomHeaderTests: XCTestCase {
  func testNil() {
    let testEndpoint = TestEndpoint(customHTTPHeaders: nil)
    guard let headerFields = testEndpoint.urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, [:])
  }

  func testOneCustomHeader() {
    let testEndpoint = TestEndpoint(customHTTPHeaders: ["X-Ryuichi-Foo": "Bar"])
    guard let headerFields = testEndpoint.urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["X-Ryuichi-Foo": "Bar"])
  }

  func testMultipleCustomHeaders() {
    let testEndpoint = TestEndpoint(customHTTPHeaders: ["X-Ryuichi-Foo": "Bar", "Authorization": "Basic 1234567"])
    guard let headerFields = testEndpoint.urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["X-Ryuichi-Foo": "Bar", "Authorization": "Basic 1234567"])
  }

  func testPostMethodInURLEncoding() {
    let testEndpoint = TestEndpoint(method: .post, parameters: ["foo": "bar"], customHTTPHeaders: ["X-Ryuichi-Foo": "Bar"])
    guard let headerFields = testEndpoint.urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["X-Ryuichi-Foo": "Bar", "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"])
  }

  func testJSONEncoding() {
    let testEndpoint = TestEndpoint(method: .post, parameters: ["foo": "bar"], parameterEncoding: .json, customHTTPHeaders: ["X-Ryuichi-Foo": "Bar"])
    guard let headerFields = testEndpoint.urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["X-Ryuichi-Foo": "Bar", "Content-Type": "application/json"])
  }
}
