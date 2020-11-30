//
//  UILabel+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UILabel {
    func setFont(to typography: DesignSystem.Typography) {
        self.font = typography.description.font
    }

    func setTextColor(to color: DesignSystem.Color) {
        self.textColor = color.value
    }

    func setTextWithAnimation(_ text: String) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.text = text
        }, completion: nil)
    }

    func setTextAndImage(_ text: String, _ image: UIImage, alignment: ImageAlignment, with animation: Bool = false) {
        let animationTime = animation ? 0.15 : 0.0

        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -2, width: attachment.image?.size.width ?? 20, height: attachment.image?.size.height ?? 20)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)

        switch alignment {
        case .right:
            let strLabelText = NSMutableAttributedString(string: text)
            strLabelText.append(NSAttributedString(string: "  "))
            strLabelText.append(attachmentString)

            setAttributedTextWithAnimation(strLabelText, animationTime: animationTime)
        case .left:
            let strLabelText = NSAttributedString(string: text)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(NSAttributedString(string: "  "))
            mutableAttachmentString.append(strLabelText)

            setAttributedTextWithAnimation(strLabelText, animationTime: animationTime)
        }
    }

    func setAttributedTextWithAnimation(_ text: NSAttributedString, animationTime: TimeInterval = 0.2 ) {
        UIView.transition(with: self, duration: animationTime, options: .transitionFlipFromTop, animations: { [weak self] in
            self?.attributedText = text
        }, completion: nil)
    }
}

public enum ImageAlignment {
    case right
    case left
}
