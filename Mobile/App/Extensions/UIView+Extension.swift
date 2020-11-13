//
//  UIView+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func pin(to parentView: UIView) -> EdgeConstraint {
        let top = topAnchor.constraint(equalTo: parentView.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        let left = leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        let right = trailingAnchor.constraint(equalTo: parentView.trailingAnchor)

        NSLayoutConstraint.activate([top, bottom, left, right])

        return EdgeConstraint(top: top, bottom: bottom, leading: left, traling: right)
    }

    @discardableResult
    func pinSafely(to parentView: UIView) -> EdgeConstraint {
        let top = topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
        let left = leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor)
        let right = trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor)

        NSLayoutConstraint.activate([top, bottom, left, right])

        return EdgeConstraint(top: top, bottom: bottom, leading: left, traling: right)
    }

    func removeAllSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func setBackgorundColor(to color: DesignSystem.Color) {
        self.backgroundColor = color.value
    }

    func setTintColor(to color: DesignSystem.Color) {
        self.tintColor = color.value
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    func blurred(with style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    func underline(with color: DesignSystem.Color = .primaryText(alpha: 0.3), thickness: CGFloat = 1.0) {
        let border = CALayer()
        border.backgroundColor = color.value.cgColor
        border.frame = CGRect(x: 0, y: frame.maxY - thickness, width: frame.width, height: thickness)
        
        layer.addSublayer(border)
    }
}

public extension AppCircularView {
    func setBorderColor(to color: DesignSystem.Color) {
        self.borderColor = color.value
    }

    func setBorderColor(to color: DesignSystem.Color, animationDuration duration: TimeInterval) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = color.value.cgColor
        animation.duration = duration
        layer.add(animation, forKey: nil)
        setBorderColor(to: color)
    }
}

public struct EdgeConstraint {
    public let top: NSLayoutConstraint
    public let bottom: NSLayoutConstraint
    public let leading: NSLayoutConstraint
    public let traling: NSLayoutConstraint
}
