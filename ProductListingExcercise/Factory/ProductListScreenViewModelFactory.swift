//
//  ProductListScreenViewModelFactory.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Foundation

struct ProductListScreenViewModelFactory {
  static func make(
    router: Router,
    networkManager: NetworkProvider
  ) -> ProductListScreenViewModel {
    ProductListScreenViewModel(
      router: router,
      productListUseCase: ProductListUseCase(
        networkManager: networkManager
      ),
      productMapper: ProductDataToModelMapper(
        currencyFormatter: Formatter.currencyFormatter()
      )
    )
  }
}
