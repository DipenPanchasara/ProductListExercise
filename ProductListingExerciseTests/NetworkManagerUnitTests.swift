//
//  NetworkManagerUnitTests.swift
//  ProductListingExerciseTests
//
//  Created by Dipen Panchasara on 30/04/2024.
//

import Combine
@testable import ProductListingExercise
import XCTest

final class NetworkManagerUnitTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()

  func testExecuteRequestSuccess() async throws {
    let mockResponseString = "mockResponseData"
    let mockResponseData = try XCTUnwrap(mockResponseString.data(using: .utf8))
    let mockHTTPResponse = try XCTUnwrap(HTTPURLResponse(
      url: XCTUnwrap(URL(string: "www.test.com")),
      statusCode: 200,
      httpVersion: "testVersion",
      headerFields: nil
    ))

    let mockSession = MockSession(
      responseData: mockResponseData,
      httpResponse: mockHTTPResponse
    )
    let sut = NetworkManager(
      scheme: .http,
      baseURLString: "www.test.com",
      session: mockSession
    )
    
    let expectation = expectation(description: "wait for response")
    sut.execute(
      networkRequest: NetworkRequest(
        httpMethod: .get,
        endPoint: "/testEndpoint"
      )
    )
    .sink(receiveCompletion: { completion in
      switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let error):
          XCTFail("Expected success response, receive error: \(error)")
      }
    }, receiveValue: { response in
      XCTAssertEqual(response.data, mockResponseData)
      XCTAssertEqual(response.response, mockHTTPResponse)
    })
    .store(in: &cancellables)
    await fulfillment(of: [expectation], timeout: .zero)
    cancellables.removeAll()
  }
  
  func testExecuteRequestFailsDueToWrongRequestEndpoint() async throws {
    let mockSession = MockSession(
      responseData: Data(),
      httpResponse: HTTPURLResponse()
    )
    let sut = NetworkManager(
      scheme: .http,
      baseURLString: "www.test.com",
      session: mockSession
    )
    
    let expectation = expectation(description: "wait for response")
    let request = NetworkRequest(
      httpMethod: .get,
      endPoint: "testEndpoint"
    )
    sut.execute(networkRequest: request)
    .sink(receiveCompletion: { completion in
      switch completion {
        case .finished:
          XCTFail("Expected failure")
        case .failure(let error):
          XCTAssertEqual(error, NetworkError.badURL(request: request))
          expectation.fulfill()
      }
    }, receiveValue: { response in
      XCTFail("Expected failure")
    })
    .store(in: &cancellables)
    await fulfillment(of: [expectation], timeout: .zero)
    cancellables.removeAll()
  }
}
