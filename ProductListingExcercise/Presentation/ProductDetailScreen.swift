//
//  ProductDetailScreen.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import SwiftUI

struct ProductDetailScreen: View {
  var viewModel: ProductDetailScreenViewModel
  
  var body: some View {
    ScrollView {
      photoGallery
      ForEach(viewModel.rows) { row in
        RowView(title: row.title, value: row.value)
      }
    }
//    .listStyle(.plain)
//    .navigationTitle("Some Product")
  }
  
  var photoGallery: some View {
    ZStack(alignment: .bottom) {
      PhotoGalleryView()
        .listRowInsets(EdgeInsets())
      HStack(spacing: .zero) {
        Spacer()
        priceView
      }
      .background(.black.opacity(0.5))
    }
  }
  
  var priceView: some View {
    Text(viewModel.price)
      .font(.title)
      .bold()
      .foregroundStyle(.white)
      .padding(.horizontal, Spacing.x2)
      .padding(.vertical, Spacing.x4)
      .frame(alignment: .trailing)
  }

}

#Preview {
  ProductDetailScreen(viewModel: ProductDetailScreenViewModel(model: .mock()))
}

struct RowView: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading, spacing: .zero) {
        Text(title.capitalized)
          .font(.subheadline)
          .bold()
        Text(value)
          .font(.body)
          .multilineTextAlignment(.leading)
      }
      Spacer()
    }
    .padding(.horizontal, Spacing.x2)
    .padding(.vertical, Spacing.x1)
    Divider()
  }
}

struct PhotoGalleryView: View {
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: .zero) {
        ForEach(0..<5) { _ in
          Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: .infinity,height: .photoHeight)
            .containerRelativeFrame(.horizontal)
        }
      }
      .scrollTargetLayout()
    }
    .defaultScrollAnchor(.zero)
    .scrollIndicators(.never)
    .scrollTargetBehavior(.paging)
    .frame(maxWidth: .infinity, maxHeight: .photoHeight)
  }
}

private extension CGFloat {
  static let photoHeight: CGFloat = 400
}
