//
//  MockProductListUseCase.swift
//  ProductListingExerciseTests
//
//  Created by Dipen Panchasara on 30/04/2024.
//

import Combine
import Foundation
@testable import ProductListingExercise
//import SwiftUI

struct MockProductListUseCase: ProductListUseCaseProvider {
  private var productData: [ProductsData.ProductData]?
  private var error: Error?

  struct NoStubError: Error {}
  
  init(productData: [ProductsData.ProductData]) {
    self.productData = productData
    self.error = NoStubError()
  }
  
  init(error: Error) {
    self.error = error
    self.productData = nil
  }
  
  func run() -> AnyPublisher<[ProductsData.ProductData], UseCaseError> {
    guard
      let products = productData
    else {
      return Fail(error: UseCaseError.noData)
        .eraseToAnyPublisher()
    }
    
    return Just(products)
    .setFailureType(to: UseCaseError.self)
    .eraseToAnyPublisher()
  }
}


/*
struct MockProductListUseCaseOne: ProductListUseCaseProvider {
  let subject: PassthroughSubject<ProductsData, UseCaseError>
  
  init(subject: PassthroughSubject<ProductsData, UseCaseError>) {
    self.subject = subject
  }
  
  func run() -> AnyPublisher<ProductsData, UseCaseError> {
    subject.eraseToAnyPublisher()
  }
}*/

private extension MockProductListUseCase {
  var mock: ProductsData.ProductData {
    ProductsData.ProductData(
      id: Int.random(in: 0...100),
      title: "anyTitle",
      description: "anyDescription",
      labels: ["anyLable_1"],
      colour: "anyColor",
      price: 12.99,
      featuredMedia: ProductsData.Media(
        id: 1,
        product_id: 1,
        src: "anyURL"
      )
    )
  }
  
  var mockProductsData: [ProductsData.ProductData] {
    Array(repeating: (), count: 5).map {
      mock
    }
  }
}
