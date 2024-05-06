//
//  RowView.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 06/05/2024.
//

import SwiftUI

struct RowView: View {
  let model: Model
  
  var body: some View {
    HStack(alignment: .center) {
      HStack(alignment: .center, spacing: .zero) {
        if let title = model.title {
          Text(title)
            .font(.body)
            .bold()
            .multilineTextAlignment(.leading)
        }
        Spacer()
        Text(model.value)
          .font(.body)
          .multilineTextAlignment(.leading)
      }
      Spacer()
    }
    .padding(.horizontal, Spacing.x2)
    .padding(.vertical, Spacing.x2)
    Divider()
  }
  
  struct Model: Identifiable {
    enum ContentType {
      case text
      case markdown
    }
    
    let id = UUID()
    let title: String?
    let value: String
    let type: ContentType
    
    init(title: String? = nil, value: String, type: ContentType = .text) {
      self.title = title
      self.value = value
      self.type = type
    }
  }
}
