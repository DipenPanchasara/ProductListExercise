//
//  NetworkError.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import Foundation

enum NetworkError: Error, Equatable {
  case badURL(request: NetworkRequest)
  case invalidResponse
  case invalidRequest
  case badRequest
  case unauthorized
  case forbidden
  case notFound
  case error4xx(code: Int)
  case serverError
  case error5xx(code: Int)
  case urlSessionFailed(error: URLError)
  case timeOut
  case unknownError
}
