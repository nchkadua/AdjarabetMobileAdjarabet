//
//  ABToggle.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class ABCheckbox: UIButton {
    var viewModel: ABCheckboxModel = ABRedCheckboxModel() {
        willSet {
            setImage(newValue.checkedImage, for: .selected)
        }
    }
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

protocol ABCheckboxModel {
    var checkedImage: UIImage { get }
    var uncheckedImage: UIImage { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
}

struct ABRedCheckboxModel: ABCheckboxModel {
    var checkedImage = R.image.components.abCheckbox.checked()!.withRenderingMode(.alwaysOriginal)
    var uncheckedImage = R.image.components.abCheckbox.unchecked()!.withRenderingMode(.alwaysOriginal)
    let width: CGFloat = 28
    let height: CGFloat = 28
}

struct ABCheckmarkCheckboxModel: ABCheckboxModel {
    var checkedImage = R.image.components.abCheckbox.checkmark()!.withRenderingMode(.alwaysOriginal)
    var uncheckedImage = R.image.components.abCheckbox.unchecked()!.withRenderingMode(.alwaysOriginal)
    let width: CGFloat = 28
    let height: CGFloat = 28
}
