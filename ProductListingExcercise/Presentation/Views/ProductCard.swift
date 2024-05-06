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

  @StateObject
  var viewModel: ProductCardViewModel

  var body: some View {
    VStack(spacing: .zero) {
      ZStack(alignment: .bottom) {
        imageView
        VStack(spacing: Spacing.x2) {
            titleView
          HStack(spacing: .zero) {
            labelView
            Spacer()
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
    .task {
      viewModel.loadImage()
    }
  }
}

private extension ProductCard {
  var imageView: some View {
    let image = viewModel.image ?? Image(systemName: "photo")
    return VStack(spacing: .zero) {
      image
        .resizable()
        .scaledToFit()
        .foregroundStyle(.gray.opacity(.colorOpacity))
        .frame(minHeight: maxHeight)
    }
  }
    
  var titleView: some View {
    Text(viewModel.model.title)
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
    if let labels = viewModel.model.labels {
      Text(labels)
        .font(.body)
        .foregroundStyle(.white)
        .lineLimit(2)
        .padding(.horizontal, Spacing.x2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  var priceView: some View {
    Text(viewModel.model.price)
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
  ProductCard(
    viewModel: ProductCardViewModel(
      model: .mock()
    )
  )
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
      description: "<p><strong>RUN WITH IT</strong></p>\n<p><br data-mce-fragment=\"1\">Your run requires enduring comfort and support, so step out and hit the road in Speed. Made with zero-distractions and lightweight, ventilating fabrics that move with you, you can trust in Speed no matter how far you go.</p>\n<p> </p>\n<p><br data-mce-fragment=\"1\">- Full length legging<br data-mce-fragment=\"1\">- High-waisted<br data-mce-fragment=\"1\">- Compressive fit<br data-mce-fragment=\"1\">- Internal adjustable elastic/drawcord at front waistband<br data-mce-fragment=\"1\">- Pocket to back of waistband<br data-mce-fragment=\"1\">- Reflective Gymshark sharkhead logo to ankle<br data-mce-fragment=\"1\">- Main: 88% Polyester 12% Elastane. Internal Mesh: 76% Nylon 24% Elastane<br data-mce-fragment=\"1\">- We've cut down our use of swing tags, so this product comes without one<br data-mce-fragment=\"1\">- Model is <meta charset=\"utf-8\"><span data-usefontface=\"true\" data-contrast=\"none\" class=\"TextRun SCXP103297068 BCX0\" lang=\"EN-GB\" data-mce-fragment=\"1\" xml:lang=\"EN-GB\"><span class=\"NormalTextRun SCXP103297068 BCX0\" data-mce-fragment=\"1\">5'3\" and wears a size M</span></span><br>- SKU: B3A3E-BBBB</p>",
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

extension ProductDisplayModel {
  static func mock(hasImage: Bool = true) -> Self {
    ProductDisplayModel(model: .mock(hasImage: hasImage))
  }
}
#endif
