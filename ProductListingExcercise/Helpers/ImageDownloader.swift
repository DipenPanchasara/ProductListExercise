//
//  ImageDownloader.swift
//  ProductListingExercise
//
//  Created by Dipen Panchasara on 06/05/2024.
//

import SwiftUI
import Combine

protocol ImageDownloaderProvider {
  func image(urlString: String) -> AnyPublisher<Image?, Never>
}

struct ImageDownloader: ImageDownloaderProvider {
  static let shared: ImageDownloader = ImageDownloader()
  private let session: URLSession
  private let urlCache = URLCache()

  init() {
    let config = URLSessionConfiguration.default
    config.urlCache = urlCache
    self.session = URLSession(configuration: config)
  }
  
  func image(urlString: String) -> AnyPublisher<Image?, Never> {
    if let url = URL(string: urlString) {
      let request = URLRequest(url: url)
      
      if let response = getCache(request: request) {
        do {
          let image = try processResponse(data: response.data, response: response.response)
          return Just(image).eraseToAnyPublisher()
        } catch {
          return Just(nil).eraseToAnyPublisher()
        }
      }

      return session.dataTaskPublisher(for: request)
        .receive(on: DispatchQueue.main)
        .tryMap {
          try processResponse(data: $0.data, response: $0.response)
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
    return Just(nil).eraseToAnyPublisher()
  }
  
  func clearCache() {
    urlCache.removeAllCachedResponses()
  }
}

private extension ImageDownloader {
  func updateCache(data: Data, response: URLResponse, request: URLRequest) {
    let cachedResponse = CachedURLResponse(response: response, data: data)
    urlCache.storeCachedResponse(cachedResponse, for: request)
  }
  
  func getCache(request: URLRequest) -> (data: Data, response: URLResponse)? {
    guard let cachedResponse = urlCache.cachedResponse(for: request) else {
      return nil
    }
    return (data: cachedResponse.data, response: cachedResponse.response)
  }
  
  func processResponse(data: Data, response: URLResponse) throws -> Image {
    guard
      let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200,
      let image = UIImage(data: data)
    else {
      throw URLError(.badServerResponse)
    }
    return Image(uiImage: image)
  }
}
