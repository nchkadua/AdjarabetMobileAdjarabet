//
//  ABButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@IBDesignable
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
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        activityIndicator.color = color
    }
}
