//
//  ProductsRequestTests.swift
//  DemoTests
//
//  Created by Thinh Vo Duc on 23/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
@testable import Demo

// swiftlint:disable force_try
class APIRequestTests: XCTestCase {

    private let baseURL: String = "https://demo.com"

    var configuration: APIConfiguration!
    var request: ProductsRequest!

    override func setUp() {
        configuration = APIConfiguration(baseURL: baseURL)
        request = ProductsRequest(configuration)
    }

    override func tearDown() {}

    func testCreateRequestWithoutURLString() {
        let urlRequest = try! request.createRequest(nil)

        XCTAssertNotNil(urlRequest.url)
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://demo.com/catalog")
    }

    func testCreateRequestWithURLString() {
        let urlRequest = try! request.createRequest("https://demo.com/catelog1")

        XCTAssertNotNil(urlRequest.url)
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://demo.com/catelog1")
    }

    func testParseResponseData_ParseSuccess() {
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
        let data = json.data(using: .utf8)!
        let itemsResponse = try! request.parseResponse(data)

        XCTAssertNotNil(itemsResponse.next)
        XCTAssertNotNil(itemsResponse.prev)
        XCTAssertEqual(itemsResponse.next!, "https://mobile-code-challenge.s3.eu-central-1.amazonaws.com/catalog2")
        XCTAssertEqual(itemsResponse.prev!, "https://mobile-code-challenge.s3.eu-central-1.amazonaws.com/catalog")
        XCTAssertEqual(itemsResponse.total, 1)
        XCTAssertEqual(itemsResponse.result.count, 1)
    }
}
