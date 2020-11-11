//
//  UINavigationBar+Extension.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UINavigationBar {
    func styleForPrimaryPage() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        barTintColor = DesignSystem.Color.thick().value
        blurred()
    }

    func styleForSecondaryPage() {
        isTranslucent = false
        barTintColor = DesignSystem.Color.baseBg300().value
    }

    func blurred() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
}
