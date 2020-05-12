//
//  ABButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@IBDesignable
public class ABButton: AppShadowButton {
    /// Default style
    private var primaryStyle: DesignSystem.Button.Style?
    /// Style when button is isHighlighted
    private var hoveredStyle: DesignSystem.Button.Style? {
        buttonType == .custom ? primaryStyle?.makeHovered() : primaryStyle
    }

    public override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            super.isHighlighted = newValue
            configure(animated: true)
        }
    }

    public convenience init(style: DesignSystem.Button.Style) {
        self.init(frame: .zero)
        self.primaryStyle = style
        sharedInitialization()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }

    private func sharedInitialization() {
        configure()
    }

    public func setStyle(to style: DesignSystem.Button.Style) {
        self.setStyle(to: style, animated: false)
    }

    public func setStyle(to style: DesignSystem.Button.Style, animated animate: Bool) {
        self.primaryStyle = style
        configure(animated: animate)
    }

    private func configure(animated animate: Bool = false) {
        guard let style = isHighlighted ? hoveredStyle : primaryStyle else {return}

        UIView.animate(withDuration: animate ? 0.15 : 0) {
            super.setStyle(to: style)
        }
    }
}
