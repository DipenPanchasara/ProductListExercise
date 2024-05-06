//
//  ProductDetailScreenViewModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Combine
import SwiftUI

final class ProductDetailScreenViewModel: ObservableObject {
  @Published var image: Image?
  private let model: ProductDisplayModel
  private var state: State = .idle
  private var cancellable: AnyCancellable?
  private(set) var rows: [RowView.Model] = []

  var labels: String?
  let title: String
  let price: String

  enum State {
    case idle
    case loading
    case loaded
  }

  init(model: ProductDisplayModel) {
    self.model = model
    title = model.title
    price = model.price
    labels = model.labels
    prepareRows()
  }
  
  private func prepareRows() {
    rows.append(RowView.Model(title: "Color", value: model.color))
    rows.append(RowView.Model(value: model.description, type: .markdown))
  }
}

extension ProductDetailScreenViewModel {
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
        receiveCompletion: { _ in },
        receiveValue: { [weak self] receivedImage in
          self?.state = .loaded
          self?.image = receivedImage
        })
    }
  }
}
