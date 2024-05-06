//
//  ProductDetailScreenViewModelUnitTests.swift
//  ProductListingExerciseTests
//
//  Created by Dipen Panchasara on 06/05/2024.
//

import Combine
@testable import ProductListingExercise
import XCTest

final class ProductDetailScreenViewModelUnitTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()
  
  override func tearDown() async throws {
    cancellables.removeAll()
  }
  
  func testInit() throws {
    let mock: ProductDisplayModel = .mock()
    let sut = ProductDetailScreenViewModel(model: mock)
    XCTAssertEqual(sut.title, mock.title)
    XCTAssertEqual(sut.price, mock.price)
    XCTAssertEqual(sut.labels, mock.labels)
    XCTAssertNil(sut.image)
    let colorRow = try XCTUnwrap(sut.rows.first)
    XCTAssertEqual(colorRow.value, mock.color)
    let descriptionRow = try XCTUnwrap(sut.rows.last)
    XCTAssertEqual(descriptionRow.value, mock.description)
  }
}

extension ProductModel {
  static func mock() -> ProductModel {
    ProductModel(
      id: 1,
      title: "anyTitle",
      description: "anyDescription",
      labels: ["anyLabel_1"],
      colour: "anyColor",
      price: 12.99,
      formattedPrice: "£12.99",
      featuredMedia: Media(
        id: 1,
        productId: 1,
        imageURLString: nil
      )
    )
  }
}

extension ProductDisplayModel {
  static func mock() -> Self {
    ProductDisplayModel(model: .mock())
  }
}
