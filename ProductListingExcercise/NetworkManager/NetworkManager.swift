//
//  NetworkManager.swift
//  ProductListingExcercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import Foundation
import Combine

// Request URL
// https://cdn.develop.gymshark.com/training/mock-product-responses/algolia-example-payload.json

protocol NetworkProvider {
  func execute(networkRequest: NetworkRequest) -> AnyPublisher<NetworkResponse, NetworkError>
}

struct NetworkConfig {
  enum Scheme: String {
    case http
    case https
  }

  let scheme: String
  let baseURL: String
  
  init(scheme: Scheme, baseURL: String) {
    self.scheme = scheme.rawValue
    self.baseURL = baseURL
  }
}

final class NetworkManager: NetworkProvider {
  enum Scheme: String {
    case http
    case https
  }

  private let scheme: Scheme
  private let baseURLString: String
  private let networkConfig: NetworkConfig
  private let session: URLSessionProvider
  
  init(scheme: Scheme, baseURLString: String, session: URLSessionProvider) {
    self.scheme = scheme
    self.baseURLString = baseURLString
    self.session = session
    self.networkConfig = NetworkConfig(scheme: .https, baseURL: "")
  }

  func execute(networkRequest: NetworkRequest) -> AnyPublisher<NetworkResponse, NetworkError> {
    var urlRequest: URLRequest
    do {
      urlRequest = try prepareURLRequest(networkRequest: networkRequest)
    } catch {
      return Fail(error: NetworkError.badURL(request: networkRequest))
        .eraseToAnyPublisher()
    }
        
    let publisher = session.dataTaskPublisher(for: urlRequest)
      .tryMap { (data: Data, response: URLResponse) in
        try self.handleResponse(data: data, response: response)
      }
      .mapError { error in
        return self.mapError(error: error)
      }
      .eraseToAnyPublisher()
    
    return publisher
  }
}

// MARK: - Request preparation

extension NetworkManager {
  func prepareURLRequest(networkRequest: NetworkRequest) throws -> URLRequest {
    var components = URLComponents()
    components.scheme = scheme.rawValue
    components.host = baseURLString
    components.path = networkRequest.endPoint
    guard
      let url = components.url
    else {
      throw NetworkError.badURL(request: networkRequest)
    }
    var request = URLRequest(url: url)
    request.httpMethod = networkRequest.httpMethod.value
    request.httpBody = networkRequest.data
    return request
  }
}

// MARK: - Response handling

private extension NetworkManager {
  func handleResponse(data: Data, response: URLResponse) throws -> NetworkResponse {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw mapHTTPError(statusCode: 0)
    }
    
    switch httpResponse.statusCode {
      case 200...299:
        return NetworkResponse(
          data: data,
          response: httpResponse
        )
      default:
        throw NetworkError.invalidResponse
    }
  }
}

// MARK: - Error handling

private extension NetworkManager {
  func mapHTTPError(statusCode: Int) -> NetworkError {
    switch statusCode {
      case 400: return .badRequest
      case 401: return .unauthorized
      case 403: return .forbidden
      case 404: return .notFound
      case 402, 405...499: return .error4xx(code: statusCode)
      case 500: return .serverError
      case 501...599: return .error5xx(code: statusCode)
      default: return .unknownError
    }
  }
  
  func mapError(error: Error) -> NetworkError {
    switch error {
      case let urlError as URLError:
        return .urlSessionFailed(error: urlError)
      case let error as NetworkError:
        return error
      default:
        return .unknownError
    }
  }
}
