//
//  RootView.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import SwiftUI

struct RootView: View {
  @StateObject var viewModel: RootViewModel

  var body: some View {
    NavigationStack(path: $viewModel.router.navPath) {
      ProductListScreen(
        viewModel: viewModel.productListScreenViewModel
      )
      .withProductRoutes()
    }
  }
}

// MARK: - Navigation
extension View {
  func withProductRoutes() -> some View {
    self.navigationDestination(for: ProductListScreenViewModel.ProductRoute.self) { destination in
      switch destination {
        case .productDetail(let model):
          ProductDetailScreen(viewModel: ProductDetailScreenViewModel(model: model))
      }
    }
  }
}
