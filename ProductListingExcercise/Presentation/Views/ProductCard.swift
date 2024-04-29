//
//  ProductCard.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 29/04/2024.
//

import SwiftUI

struct ProductCard: View {
  private let contentColor = Color.black.opacity(.colorOpacity)
  private let backgroundColor = Color.gray.opacity(.backgroundOpacity)
  private let failureColor = Color.red.opacity(.colorOpacity)
  
  let model: ProductModel
  
  var body: some View {
    VStack(spacing: .zero) {
      ZStack(alignment: .bottom) {
        imageView()
          VStack(alignment: .leading, spacing: Spacing.x2) {
            titleView
            labelView
            priceView
          }
          .frame(maxWidth: .infinity)
          .background(contentColor)
      }
    }
    .background(backgroundColor)
    .clipShape(
      RoundedRectangle(
        cornerSize: CGSize(width: Spacing.x4, height: Spacing.x4)
      )
    )
    .frame(maxWidth: .infinity, maxHeight: 450)
  }
}

private extension ProductCard {
  @ViewBuilder
  func imageView() -> some View {
    VStack(spacing: .zero) {
      if
        let imageURLString = model.featuredMedia.imageURLString,
        let imageURL = URL(string: imageURLString)
      {
      AsyncImage(url: imageURL) { phase in
        switch phase {
          case .empty:
            emptyImageView
          case .failure:
            Image(systemName: "photo")
              .resizable()
              .scaledToFit()
              .foregroundStyle(.gray.opacity(.colorOpacity))
              .frame(width: 100, height: 100)
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode:
                  .fit)
          @unknown default:
            emptyImageView
        }
      }
      .frame(minHeight: 450)
      }
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
    HStack(alignment: .center, spacing: .zero) {
      Text(model.title)
        .font(.title2)
        .bold()
        .foregroundStyle(.white)
        .lineLimit(2)
        .padding(.horizontal, Spacing.x2)
        .padding(.top, Spacing.x2)
      Spacer()
    }
  }
  
  @ViewBuilder
  var labelView: some View {
    if !model.labels.isEmpty {
      HStack(alignment: .center, spacing: .zero) {
        Text(model.labels.joined(separator: ", "))
          .font(.body)
          .foregroundStyle(.white)
          .lineLimit(2)
          .multilineTextAlignment(.leading)
          .padding(.horizontal, Spacing.x2)
        Spacer()
      }
    }
  }
  
  var priceView: some View {
    HStack {
      Text(model.formattedPrice)
        .font(.title3)
        .bold()
        .foregroundStyle(.green)
        .padding(.horizontal, Spacing.x2)
        .padding(.bottom, Spacing.x2)
      Spacer()
    }
  }
}

// MARK: - Previews
#if DEBUG
#Preview("With Image") {
    ProductCard(model: .mock())
}

#Preview("Without Image") {
  ProductCard(model: .mock(hasImage: false))
}

private extension ProductModel {
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
