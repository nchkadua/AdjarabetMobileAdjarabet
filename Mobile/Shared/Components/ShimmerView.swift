//
//  ShimmerView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class ShimmerView: AppCircularView {
    private let animationKeyPath = "locations"

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInitialize()
    }

    private func sharedInitialize() {
        startAnimating()
    }

    private func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 0.5, 1.0]

        return gradientLayer
    }

    private func makeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1
        return animation
    }

    public func startAnimating(params: AnimationParams = .defaultAnimationParams) {
        let gradientLayer = makeGradientLayer()
        gradientLayer.colors = [params.leadingColor, params.middleColor, params.trailingColor].map { $0.value.cgColor }
        layer.addSublayer(gradientLayer)

        let animation = makeAnimation()

        gradientLayer.removeAnimation(forKey: animationKeyPath)
        gradientLayer.add(animation, forKey: animationKeyPath)
    }

    public struct AnimationParams {
        public var leadingColor: DesignSystem.Color
        public var middleColor: DesignSystem.Color
        public var trailingColor: DesignSystem.Color

        public static var defaultAnimationParams: AnimationParams {
            return .init(leadingColor: .secondaryText(alpha: 0.05),
                         middleColor: .secondaryText(alpha: 0.2),
                         trailingColor: .secondaryText(alpha: 0.05))
        }
    }
}
