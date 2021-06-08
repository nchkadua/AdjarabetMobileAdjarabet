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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var listLayoutButton: UIButton!
    @IBOutlet private weak var gridLayoutButton: UIButton!

    private var chosenLayout: Layout = .list
    private enum Layout {
        case list
        case grid

        var activeImage: UIImage {
            switch self {
            case .list: return R.image.home.listLayoutOn()!
            case .grid: return R.image.home.gridLayoutOn()!
            }
        }

        var inactiveImage: UIImage {
            switch self {
            case .list: return R.image.home.listLayoutOff()!
            case .grid: return R.image.home.gridLayoutOff()!
            }
        }
    }

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
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .headline(fontCase: .upper, fontStyle: .semiBold))
        titleLabel.text = R.string.localization.home_slots.localized().uppercased()
    }

    @IBAction private func listLayoutButtonTapped() {
        if chosenLayout != .list {
            chosenLayout = .list
            listLayoutButton.setImage(Layout.list.activeImage, for: .normal)
            gridLayoutButton.setImage(Layout.grid.inactiveImage, for: .normal)
            viewModel.listLayoutTapped()
        }
    }

    @IBAction private func gridLayoutButtonTapped() {
        if chosenLayout != .grid {
            chosenLayout = .grid
            gridLayoutButton.setImage(Layout.grid.activeImage, for: .normal)
            listLayoutButton.setImage(Layout.list.inactiveImage, for: .normal)
            viewModel.gridLayoutTapped()
        }
    }
}
