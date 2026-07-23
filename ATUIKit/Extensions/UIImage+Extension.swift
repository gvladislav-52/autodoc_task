//
//  UIImage+Extension.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 22.07.2026.
//

import UIKit
import ATNetworking

private var currentImageURLKey: UInt8 = 0
private var currentTaskKey: UInt8 = 0

public extension UIImageView {
    private var currentImageURL: URL? {
        get { objc_getAssociatedObject(self, &currentImageURLKey) as? URL }
        set { objc_setAssociatedObject(self, &currentImageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentTask: Task<Void, Never>? {
        get { objc_getAssociatedObject(self, &currentTaskKey) as? Task<Void, Never> }
        set { objc_setAssociatedObject(self, &currentTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setImage(
        with url: URL?,
        placeholder: UIImage? = nil,
        loader: ImageLoaderProtocol = ImageLoader.shared
    ) {
        currentTask?.cancel()

        guard let url else {
            image = placeholder
            currentImageURL = nil
            return
        }

        currentImageURL = url
        image = placeholder

        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                let loadedImage = try await loader.loadImage(from: url)
                guard !Task.isCancelled, self.currentImageURL == url else { return }
                await MainActor.run {
                    self.image = loadedImage
                }
            } catch {
            }
        }
    }
}
