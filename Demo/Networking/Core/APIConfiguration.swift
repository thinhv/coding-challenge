//
//  APIConfiguration.swift
//  Demo
//
//  Created by Thinh Vo Duc on 23/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

final class APIConfiguration {

    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }
}

extension APIConfiguration {
    // NOTE: It is not ideal to have the base url in the source code.
    static let appConfiguration =
        APIConfiguration(baseURL: "https://mobile-code-challenge.s3.eu-central-1.amazonaws.com")
}
