//
//  ImageLoader.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 03/05/2024.
//

import Combine
import SwiftUI

final class ImageLoader {
  private var cache: URLCache = URLCache()
  private var requestTracker: [String: LoadingStatus] = [:]
  private var session: URLSession
  
  static var shared: ImageLoader = ImageLoader()

  enum LoadingStatus: Equatable {
    case loading
    case loaded(Image)
    case notFound
    case badURL
  }

  init() {
    let config = URLSessionConfiguration.default
    config.urlCache = cache
    session = URLSession(configuration: config)
  }

  func image(for url: String) -> AnyPublisher<LoadingStatus, Error> {
    guard let requestURL = URL(string: url) else {
      return Fail(error: URLError(.badURL))
        .eraseToAnyPublisher()
    }
    let urlString = requestURL.absoluteString
    let trackerStatus = requestTracker[urlString]

    // Check tracker
    if trackerStatus == .loading {
      return Just(LoadingStatus.loading)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    let request = URLRequest(url: requestURL)
    
    // Check cache & return if available.
    if
      let cached = cache.cachedResponse(for: request),
      let image = UIImage(data: cached.data)
    {
      return Just(LoadingStatus.loaded(Image(uiImage: image)))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    }
    
    // Load from network.
    requestTracker[urlString] = .loading
    
    return session.dataTaskPublisher(for: request)
      .tryMap {
        guard let httpResponse = $0.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return $0.data
      }
      .map { data in
        self.requestTracker.removeValue(forKey: urlString)
        /// **Note:** Further optimisation
        /// Either Resized image if large
        /// OR Ask server to return multiple asset link for different sizes
        guard let image = UIImage(data: data) else {
          return ImageLoader.LoadingStatus.notFound
        }
        return ImageLoader.LoadingStatus.loaded(Image(uiImage: image))
      }
      .eraseToAnyPublisher()
  }
}
