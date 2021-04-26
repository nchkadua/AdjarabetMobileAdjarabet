//
//  HomeHeaderView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class HomeHeaderView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    func setupUI() {
        view.backgroundColor = .red
    }
}
