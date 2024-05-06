//
//  ProductDetailScreenViewModel.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Foundation

final class ProductDetailScreenViewModel: ObservableObject {
  var model: ProductModel
  private(set) var rows: [Row] = []
  
  init(model: ProductModel) {
    self.model = model
    
    rows.append(Row(title: "", value: model.title))
    if let labels {
      rows.append(Row(title: "", value: labels))
    }
    rows.append(Row(title: "", value: model.title))
  }
  
  private var labels: String? {
    if model.labels.isEmpty {
      return nil
    }
    return model.labels.joined(separator: ", ")
  }
  
  private var title: String {
    model.title
  }
  
  var price: String {
    model.formattedPrice
  }
}

struct Row: Identifiable {
  let title: String
  let value: String
  
  var id: String {
    title + value
  }
}
