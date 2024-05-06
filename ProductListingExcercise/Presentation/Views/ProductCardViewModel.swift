//
//  ProductCardViewModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Combine
import SwiftUI

final class ProductCardViewModel: ObservableObject {
  @Published var image: Image?
  private var cancellable: AnyCancellable?
  private var state: State = .idle
  
  let model: ProductDisplayModel
  enum State {
    case idle
    case loading
    case loaded
  }

  init(model: ProductDisplayModel) {
    self.model = model
  }

  func setImage(image: Image) {
    self.image = image
  }

  func loadImage() {
    guard 
      let url = model.urlString,
      image == nil,
      state == .idle
    else {  return }
    state = .loading
    
    cancellable = ImageDownloader.shared.image(urlString: url)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { completion in
        },
        receiveValue: { [weak self] receivedImage in
          self?.state = .loaded
          self?.image = receivedImage
        })
  }
}
