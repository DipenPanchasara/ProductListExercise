//
//  URLSessionProvider.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 30/04/2024.
//

import Combine
import Foundation

protocol URLSessionProvider {
  var session: URLSession { get }

  func dataTaskPublisher(for urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), any Error>
}

final class AppURLSession: URLSessionProvider {
  var session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = URLSession.shared
  }
  
  func dataTaskPublisher(for urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), any Error> {
    URLSession.DataTaskPublisher(request: urlRequest, session: session)
      .tryMap {
        ($0.data, $0.response)
      }
      .eraseToAnyPublisher()
  }
}
