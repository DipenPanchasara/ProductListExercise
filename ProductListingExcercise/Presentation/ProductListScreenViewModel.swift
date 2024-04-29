//
//  ProductListScreenViewModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Foundation
import Combine

class ProductListScreenViewModel: ObservableObject {
  private let productListUseCase: ProductListUseCaseProvider
  private let productMapper: ProductDataToModelMapping
  private var cancellables = Set<AnyCancellable>()

  @Published private (set)var products: [ProductModel] = []

  init(
    productListUseCase: ProductListUseCaseProvider,
    productMapper: ProductDataToModelMapping
  ) {
    self.productListUseCase = productListUseCase
    self.productMapper = productMapper
  }

  func loadData() {
    let productListUseCasePublisher = productListUseCase.run()
    productListUseCasePublisher
      .receive(on: DispatchQueue.main)
      .map({ productsData in
        return productsData.hits.map { dataModel in
          self.productMapper.map(source: dataModel)
        }
      })
      .sink { completion in
        switch completion {
          case .finished:
            print("Products Loaded")
          case .failure(let error):
            print("Failed with error: \(error)")
        }
      } receiveValue: { [weak self] productModels in
        guard let self = self else { return }
        self.products.append(contentsOf: productModels)
      }
      .store(in: &cancellables)
  }
}
