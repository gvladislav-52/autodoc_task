//
//  ImageCache.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 22.07.2026.
//

import UIKit

public protocol ImageCacheProtocol {
    func image(for key: String) -> UIImage?
    func store(_ image: UIImage, for key: String)
}

public final class ImageCache: ImageCacheProtocol {
    public static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager: FileManager
    private let diskCacheURL: URL
    private let ioQueue = DispatchQueue(label: "com.autodoc.imagecache.io", qos: .utility)

    public init(
        fileManager: FileManager = .default,
        memoryCountLimit: Int = 200,
        memoryCostLimitBytes: Int = 100 * 1024 * 1024
    ) {
        self.fileManager = fileManager
        memoryCache.countLimit = memoryCountLimit
        memoryCache.totalCostLimit = memoryCostLimitBytes

        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskCacheURL = cachesDirectory.appendingPathComponent("ImageCache", isDirectory: true)

        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    public func image(for key: String) -> UIImage? {
        let cacheKey = Self.cacheKey(for: key)

        if let cached = memoryCache.object(forKey: cacheKey as NSString) {
            return cached
        }

        let fileURL = diskCacheFileURL(for: cacheKey)
        guard
            let data = try? Data(contentsOf: fileURL),
            let image = UIImage(data: data)
        else {
            return nil
        }

        memoryCache.setObject(image, forKey: cacheKey as NSString, cost: data.count)
        return image
    }

    public func store(_ image: UIImage, for key: String) {
        let cacheKey = Self.cacheKey(for: key)
        memoryCache.setObject(image, forKey: cacheKey as NSString)

        ioQueue.async { [diskCacheURL, fileManager] in
            guard let data = image.pngData() ?? image.jpegData(compressionQuality: 0.9) else { return }
            let fileURL = diskCacheURL.appendingPathComponent(cacheKey)
            try? data.write(to: fileURL, options: .atomic)
            _ = fileManager
        }
    }
}

private extension ImageCache {
    func diskCacheFileURL(for cacheKey: String) -> URL {
        diskCacheURL.appendingPathComponent(cacheKey)
    }

    static func cacheKey(for urlString: String) -> String {
        if let data = urlString.data(using: .utf8) {
            return data.base64EncodedString()
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "+", with: "-")
        }
        return urlString
    }
}
