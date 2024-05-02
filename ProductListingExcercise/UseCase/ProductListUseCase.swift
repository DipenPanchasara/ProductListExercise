//
//  ProductListUseCase.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Foundation
import Combine
//import SwiftUI

enum UseCaseError: Error, Equatable {
  case noData
  case decodingError(description: String)
  case unknownError
}

protocol ProductListUseCaseProvider {
  func run() -> AnyPublisher<[ProductsData.ProductData], UseCaseError>
}

class ProductListUseCase: ProductListUseCaseProvider {
  private let networkManager: NetworkProvider
  
  init(networkManager: NetworkProvider) {
    self.networkManager = networkManager
  }
  
  func run() -> AnyPublisher<[ProductsData.ProductData], UseCaseError> {
    let request = NetworkRequest(
      httpMethod: .get,
      endPoint: "/training/mock-product-responses/algolia-example-payload.json"
    )
    
    let productsPublisher = networkManager.execute(networkRequest: request)
      .tryMap { response in
        guard let data = response.data else {
          throw UseCaseError.noData
        }
        return data
      }
      .decode(type: ProductsData.self, decoder: JSONDecoder())
      .map {
        $0.hits
      }
      .mapError {
        return self.mapError(error: $0)
      }
      .eraseToAnyPublisher()
    return productsPublisher
  }
}


extension ProductListUseCase {
  private func mapError(error: Error) -> UseCaseError {
    switch error {
      case is Swift.DecodingError:
        return .decodingError(description: error.localizedDescription)
      case let error as UseCaseError:
        return error
      default:
        return .unknownError
    }
  }
}
/*
 networkManager.execute(networkRequest: request)
 .tryMap { response in
 guard let data = response.data else {
 throw UseCaseError.noData
 }
 return data
 }
 .decode(type: ProductsData.self, decoder: JSONDecoder())
 .mapError {
 return self.mapError(error: $0)
 }
 .sink { completion in
 switch completion {
 case .finished:
 print("\(#function) FoodItem stream finished")
 case .failure(let error):
 self.result = .failure(error)
 }
 } receiveValue: { products in
 self.result = .success(products.hits)
 }
 .store(in: &subscriptions)

 */
