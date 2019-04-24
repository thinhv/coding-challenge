//
//  APIRequest.swift
//  Demo
//
//  Created by Thinh Vo Duc on 22/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case invalidURL
}

protocol APIRequestProtocol {
    associatedtype ResquestDataType
    associatedtype ResponseDataType

    func createRequest(_ data: ResquestDataType?) throws -> URLRequest
    func parseResponse(_ data: Data) throws -> ResponseDataType
}
