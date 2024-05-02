//
//  MockSession.swift
//  ProductListingExerciseTests
//
//  Created by Dipen Panchasara on 30/04/2024.
//

import Combine
import Foundation
@testable import ProductListingExercise

struct MockSession: URLSessionProvider {
  var session: URLSession = .shared
  private var responseData: Data?
  private var httpResponse: HTTPURLResponse
  struct NoStubError: Error {}
  private var error: Error?
  
  init(
    responseData: Data? = nil,
    httpResponse: HTTPURLResponse
  ) {
    self.responseData = responseData
    self.httpResponse = httpResponse
    self.error = NoStubError()
  }
  
  init(error: Error) {
    self.responseData = nil
    self.httpResponse = HTTPURLResponse()
    self.error = error
  }
  
  func dataTaskPublisher(for urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), any Error> {
    guard
      let data = responseData
    else {
      if error is NoStubError, let err = error {
        return Fail(error: err)
          .eraseToAnyPublisher()
      }
      return Fail(error: NetworkError.notFound)
        .eraseToAnyPublisher()
    }
    return Just((data, httpResponse))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
