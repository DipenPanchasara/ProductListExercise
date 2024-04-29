//
//  ProductListingExcerciseApp.swift
//  ProductListingExcercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import SwiftUI

@main
struct ProductListingExcerciseApp: App {
  private let networkManager: NetworkProvider = NetworkManager(
    scheme: .https,
    baseURLString: "cdn.develop.gymshark.com"
  )
  
  var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_GB")
    formatter.currencyCode = "£"
    return formatter
  }
  
  var body: some Scene {
    WindowGroup {
      ProductListScreen(
        viewModel: ProductListScreenViewModel(
          productListUseCase: ProductListUseCase(
            networkManager: networkManager
          ),
          productMapper: ProductDataToModelMapper(currencyFormatter: currencyFormatter)
        )
      )
    }
  }
}
