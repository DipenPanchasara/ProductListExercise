//
//  ProductDisplayModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 06/05/2024.
//

import Foundation

struct ProductDisplayModel: Hashable {
  let id: Int
  let title: String
  var description: String
  let price: String
  var labels: String?
  let urlString: String?
  var color: String
  
  init(model: ProductModel) {
    id = model.id
    title = model.title
    description = model.description
    price = model.formattedPrice
    labels = !model.labels.isEmpty ? model.labels.joined(separator: ", ") : nil
    urlString = model.featuredMedia.imageURLString
    color = model.colour
  }
}
