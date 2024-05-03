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
  private let router: RoutingProvider
  @Published private (set)var products: [ProductModel] = []
  @Published private (set)var viewState: ViewState = .idle

  enum ProductRoute: Hashable {
    case productDetail(ProductModel)
  }

  
  enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case error
  }
  
  init(
    router: RoutingProvider,
    productListUseCase: ProductListUseCaseProvider,
    productMapper: ProductDataToModelMapping
  ) {
    self.router = router
    self.productListUseCase = productListUseCase
    self.productMapper = productMapper
  }
  
  func loadData() {
    guard viewState != .loaded else { return }
    viewState = .loading
    let productListUseCasePublisher = productListUseCase.run()
    productListUseCasePublisher
      .receive(on: DispatchQueue.main)
      .map { productsData in
        return productsData.map { dataModel in
          self.productMapper.map(source: dataModel)
        }
      }
      .sink { completion in
        switch completion {
          case .finished:
            self.viewState = .loaded
          case .failure(let error):
            self.viewState = .error
        }
      } receiveValue: { [weak self] productModels in
        guard let self = self else { return }
        self.products.append(contentsOf: productModels)
      }
      .store(in: &cancellables)
  }
}

@MainActor
extension ProductListScreenViewModel {
  func onProductSelect(product: ProductModel) {
    router.push(ProductRoute.productDetail(product))
  }
}
