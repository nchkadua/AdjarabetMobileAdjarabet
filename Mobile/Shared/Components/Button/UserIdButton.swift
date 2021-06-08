//
//  UserIdButton.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/14/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class UserIdButton: UIButton {
    @Inject private var userSession: UserSessionServices

    public override init(frame: CGRect) {
       super.init(frame: frame)
        setupButton()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        setupButton()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
    }

    private func setupButton() {
        sizeToFit()
        imageView?.contentMode = .scaleAspectFit
        titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 11)
        frame = CGRect(x: 0, y: 0, width: 100, height: 35)
        titleLabel?.textAlignment = .right
        semanticContentAttribute = .forceRightToLeft

        setImage(R.image.components.profileCell.copy(), for: .normal)
        if let userId = userSession.userId {
            setTitle(String(userId), for: .normal)
        }

        addTarget(self, action: #selector(copyUserId), for: .touchUpInside)
    }

    @objc private func copyUserId() {
        UIPasteboard.general.string = titleLabel?.text
    }
}
