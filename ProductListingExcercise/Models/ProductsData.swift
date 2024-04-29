//
//  ProductsData.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Foundation

struct ProductsData: Decodable {
  let hits: [ProductData]
}

extension ProductsData {
  struct ProductData: Decodable {
    let id: Int
    let title: String
    let labels: [String]?
    let colour: String
    let price: Double
    let featuredMedia: Media
  }
}

extension ProductsData {
  struct Media: Decodable {
    let id: Int
    let product_id: Int
    let src: String?
  }
}
