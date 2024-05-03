//
//  Router.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import SwiftUI

// MARK: - Router

public protocol RoutingProvider {
  func push(_ destination: any Hashable)
  func popLast()
  func popToRoot()
}

final class Router: ObservableObject, RoutingProvider {
  @Published var navPath = NavigationPath()
  
  func push(_ destination: any Hashable) {
    navPath.append(destination)
  }
  
  func popLast() {
    navPath.removeLast()
  }
  
  func popToRoot() {
    navPath.removeLast(navPath.count)
  }
}
