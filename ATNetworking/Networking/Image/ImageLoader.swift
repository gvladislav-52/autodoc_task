//
//  ImageLoader.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 22.07.2026.
//

import UIKit

public protocol ImageLoaderProtocol {
    func loadImage(from url: URL) async throws -> UIImage
}

public enum ImageLoaderError: Error {
    case invalidImageData
    case badResponse
}

public final actor ImageLoader: ImageLoaderProtocol {
    public static let shared = ImageLoader()

    private let cache: ImageCacheProtocol
    private let urlSession: URLSession
    private var inFlightTasks: [URL: Task<UIImage, Error>] = [:]

    public init(cache: ImageCacheProtocol = ImageCache.shared, urlSession: URLSession = .shared) {
        self.cache = cache
        self.urlSession = urlSession
    }

    public func loadImage(from url: URL) async throws -> UIImage {
        let key = url.absoluteString

        if let cached = cache.image(for: key) {
            return cached
        }

        if let existingTask = inFlightTasks[url] {
            return try await existingTask.value
        }

        let task = Task<UIImage, Error> { [urlSession, cache] in
            let (data, response) = try await urlSession.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200, httpResponse.statusCode <= 299 else {
                throw ImageLoaderError.badResponse
            }

            guard let image = UIImage(data: data) else {
                throw ImageLoaderError.invalidImageData
            }

            cache.store(image, for: key)
            return image
        }

        inFlightTasks[url] = task

        defer { inFlightTasks[url] = nil }

        return try await task.value
    }
}
