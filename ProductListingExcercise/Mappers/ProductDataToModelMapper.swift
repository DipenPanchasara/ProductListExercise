//
//  ProductDataToModelMapper.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Foundation

protocol ProductDataToModelMapping {
  func map(source: ProductsData.ProductData) -> ProductModel
}

struct ProductDataToModelMapper: ProductDataToModelMapping {
  private let currencyFormatter: NumberFormatter
  
  init(currencyFormatter: NumberFormatter) {
    self.currencyFormatter = currencyFormatter
  }

  func map(source: ProductsData.ProductData) -> ProductModel {
    ProductModel(
      id: source.id,
      title: source.title,
      description: source.description,
      labels: source.labels ?? [],
      colour: source.colour,
      price: source.price,
      formattedPrice: currencyFormatter.string(
        from: NSNumber(value: source.price)
      ) ?? "-",
      featuredMedia: ProductModel.Media(
        id: source.featuredMedia.id,
        productId: source.featuredMedia.product_id,
        imageURLString: source.featuredMedia.src
      )
    )
  }
}
