//
//  ProductListUseCaseUnitTests.swift
//  ProductListingExerciseTests
//
//  Created by Dipen Panchasara on 02/05/2024.
//

import Combine
@testable import ProductListingExercise
import XCTest

final class ProductListUseCaseUnitTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()

  func testUseCaseSuccess() throws {
    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(mockProductsData)

    let mockHTTPResponse = try XCTUnwrap(HTTPURLResponse(
      url: XCTUnwrap(URL(string: "www.test.com")),
      statusCode: 200,
      httpVersion: "testVersion",
      headerFields: nil
    ))
    
    let mockSession = MockSession(
      responseData: jsonData,
      httpResponse: mockHTTPResponse
    )
    let networkManager = NetworkManager(
      scheme: .http,
      baseURLString: "www.test.com",
      session: mockSession
    )
    let sut = ProductListUseCase(networkManager: networkManager)
    var expectedProducts: [ProductsData.ProductData] = []
    sut.run()
      .sink { completion in
        switch completion {
          case .finished:
            XCTAssertEqual(expectedProducts.count, 2)
          case .failure(let error):
            XCTFail("Shouldn't throw \(error)")
        }
      } receiveValue: { product in
        expectedProducts.append(contentsOf: product)
      }
      .store(in: &cancellables)
  }
  
  func testUseCaseFailsWhenNetworkManagerThrows() throws {    
    let mockSession = MockSession(error: MockError.networkError)
    let networkManager = NetworkManager(
      scheme: .http,
      baseURLString: "www.test.com",
      session: mockSession
    )
    let sut = ProductListUseCase(networkManager: networkManager)
    sut.run()
      .sink { completion in
        switch completion {
          case .finished:
            XCTFail("Shouldn't finish successfully")
          case .failure(let error):
            XCTAssertEqual(error, UseCaseError.unknownError)
        }
      } receiveValue: { _ in
        XCTFail("Shouldn't call")
      }
      .store(in: &cancellables)
  }
}


private extension ProductListUseCaseUnitTests {
  enum MockError: Error {
    case noData
    case networkError
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
  
  var mockProductsData: ProductsData {
    ProductsData(
      hits: [ProductsData.ProductData].init(repeating: mockData, count: 2)
    )
  }
}
