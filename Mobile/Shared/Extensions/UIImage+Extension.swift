//
//  UIImage+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public extension UIImage {
    func resizeImage(newHeight: CGFloat) -> UIImage? {
        let newScale = newHeight / size.height
        let newWidth = size.width * newScale
        let newSize = CGSize(width: newWidth, height: newHeight)

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
