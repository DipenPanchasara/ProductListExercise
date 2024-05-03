//
//  RootViewModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Combine
import Foundation
import SwiftUI

class RootViewModel: ObservableObject {
  @Published var router = Router()

  private var networkManager: NetworkProvider
  private var cancellable : AnyCancellable?

  lazy var productListScreenViewModel: ProductListScreenViewModel = {
    ProductListScreenViewModelFactory.make(
      router: router,
      networkManager: networkManager
    )
  }()

  
  init() {
    self.networkManager = NetworkManager(
      scheme: .https,
      baseURLString: "cdn.develop.gymshark.com",
      session: AppURLSession()
    )
    self.cancellable = self.router.$navPath.sink(
      receiveValue: { [weak self] _ in
        self?.objectWillChange.send()
      }
    )
  }
}
