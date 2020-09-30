//
//  LegalTextView.swift
//  Mobile
//
//  Created by Nika Chkadua on 9/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class LegalTextView: UITextView {
    public func applyImageView(_ imageView: UIImageView) {
        let imgText = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageView.frame.width + 10, height: imageView.frame.height + 2.5))
        self.textContainer.exclusionPaths = [imgText]
    }
}
