//
//  ProductCardViewModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Combine
import SwiftUI

final class ProductCardViewModel: ObservableObject {
  @Published private(set) var image: Image
  private var cancellable: AnyCancellable?
  private let model: ProductModel
  
  var labels: String? {
    if model.labels.isEmpty {
      return nil
    }
    return model.labels.joined(separator: ", ")
  }
  
  var title: String {
    model.title
  }
  
  var price: String {
    model.formattedPrice
  }
  
  init(model: ProductModel) {
    self.image = Image(systemName: "photo")
    self.model = model
    loadImage()
  }
  
  private func loadImage() {
    if let imageURLString = model.featuredMedia.imageURLString {
      cancellable = ImageLoader.shared.image(for: imageURLString)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
          if case let .failure(error) = completion {
            print("ImageLoading failed with error: \(error)")
          }
        }) { status in
          switch status {
            case .loading, .notFound, .badURL:
              break
            case .loaded(let image):
              self.image = image
          }
        }
    }
  }
}
