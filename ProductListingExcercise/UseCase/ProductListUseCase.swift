//
//  ProductListUseCase.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Foundation
import Combine

enum UseCaseError: Error {
  case noData
  case decodingError(description: String)
  case unknownError
}

protocol ProductListUseCaseProvider {
  func run() -> AnyPublisher<ProductsData, UseCaseError>
}

struct ProductListUseCase: ProductListUseCaseProvider {
  private let networkManager: NetworkProvider
  
  init(networkManager: NetworkProvider) {
    self.networkManager = networkManager
  }
  
  func run() -> AnyPublisher<ProductsData, UseCaseError>{
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
      .mapError {
        return mapError(error: $0)
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
