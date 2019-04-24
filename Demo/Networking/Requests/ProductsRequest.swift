//
//  ProductsRequest.swift
//  Demo
//
//  Created by Thinh Vo Duc on 23/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

struct ProductsRequest: APIRequestProtocol {

    typealias ResquestDataType = String

    typealias ResponseDataType = ItemsResponse

    private let endpoint: String = "catelog"

    let configuration: APIConfiguration

    init(_ configuration: APIConfiguration = APIConfiguration.appConfiguration) {
        self.configuration = configuration
    }

    /**
     Create products request
     - parameters:
        - data: String presentation of the url which is used for making the request
     - returns:
        An instance of URLRequest
    */
    func createRequest(_ data: String?) throws -> URLRequest {
        let urlString: String

        if let data = data {
            urlString = data
        } else {
            // There is no url, create one instead
            urlString = "\(configuration.baseURL)/\(endpoint)"
        }

        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            throw RequestError.invalidURL
        }
    }

    func parseResponse(_ data: Data) throws -> ItemsResponse {
        return try JSONDecoder().decode(ItemsResponse.self, from: data)
    }
}
