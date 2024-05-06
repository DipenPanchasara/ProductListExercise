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

  @MainActor
  func loadImage() {
    guard 
      image == nil,
      state == .idle
    else {  return }
    state = .loading
    if
      let urlString = model.urlString,
      let url = URL(string: urlString)
    {
    let request = URLRequest(url: url)
    cancellable = URLSession.shared.dataTaskPublisher(for: request)
      .receive(on: DispatchQueue.main)
      .tryMap {
        guard
          let httpResponse = $0.response as? HTTPURLResponse,
          httpResponse.statusCode == 200,
          let image = UIImage(data: $0.data)
        else {
          throw URLError(.badServerResponse)
        }
        return Image(uiImage: image)
      }
      .sink(
        receiveCompletion: { completion in
        }, 
        receiveValue: { [weak self] receivedImage in
          self?.state = .loaded
          self?.image = receivedImage
      })
    }
  }
}

//extension ProductCardViewModel {
//  struct DisplayModel: Hashable {
//    let id: Int
//    let title: String
//    var description: String
//    let price: String
//    var labels: String?
//    let urlString: String?
//    var color: String
//    
//    init(model: ProductModel) {
//      id = model.id
//      title = model.title
//      description = model.description
//      price = model.formattedPrice
//      labels = !model.labels.isEmpty ? model.labels.joined(separator: ", ") : nil
//      urlString = model.featuredMedia.imageURLString
//      color = model.colour
//    }
//  }
//}

