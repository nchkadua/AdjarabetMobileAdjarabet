//
//  ABToggle.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

class ABCheckbox: UIButton {
    private var viewModel = ABCheckboxModel()
    public init() {
        super.init(frame: CGRect.zero)
        setupView()
        setupActions()
    }
    convenience init(checked: Bool) {
        self.init()
        isSelected = checked
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: viewModel.width),
            heightAnchor.constraint(equalToConstant: viewModel.height)
        ])
        setImage(viewModel.checkedImage, for: .selected)
        setImage(viewModel.uncheckedImage, for: .normal)
        tintColor = UIColor.clear
    }

    private func setupActions() {
        addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
    }

    @objc func toggleButton() {
      isSelected.toggle()
    }
}

private struct ABCheckboxModel {
    lazy var checkedImage = R.image.components.abCheckbox.checked()!.withRenderingMode(.alwaysOriginal)
    lazy var uncheckedImage = R.image.components.abCheckbox.unchecked()!.withRenderingMode(.alwaysOriginal)
    let width: CGFloat = 28
    let height: CGFloat = 28
}
