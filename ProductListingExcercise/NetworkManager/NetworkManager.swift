//
//  NetworkManager.swift
//  ProductListingExcercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import Foundation
import Combine

struct NetworkResponse {
  var data: Data?
  let response: HTTPURLResponse
}

protocol NetworkProvider {
  func execute(networkRequest: NetworkRequest) -> NetworkResponse
}

enum NetworkError: Error {
  case invalidURL
}

final class NetworkManager: NetworkProvider {
  enum Scheme: String {
    case http
    case https
  }
  
  private let scheme: Scheme
  private let baseURL: URL
  private let session: URLSession
  
  init(scheme: Scheme, baseURLString: String) throws {
    self.scheme = scheme
    var components = URLComponents()
    components.scheme = scheme.rawValue
    components.host = baseURLString
    guard let baseURL = components.url else { throw NetworkError.invalidURL }
    self.baseURL = baseURL

    // We don't want to store cache, cookie or credentials
    self.session = URLSession(configuration: URLSessionConfiguration.ephemeral)
  }

  func execute(networkRequest: NetworkRequest) -> NetworkResponse {
    NetworkResponse(response: HTTPURLResponse())
  }
}
