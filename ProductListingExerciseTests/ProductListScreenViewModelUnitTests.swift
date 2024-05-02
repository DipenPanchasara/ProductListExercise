//
//  ProductListScreenViewModelUnitTests.swift
//  ProductListingExerciseTests
//
//  Created by Dipen Panchasara on 30/04/2024.
//

import Combine
@testable import ProductListingExercise
import XCTest

final class ProductListScreenViewModelUnitTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()

  override func tearDown() async throws {
    cancellables.removeAll()
  }

  func testInit() {
    let mockUseCase = MockProductListUseCase(error: MockError.noData)
    let sut = ProductListScreenViewModel(
      productListUseCase: mockUseCase,
      productMapper: ProductDataToModelMapper(currencyFormatter: currencyFormatter)
    )
    XCTAssertTrue(sut.products.isEmpty)
  }
  
  func testViewModelWhenProductsLoaded() async {
    let expecation = expectation(description: "Wait for Products to load")
    let mockModels = mockProductModels
    let mockUseCase = MockProductListUseCase(productData: mockProductsData)
    let sut = ProductListScreenViewModel(
      productListUseCase: mockUseCase,
      productMapper: ProductDataToModelMapper(currencyFormatter: currencyFormatter)
    )
    sut.$products.sink { products in
      if products.count == mockModels.count {
        XCTAssertEqual(products, mockModels)
        expecation.fulfill()
      }
    }
    .store(in: &cancellables)
    sut.loadData()
    await fulfillment(of: [expecation], timeout: 1)
  }
  
  func testViewModelWhenProductsUseCaseThrows() async {
    let expecation = expectation(description: "Wait for Product UseCase to throw")
    let mockUseCase = MockProductListUseCase(error: MockError.noData)
    let sut = ProductListScreenViewModel(
      productListUseCase: mockUseCase,
      productMapper: ProductDataToModelMapper(currencyFormatter: currencyFormatter)
    )
    var receivedProducts: [ProductModel] = []
    sut.$products.sink { products in
      receivedProducts.append(contentsOf: products)
      expecation.fulfill()
    }
    .store(in: &cancellables)
    sut.loadData()
    await fulfillment(of: [expecation], timeout: .zero)
    XCTAssertTrue(receivedProducts.isEmpty)
  }
}

private extension ProductListScreenViewModelUnitTests {
  enum MockError: Error {
    case noData
  }
  
  var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_GB")
    formatter.currencyCode = "£"
    return formatter
  }
  
  var mockData: ProductsData.ProductData {
    ProductsData.ProductData(
      id: 1,
      title: "anyTitle",
      labels: ["anyLable_1"],
      colour: "anyColor",
      price: 12.99,
      featuredMedia: ProductsData.Media(
        id: 1,
        product_id: 1,
        src: "anyURL"
      )
    )
  }
  
  var mockProductsData: [ProductsData.ProductData] {
    [ProductsData.ProductData].init(repeating: mockData, count: 2)
  }
  
  var mockModel: ProductModel {
    ProductModel(
      id: 1,
      title: "anyTitle",
      labels: ["anyLable_1"],
      colour: "anyColor",
      price: 12.99,
      formattedPrice: "£12.99",
      featuredMedia: ProductModel.Media(
        id: 1,
        productId: 1,
        imageURLString: "anyURL"
      )
    )
  }
  
  var mockProductModels: [ProductModel] {
    [ProductModel].init(repeating: mockModel, count: 2)
  }
}
