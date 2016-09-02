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

class EndpointEncodingTests: XCTestCase {
  func testURLEncodingWithNoParameters() {
    let testEndpoint = TestEndpoint(method: .post, parameters: nil)
    let urlRequest = testEndpoint.urlRequest
    XCTAssertEqual(urlRequest.httpMethod, "POST")
    XCTAssertEqual(urlRequest.url, URL(string: "https://example.com/"))
    XCTAssertNil(urlRequest.httpBody)
    guard let headerFields = urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, [:])
  }

  func testURLEncodingWithParametersInURL() {
    let testEndpoint = TestEndpoint(method: .get, parameters: ["foo": "bar", "apple": "banana"])
    let urlRequest = testEndpoint.urlRequest
    XCTAssertEqual(urlRequest.httpMethod, "GET")
    XCTAssertEqual(urlRequest.url, URL(string: "https://example.com/?apple=banana&foo=bar"))
    XCTAssertNil(urlRequest.httpBody)
    guard let headerFields = urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, [:])
  }

  func testURLEncodingWithParametersInHTTPBody() {
    let testEndpoint = TestEndpoint(method: .post, parameters: ["foo": "bar", "apple": "banana"])
    let urlRequest = testEndpoint.urlRequest
    XCTAssertEqual(urlRequest.httpMethod, "POST")
    XCTAssertEqual(urlRequest.url, URL(string: "https://example.com/"))
    guard let httpBodyData = urlRequest.httpBody, let httpBodyString = String(data: httpBodyData, encoding: .utf8) else {
      XCTFail("Failed in getting http body data.")
      return
    }
    XCTAssertEqual(httpBodyString, "apple=banana&foo=bar")
    guard let headerFields = urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"])
  }

  func testJSONEncodingWithNoParameters() {
    let testEndpoint = TestEndpoint(method: .post, parameters: nil, parameterEncoding: .json)
    let urlRequest = testEndpoint.urlRequest
    XCTAssertEqual(urlRequest.httpMethod, "POST")
    XCTAssertEqual(urlRequest.url, URL(string: "https://example.com/"))
    XCTAssertNil(urlRequest.httpBody)
    guard let headerFields = urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, [:])
  }

  func testJSONEncodingWithParametersInHTTPBody() {
    let testEndpoint = TestEndpoint(method: .post, parameters: ["foo": "bar"], parameterEncoding: .json)
    let urlRequest = testEndpoint.urlRequest
    XCTAssertEqual(urlRequest.httpMethod, "POST")
    XCTAssertEqual(urlRequest.url, URL(string: "https://example.com/"))
    guard let httpBodyData = urlRequest.httpBody, let httpBodyString = String(data: httpBodyData, encoding: .utf8) else {
      XCTFail("Failed in getting http body data.")
      return
    }
    XCTAssertEqual(httpBodyString, "{\"foo\":\"bar\"}")
    guard let headerFields = urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["Content-Type": "application/json"])
  }

  func testCustomEncoding() {
    let testEndpoint = TestEndpoint(parameters: ["foo": "bar", "apple": "banana"], parameterEncoding: .custom({ (urlRequest, parameters) in
      var mutableUrlRequest = urlRequest
      mutableUrlRequest.url = URL(string: "https://example.org")
      mutableUrlRequest.httpMethod = "PATCH"
      mutableUrlRequest.allHTTPHeaderFields = ["hello": "world"]
      mutableUrlRequest.httpBody = "foobarapplebanana".data(using: .utf8, allowLossyConversion: false)
      return mutableUrlRequest
    }))
    let urlRequest = testEndpoint.urlRequest
    XCTAssertEqual(urlRequest.httpMethod, "PATCH")
    XCTAssertEqual(urlRequest.url, URL(string: "https://example.org"))
    guard let httpBodyData = urlRequest.httpBody, let httpBodyString = String(data: httpBodyData, encoding: .utf8) else {
      XCTFail("Failed in getting http body data.")
      return
    }
    XCTAssertEqual(httpBodyString, "foobarapplebanana")
    guard let headerFields = urlRequest.allHTTPHeaderFields else {
      XCTFail("Failed in getting http headers.")
      return
    }
    XCTAssertEqual(headerFields, ["hello": "world"])
  }
}
