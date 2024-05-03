//
//  ProductCard.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import Combine
import SwiftUI

struct ProductCard: View {
  private let contentColor = Color.black.opacity(.colorOpacity)
  private let backgroundColor = Color.gray.opacity(.backgroundOpacity)
  private let failureColor = Color.red.opacity(.colorOpacity)
  private let maxHeight: CGFloat = 420

  @ObservedObject
  var viewModel: ProductCardViewModel

  var body: some View {
    VStack(spacing: .zero) {
      ZStack(alignment: .bottom) {
        imageView()
        VStack(spacing: Spacing.x2) {
            titleView
          HStack(spacing: .zero) {
            labelView
            priceView
          }
          .padding(.bottom, Spacing.x2)
        }
        .background(contentColor)
      }
    }
    .background(backgroundColor)
    .clipShape(
      RoundedRectangle(
        cornerSize: CGSize(width: Spacing.x4, height: Spacing.x4)
      )
    )
    .frame(maxWidth: .infinity, maxHeight: maxHeight)
  }
}

private extension ProductCard {
  @ViewBuilder
  func imageView() -> some View {
    VStack(spacing: .zero) {
      viewModel.image
        .resizable()
        .scaledToFit()
        .foregroundStyle(.gray.opacity(.colorOpacity))
      .frame(minHeight: maxHeight)
    }
  }
  
  var emptyImageView: some View {
    ZStack {
      Color.gray.opacity(.colorOpacity)
      ProgressView()
        .minimumScaleFactor(2)
        .progressViewStyle(CircularProgressViewStyle())
        .tint(.white)
    }
  }
  
  var titleView: some View {
    Text(viewModel.title)
      .font(.title)
      .bold()
      .foregroundStyle(.white)
      .lineLimit(2)
      .padding(.horizontal, Spacing.x2)
      .padding(.top, Spacing.x2)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  var labelView: some View {
    if let labels = viewModel.labels {
      Text(labels)
        .font(.body)
        .foregroundStyle(.white)
        .lineLimit(2)
        .padding(.horizontal, Spacing.x2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  var priceView: some View {
    Text(viewModel.price)
      .font(.title)
      .bold()
      .foregroundStyle(.white)
      .padding(.horizontal, Spacing.x2)
      .padding(.bottom, Spacing.x2)
      .frame(alignment: .trailing)
  }
}

// MARK: - Previews
#if DEBUG
#Preview("With Image") {
//    ProductCard(model: .mock())
  ProductCard(viewModel: ProductCardViewModel(model: .mock()))
}

#Preview("Without Image") {
  ProductCard(
    viewModel: ProductCardViewModel(
      model: .mock(hasImage: false)
    )
  )
}

 extension ProductModel {
  static func mock(hasImage: Bool = true) -> ProductModel {
    ProductModel(
      id: 1,
      title: "anyTitle",
      labels: ["anyLabel_1", "anyLabel_2"],
      colour: "anyColor",
      price: 12.99,
      formattedPrice: "£12.99",
      featuredMedia: Media(
        id: 1,
        productId: 1,
        imageURLString: hasImage ? "https://cdn.shopify.com/s/files/1/1326/4923/products/VitalSeamlessLeggingsTahoeTealMarlB1A2B-TBBS.A_ZH_1.jpg?v=1644310928" : nil
      )
    )
  }
}
#endif
