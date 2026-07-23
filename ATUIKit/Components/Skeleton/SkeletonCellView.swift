//
//  SkeletonCellView.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 23.07.2026.
//

import UIKit

internal final class SkeletonCellView: UIView {
    private let imagePlaceholder = ShimmerPlaceholderView()
    private let titlePlaceholder = ShimmerPlaceholderView()
    private let subtitlePlaceholder = ShimmerPlaceholderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var placeholders: [ShimmerPlaceholderView] {
        [imagePlaceholder, titlePlaceholder, subtitlePlaceholder]
    }
}

private extension SkeletonCellView {
    func setupLayout() {
        [imagePlaceholder, titlePlaceholder, subtitlePlaceholder].forEach {
            $0.cornerRadius = 6
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            imagePlaceholder.topAnchor.constraint(equalTo: topAnchor),
            imagePlaceholder.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagePlaceholder.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagePlaceholder.heightAnchor.constraint(equalToConstant: 140),

            titlePlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 12),
            titlePlaceholder.leadingAnchor.constraint(equalTo: leadingAnchor),
            titlePlaceholder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            titlePlaceholder.heightAnchor.constraint(equalToConstant: 16),

            subtitlePlaceholder.topAnchor.constraint(equalTo: titlePlaceholder.bottomAnchor, constant: 8),
            subtitlePlaceholder.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitlePlaceholder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -140),
            subtitlePlaceholder.heightAnchor.constraint(equalToConstant: 14),
            subtitlePlaceholder.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
