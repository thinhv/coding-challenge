//
//  ItemTests.swift
//  DemoTests
//
//  Created by Thinh Vo Duc on 22/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
@testable import Demo

class ItemTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testDecodeItemJSON_DecodeSuccess() {
        let jsonString =
        """
{
        \"item_id\": \"d6c786a3-dcd1-4ab1-9dfc-a44b111ae0cb\",
        \"image\": \"https://picsum.photos/400/300/?image=740\",
        \"title\": \"Go\",
        \"price\": {
            \"value\": 5.9,
            \"currency\": \"$\"
        },
        \"description\": \"Sense democratic small rule.\",
        \"category\": \"White\"
    }
"""
        let data = jsonString.data(using: .utf8)!
        let item = try! JSONDecoder().decode(Item.self, from: data)

        XCTAssertEqual(item.id, "d6c786a3-dcd1-4ab1-9dfc-a44b111ae0cb")
        XCTAssertEqual(item.title, "Go")
        XCTAssertNotNil(item.imageURL)
        XCTAssertEqual(item.imageURL!.absoluteString, "https://picsum.photos/400/300/?image=740")
        XCTAssertEqual(item.price.value, 5.9)
        XCTAssertEqual(item.price.currency, "$")
        XCTAssertEqual(item.category, "White")
    }
}
