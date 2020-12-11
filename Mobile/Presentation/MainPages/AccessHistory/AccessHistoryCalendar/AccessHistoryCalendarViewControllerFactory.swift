//
//  AccessHistoryCalendarViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/10/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol AccessHistoryCalendarViewControllerFactory {
    func make(params: AccessHistoryCalendarViewModelParams) -> AccessHistoryCalendarViewController
}

public class DefaultAccessHistoryCalendarViewControllerFactory: AccessHistoryCalendarViewControllerFactory {
    public func make(params: AccessHistoryCalendarViewModelParams) -> AccessHistoryCalendarViewController {
        let vc = R.storyboard.accessHistoryCalendar().instantiate(controller: AccessHistoryCalendarViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
