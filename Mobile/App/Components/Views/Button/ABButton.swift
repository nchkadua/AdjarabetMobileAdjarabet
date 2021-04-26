//
//  ABButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ABButton: LoadingButton {
    /// Default style
    private var primaryStyle: DesignSystem.Button.Style?

    public convenience init(style: DesignSystem.Button.Style) {
        self.init(frame: .zero)
        self.primaryStyle = style
        setStyle(to: style)
    }

    public func setStyle(to style: DesignSystem.Button.Style) {
        self.primaryStyle = style
        super.setStyle(to: style)
        addStylesForActions()
        titleEdgeInsets = .init(top: -4, left: 0, bottom: 0, right: 0)
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        activityIndicator.color = color
    }

    public func setImage(_ image: UIImage, tintColor: DesignSystem.Color) {
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        setTintColor(to: tintColor)
        imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 5)
        contentEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
    }

    // MARK: Private methods
    private func addStylesForActions() {
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)
    }

    @objc private func handleTouchDown() {
        setStyle(to: .primary(state: .pressed, size: .large))
    }

    @objc private func handleTouchUp() {
        setStyle(to: .primary(state: .active, size: .large))
    }
}
