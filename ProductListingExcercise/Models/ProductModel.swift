//
//  ProductModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Foundation

struct ProductModel: Identifiable, Equatable {
  let id: Int
  let title: String
  let labels: [String]
  let colour: String
  let price: Double
  let formattedPrice: String
  let featuredMedia: Media
}

extension ProductModel {
  struct Media: Identifiable, Equatable {
    let id: Int
    let productId: Int
    let imageURLString: String?
  }
}