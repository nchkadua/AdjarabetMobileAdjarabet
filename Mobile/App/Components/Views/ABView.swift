//
//  ABView.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class ABView: UIView {
    public var changesBackgroundColorOnClick = true

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if !changesBackgroundColorOnClick { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { // Background color change to be visible
            self.setStyle(to: .normal)
        })
    }
}

public extension ABView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !changesBackgroundColorOnClick { return }

        setStyle(to: .pressed)
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !changesBackgroundColorOnClick { return }

        setStyle(to: .normal)
        super.touchesMoved(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !changesBackgroundColorOnClick { return }

        setStyle(to: .normal)
        super.touchesCancelled(touches, with: event)
    }
}
