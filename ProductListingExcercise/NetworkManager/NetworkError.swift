//
//  NetworkError.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import Foundation

enum NetworkError: Error {
  case badURL(_ request: NetworkRequest)
  case invalidResponse
  case invalidRequest
  case badRequest
  case unauthorized
  case forbidden
  case notFound
  case error4xx(_ code: Int)
  case serverError
  case error5xx(_ code: Int)
  case urlSessionFailed(_ error: URLError)
  case timeOut
  case unknownError
}
