//
//  NotificationsButton.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class NotificationsButton: UIButton {
    private let disposeBag = DisposeBag()

    public var numberOfNotifications: Int? {
        didSet {
            configure(text: String(numberOfNotifications ?? 0))
        }
    }

    public override init(frame: CGRect) {
       super.init(frame: frame)
       sharedInitialize()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       sharedInitialize()
    }

    private func sharedInitialize() {
    }

    private func configure(text: String?) {
        setTitle(text, for: .normal)
        sizeToFit()
        setup()
    }

    private func setup() {
        setBackgroundImage(R.image.notifications.oval(), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        titleEdgeInsets = .init(top: 3, left: 0, bottom: 0, right: 0)
    }
}
