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

    func setTextAndImage(_ text: String, _ image: UIImage, alignment: ImageAlignment) {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -5, width: attachment.image?.size.width ?? 20, height: attachment.image?.size.height ?? 20)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)

        switch alignment {
        case .right:
            let strLabelText = NSMutableAttributedString(string: text)
            strLabelText.append(NSAttributedString(string: "  "))
            strLabelText.append(attachmentString)
            attributedText = strLabelText
        case .left:
            let strLabelText = NSAttributedString(string: text)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(NSAttributedString(string: "  "))
            mutableAttachmentString.append(strLabelText)
            attributedText = mutableAttachmentString
        }
    }
}

public enum ImageAlignment {
    case right
    case left
}
