//
//  ProductsRequestLoaderTests.swift
//  DemoTests
//
//  Created by Thinh Vo Duc on 23/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
import Foundation

@testable import Demo

class MockURLProtocol: URLProtocol {

    static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.handler else {
            XCTFail("No handler")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

class APIRequestLoaderTests: XCTestCase {

    var session: URLSession!
    var requestLoader: APIRequestLoader<ProductsRequest>!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)

        let request = ProductsRequest(APIConfiguration(baseURL: "https://demo.com"))
        requestLoader = APIRequestLoader<ProductsRequest>(request: request, session: session)
    }

    override func tearDown() {
        MockURLProtocol.handler = nil
    }

    func testRequestLoader_LoadSuccess() {
        MockURLProtocol.handler = { _ in
            let json =
            """
            {
                \"result\": [
                {
                    \"item_id\": \"5a359f65-8de1-41db-9f14-bffff9b641f8\",
                    \"image\": \"https://picsum.photos/400/300/?image=115\",
                    \"title\": \"Tax\",
                    \"price\": {
                    \"value\": 5.1,
                    \"currency\": \"£\"
                },
                \"description\": \"Could should idea behavior serve wonder still civil.\",
                \"category\": \"Gray\"
            }
            ],
            \"next\": \"https://mobile-code-challenge.s3.eu-central-1.amazonaws.com/catalog2\",
            \"prev\": \"https://mobile-code-challenge.s3.eu-central-1.amazonaws.com/catalog\",
            \"total\": 1
            }
            """
            return (HTTPURLResponse(), json.data(using: .utf8)!)
        }

        let expect = expectation(description: "Product request should response")
        requestLoader.loadRequest(requestData: nil) { (itemsResponse, error) in
            XCTAssertEqual(itemsResponse?.result.count, 1)
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testRequestLoader_LoadWithError() {
        MockURLProtocol.handler = { _ in
            throw RequestError.invalidURL
        }

        let expect = expectation(description: "expectation")
        requestLoader.loadRequest(requestData: nil) { (itemsResponse, error) in
            XCTAssertNil(itemsResponse)
            XCTAssertNotNil(error)
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
