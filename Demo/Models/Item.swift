//
//  Item.swift
//  Demo
//
//  Created by Thinh Vo Duc on 22/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

struct ItemPrice: Codable {
    let value: Double
    let currency: String
}

// swiftlint:disable identifier_name
struct Item: Codable {

    let id: String
    let title: String
    let imageURL: URL?
    let price: ItemPrice
    let category: String

    var liked: Bool = false // Fake like functionality

    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case title = "title"
        case imageURL = "image"
        case price
        case category
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let imageURLString = try values.decode(String.self, forKey: .imageURL)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        imageURL = URL(string: imageURLString)
        price = try values.decode(ItemPrice.self, forKey: .price)
        category = try values.decode(String.self, forKey: .category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try? container.encode(imageURL?.absoluteString, forKey: .imageURL)
        try container.encode(price, forKey: .price)
        try container.encode(category, forKey: .category)
    }
}
