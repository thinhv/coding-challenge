//
//  ProductsListDataSourceTests.swift
//  DemoTests
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
@testable import Demo

class MockRequestLoader<T: APIRequestProtocol>: APIRequestLoader<T> {
    var handler: (() -> Void)?

    override func loadRequest(requestData: T.ResquestDataType?,
                              completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void) {

        do {
            let urlRequest = try request.createRequest(requestData)
            let dataTask = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
                guard let data = data else {
                    completionHandler(nil, error)
                    self.handler?()
                    return
                }

                do {
                    let responseData = try self.request.parseResponse(data)
                    completionHandler(responseData, nil)
                    self.handler?()
                } catch {
                    completionHandler(nil, error)
                    self.handler?()
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(nil, error)
            self.handler?()
        }
    }
}

class ProductsListDataSourceTests: XCTestCase {

    let data =
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
        """.data(using: .utf8)!

    var dataSource: ProductsListDataSource!
    var collectionView: UICollectionView!
    var loader: MockRequestLoader<ProductsRequest>!

    override func setUp() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)
        loader = MockRequestLoader(request: ProductsRequest(APIConfiguration.appConfiguration),
                                       session: session)
        dataSource = ProductsListDataSource(loader: loader)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func tearDown() {
        MockURLProtocol.handler = nil
    }

    func testDataSourceAndDelegateNotNilOnCollectionView() {
        dataSource.collectionView = collectionView

        XCTAssertNotNil(collectionView.dataSource)
        XCTAssertNotNil(collectionView.delegate)
    }

    func testDataSourceFetchDataWithoutRefreshError_DataSorceWithCorrectState() {
        MockURLProtocol.handler = { _ in
            throw NSError(domain: "Error", code: 100, userInfo: nil)
        }
        let expect = expectation(description: "expect")
        loader.handler = {
            DispatchQueue.main.async {
                XCTAssertEqual(self.dataSource.loadingState, LoadingState.error)
                expect.fulfill()
            }
        }
        dataSource.loadMoreIfNeeded()
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testDataSourceFetchDataWithRefresh_DataSorceReceiveCorrectOneItem() {
        MockURLProtocol.handler = { _ in
            return (HTTPURLResponse(), self.data)
        }
        let expect = expectation(description: "expect")
        loader.handler = {
            DispatchQueue.main.async {
                XCTAssertEqual(self.dataSource.items.count, 1, "There must be one product item")
                expect.fulfill()
            }
        }
        dataSource.loadMoreIfNeeded(refresh: true)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testDataSourceFetchDataWithoutRefresh_DataSorceReceiveCorrectOneItem() {
        MockURLProtocol.handler = { _ in
            return (HTTPURLResponse(), self.data)
        }
        let expect = expectation(description: "expect")
        loader.handler = {
            DispatchQueue.main.async {
                XCTAssertEqual(self.dataSource.items.count, 1, "There must be one product item")
                expect.fulfill()
            }
        }
        dataSource.loadMoreIfNeeded(refresh: false)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
