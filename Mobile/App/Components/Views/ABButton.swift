//
//  ABButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@IBDesignable
public class ABButton: AppShadowButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }

    private func sharedInitialization() {
    }
}
