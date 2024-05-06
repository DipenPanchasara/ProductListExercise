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
      .redacted(reason: viewModel.viewState == .loading ? .placeholder : .invalidated)
  }

  var listView: some View {
    List {
      ForEach(viewModel.products) { product in
        ProductCard(
          viewModel: ProductCardViewModel(
            model: ProductDisplayModel(model: product)
          )
        )
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
      description: "<p><strong>RUN WITH IT</strong></p>\n<p><br data-mce-fragment=\"1\">Your run requires enduring comfort and support, so step out and hit the road in Speed. Made with zero-distractions and lightweight, ventilating fabrics that move with you, you can trust in Speed no matter how far you go.</p>\n<p> </p>\n<p><br data-mce-fragment=\"1\">- Full length legging<br data-mce-fragment=\"1\">- High-waisted<br data-mce-fragment=\"1\">- Compressive fit<br data-mce-fragment=\"1\">- Internal adjustable elastic/drawcord at front waistband<br data-mce-fragment=\"1\">- Pocket to back of waistband<br data-mce-fragment=\"1\">- Reflective Gymshark sharkhead logo to ankle<br data-mce-fragment=\"1\">- Main: 88% Polyester 12% Elastane. Internal Mesh: 76% Nylon 24% Elastane<br data-mce-fragment=\"1\">- We've cut down our use of swing tags, so this product comes without one<br data-mce-fragment=\"1\">- Model is <meta charset=\"utf-8\"><span data-usefontface=\"true\" data-contrast=\"none\" class=\"TextRun SCXP103297068 BCX0\" lang=\"EN-GB\" data-mce-fragment=\"1\" xml:lang=\"EN-GB\"><span class=\"NormalTextRun SCXP103297068 BCX0\" data-mce-fragment=\"1\">5'3\" and wears a size M</span></span><br>- SKU: B3A3E-BBBB</p>",
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
