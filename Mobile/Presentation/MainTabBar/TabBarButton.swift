//
//  TabBarButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

/// Button used by floating tab bar
public class TabBarButton: UIButton {
    public var index: Int = 0

    public init(index: Int) {
        self.index = index
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
