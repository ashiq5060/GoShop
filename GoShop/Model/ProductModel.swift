//
//  ProductModel.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 14/02/24.
//

import Foundation

struct ProductModel: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let image: String
}
