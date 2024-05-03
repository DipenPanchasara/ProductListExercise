//
//  ContentView.swift
//  ProductListingExcercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import SwiftUI
import Combine

struct ProductListScreen: View {
  @ObservedObject
  private var viewModel: ProductListScreenViewModel

  init(viewModel: ProductListScreenViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    listView
      .navigationTitle("Products")
      .navigationBarTitleDisplayMode(.inline)
      .task {
        viewModel.loadData()
      }
  }

  var listView: some View {
    List {
      ForEach(viewModel.products) { product in
        ProductCard(model: product)
          .padding(.top, Spacing.x2)
          .onTapGesture {
            viewModel.onProductSelect(product: product)
          }
          .listRowSeparator(.hidden)
          .shadow(radius: 8)
      }
    }
    .listStyle(.plain)
  }
}

#if DEBUG
#Preview {
  ProductListScreen(
    viewModel: ProductListScreenViewModel(
      router: Router(),
      productListUseCase: MockProductListUseCase(),
      productMapper: ProductDataToModelMapper(
        currencyFormatter: Formatter.currencyFormatter()
      )
    )
  )
}

struct MockProductListUseCase: ProductListUseCaseProvider {
  func run() -> AnyPublisher<[ProductsData.ProductData], UseCaseError> {
    Just(mockProductsData)
      .setFailureType(to: UseCaseError.self)
      .eraseToAnyPublisher()
  }
}

private extension MockProductListUseCase {
  var mock: ProductsData.ProductData {
    ProductsData.ProductData(
      id: Int.random(in: 0...100),
      title: "anyTitle",
      labels: ["anyLable_1"],
      colour: "anyColor",
      price: 12.99,
      featuredMedia: ProductsData.Media(
        id: 1,
        product_id: 1,
        src: "https://cdn.shopify.com/s/files/1/1326/4923/products/VitalSeamlessLeggingsTahoeTealMarlB1A2B-TBBS.A_ZH_1.jpg?v=1644310928"
      )
    )
  }

  var mockProductsData: [ProductsData.ProductData] {
    Array(repeating: (), count: 5).map {
      mock
    }
  }
}
#endif
