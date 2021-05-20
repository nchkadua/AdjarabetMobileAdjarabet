//
//  LayoutChooserView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class LayoutChooserView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!

    var viewModel: LayoutChooserViewModel = DefaultLayoutChooserViewModel.default

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    func setupUI() {
        view.backgroundColor = .purple
    }
}
