//
//  ProfileFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/2/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol ProfileFactory {
    func make() -> ProfileViewController
}

public class DefaultProfileFactory: ProfileFactory {
    public func make() -> ProfileViewController {
        let vc = R.storyboard.profile().instantiate(controller: ProfileViewController.self)!
        vc.modalPresentationStyle = .fullScreen

        return vc
    }
}
