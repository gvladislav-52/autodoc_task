//
//  ShimmerPlaceholderView.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 23.07.2026.
//

import UIKit

internal final class ShimmerPlaceholderView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let shimmerAnimationKey = "shimmer.sweep"
    private let pulseAnimationKey = "shimmer.pulse"

    private var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        clipsToBounds = true
        setupGradientLayer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var cornerRadius: CGFloat = 6 {
        didSet { layer.cornerRadius = cornerRadius }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)

        if isAnimating {
            startAnimationsIfNeeded()
        }
    }

    func startAnimating() {
        isAnimating = true
        startAnimationsIfNeeded()
    }

    func stopAnimating() {
        isAnimating = false
        gradientLayer.removeAnimation(forKey: shimmerAnimationKey)
        layer.removeAnimation(forKey: pulseAnimationKey)
    }
}

private extension ShimmerPlaceholderView {
    func setupGradientLayer() {
        let baseColor = UIColor.systemGray5.cgColor
        let highlightColor = UIColor.systemGray3.cgColor

        gradientLayer.colors = [baseColor, highlightColor, baseColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.35, 0.5, 0.65]
        layer.addSublayer(gradientLayer)
    }

    func startAnimationsIfNeeded() {
        guard bounds.width > 0 else { return }

        if gradientLayer.animation(forKey: shimmerAnimationKey) == nil {
            let sweep = CABasicAnimation(keyPath: "transform.translation.x")
            sweep.fromValue = -bounds.width
            sweep.toValue = bounds.width
            sweep.duration = 1.2
            sweep.repeatCount = .infinity
            gradientLayer.add(sweep, forKey: shimmerAnimationKey)
        }

        if layer.animation(forKey: pulseAnimationKey) == nil {
            let pulse = CABasicAnimation(keyPath: "opacity")
            pulse.fromValue = 1.0
            pulse.toValue = 0.55
            pulse.duration = 0.8
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            layer.add(pulse, forKey: pulseAnimationKey)
        }
    }
}
