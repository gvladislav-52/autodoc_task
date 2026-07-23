//
//  SkeletonView.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 23.07.2026.
//

import UIKit

public final class SkeletonView: UIView {
    private let outerStackView = UIStackView()
    private var cells: [SkeletonCellView] = []

    private let rowsCount = 8
    private var currentColumnCount = 1
    private var isAnimating = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupOuterStackView()
        rebuildGrid(columnCount: columnCount(for: traitCollection))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass else { return }

        let newColumnCount = columnCount(for: traitCollection)
        guard newColumnCount != currentColumnCount else { return }

        rebuildGrid(columnCount: newColumnCount)

        if isAnimating {
            startAnimating()
        }
    }

    public func startAnimating() {
        isAnimating = true
        cells.forEach { cell in
            cell.placeholders.forEach { $0.startAnimating() }
        }
    }

    public func stopAnimating() {
        isAnimating = false
        cells.forEach { cell in
            cell.placeholders.forEach { $0.stopAnimating() }
        }
    }
}

private extension SkeletonView {
    func rebuildGrid(columnCount: Int) {
        currentColumnCount = columnCount

        outerStackView.arrangedSubviews.forEach {
            outerStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        cells.removeAll()

        for _ in 0..<rowsCount {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 16
            rowStackView.alignment = .top
            rowStackView.distribution = .fillEqually

            for _ in 0..<columnCount {
                let cell = SkeletonCellView()
                cells.append(cell)
                rowStackView.addArrangedSubview(cell)
            }

            outerStackView.addArrangedSubview(rowStackView)
        }
    }

    func columnCount(for traitCollection: UITraitCollection) -> Int {
        traitCollection.horizontalSizeClass == .regular ? 2 : 1
    }

    func setupOuterStackView() {
        outerStackView.axis = .vertical
        outerStackView.spacing = 24
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(outerStackView)

        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
