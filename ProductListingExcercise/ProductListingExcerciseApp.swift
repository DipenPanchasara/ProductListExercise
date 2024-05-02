//
//  ProductListingExcerciseApp.swift
//  ProductListingExcercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import SwiftUI

@main
struct ProductListingExcerciseApp: App {
  private var networkManager: NetworkProvider {
    NetworkManager(
      scheme: .https,
      baseURLString: "cdn.develop.gymshark.com",
      session: AppURLSession()
    )
  }

  var body: some Scene {
    WindowGroup {
      ProductListScreen(
        viewModel: ProductListScreenViewModel(
          productListUseCase: ProductListUseCase(
            networkManager: networkManager
          ),
          productMapper: ProductDataToModelMapper(
            currencyFormatter: Formatter.currencyFormatter()
          )
        )
      )
    }
  }
}
