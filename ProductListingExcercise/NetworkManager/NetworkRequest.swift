//
//  NetworkRequest.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 28/04/2024.
//

import Foundation

struct NetworkRequest: Equatable {
  enum HTTPMethod: String {
    case get
    
    var value: String {
      self.rawValue.capitalized
    }
  }
  
  let httpMethod: HTTPMethod
  let endPoint: String
  let data: Data?
  
  init(httpMethod: HTTPMethod, endPoint: String, data: Data?) {
    self.httpMethod = httpMethod
    self.endPoint = endPoint
    self.data = data
  }
}
