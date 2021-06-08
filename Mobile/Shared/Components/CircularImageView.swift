//
//  CircularImageView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@IBDesignable
public class CircularImageView: UIImageView, CircularView {
    @IBInspectable open var hasSquareBorderRadius: Bool = false {
        didSet {
            update()
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            update()
        }
    }

    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            update()
        }
    }

    @IBInspectable open var borderColor: UIColor = .clear {
        didSet {
            update()
        }
    }

    public var normalizedCornerRadius: CGFloat {
        return hasSquareBorderRadius ? bounds.height / 2 : cornerRadius
    }

    public lazy var borderLayer: CAShapeLayer = {
        let borderLayer = CAShapeLayer()
        self.layer.addSublayer(borderLayer)
        return borderLayer
    }()

    public lazy var maskLayer: CAShapeLayer = {
        let mask = makeMaskLayer(path: makeMaskLayerPath())
        self.layer.mask = mask
        return mask
    }()

    open func update() {
        setupCornerRadius()
        clipsToBounds = true
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
}
