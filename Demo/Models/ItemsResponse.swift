//
//  ItemsResponse.swift
//  Demo
//
//  Created by Thinh Vo Duc on 23/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

struct ItemsResponse: Codable {
    let result: [Item]
    let next: String?
    let prev: String?
    let total: Int
}
