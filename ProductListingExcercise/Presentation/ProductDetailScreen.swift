//
//  ProductDetailScreen.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import SwiftUI

struct ProductDetailScreen: View {
  @ObservedObject
  var viewModel: ProductDetailScreenViewModel

  var body: some View {
    ScrollView {
      headerView
      VStack(spacing: .zero) {
        ForEach(viewModel.rows) { model in
          switch model.type {
            case .text:
              RowView(model: viewModel.rows.first!)
            case .markdown:
              HTMLView(htmlContent: viewModel.rows.last!.value)
                .frame(maxWidth: .infinity, maxHeight: 600)
          }
        }
      }
    }
    .navigationTitle(viewModel.title)
    .navigationBarTitleDisplayMode(.inline)
    .task {
      viewModel.loadImage()
    }
  }
  
  var headerView: some View {
    ZStack(alignment: .bottom) {
      imageView
        .listRowInsets(EdgeInsets())
      HStack(spacing: .zero) {
        labelView
        Spacer()
        priceView
      }
      .background(.black.opacity(0.5))
    }
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
      .padding(.vertical, Spacing.x4)
      .frame(alignment: .trailing)
  }

  var imageView: some View {
    let image = viewModel.image ?? Image(systemName: "photo")
    return VStack(spacing: .zero) {
      image
        .resizable()
        .scaledToFit()
        .foregroundStyle(.gray.opacity(.colorOpacity))
        .frame(minHeight: .imageHeight)
    }
  }
}

#Preview {
  NavigationView {
    ProductDetailScreen(
      viewModel: ProductDetailScreenViewModel(
        model: .mock()
      )
    )
  }
}

private extension CGFloat {
  static let imageHeight: CGFloat = 420
}

