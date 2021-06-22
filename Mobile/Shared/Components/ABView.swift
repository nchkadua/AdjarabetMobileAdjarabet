//
//  ABView.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public enum ComponentStyle {
    case primary
    case secondary
}

public class ABView: UIView {
    public var changesBackgroundColorOnClick = true
    public var componentStyle: ComponentStyle = .secondary

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        setToNormal()
    }

    private func viewStyle(by componentStyle: ComponentStyle) -> [DesignSystem.View.Style] {
        switch componentStyle {
        case .primary: return [.primaryNormal, .primaryPressed]
        case .secondary: return [.secondaryNormal, .secondaryPressed]
        }
    }

    private func setToNormal() {
        if !changesBackgroundColorOnClick { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in // Background color change to be visible
            self.setStyle(to: viewStyle(by: componentStyle).first ?? .primaryNormal)
        })
    }
}

public extension ABView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !changesBackgroundColorOnClick { return }

        setStyle(to: viewStyle(by: componentStyle)[1])
        super.touchesBegan(touches, with: event)

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setToNormal()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !changesBackgroundColorOnClick { return }

        setStyle(to: viewStyle(by: componentStyle).first ?? .primaryNormal)
        super.touchesMoved(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !changesBackgroundColorOnClick { return }

        setStyle(to: viewStyle(by: componentStyle).first ?? .primaryNormal)
        super.touchesCancelled(touches, with: event)
    }
}
