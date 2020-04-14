//
//  UIView+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public extension UIView {
    @discardableResult
    func placeEdgeToEdge(in parentView: UIView) -> EdgeConstraint {
        let top = topAnchor.constraint(equalTo: parentView.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        let left = leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        let right = trailingAnchor.constraint(equalTo: parentView.trailingAnchor)

        NSLayoutConstraint.activate([top, bottom, left, right])

        return EdgeConstraint(top: top, bottom: bottom, leading: left, traling: right)
    }

    @discardableResult
    func pinSafely(in parentView: UIView) -> EdgeConstraint {
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
}

public struct EdgeConstraint {
    public let top: NSLayoutConstraint
    public let bottom: NSLayoutConstraint
    public let leading: NSLayoutConstraint
    public let traling: NSLayoutConstraint
}
