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
//    private var hoveredStyle: DesignSystem.Button.Style? {
//        buttonType == .custom ? primaryStyle?.makeHovered() : primaryStyle
//    }
//    public override var isHighlighted: Bool {
//        get { return super.isHighlighted }
//        set {
//            super.isHighlighted = newValue
//            configure(animated: true)
//        }
//    }

    public convenience init(style: DesignSystem.Button.Style) {
        self.init(frame: .zero)
        self.primaryStyle = style
        setStyle(to: style)
    }

    public func setStyle(to style: DesignSystem.Button.Style) {
        self.primaryStyle = style
        super.setStyle(to: style)
    }
}
