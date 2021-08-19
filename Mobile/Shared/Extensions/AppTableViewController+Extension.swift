//
//  AppTableViewController+Extension.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 19.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

extension AppTableViewController {
    public func setupEmptyState(with model: EmptyPageComponentViewModelParams) {
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = super.tableView(tableView, numberOfRowsInSection: section)
        print("***** numberOfROwsInSection: \(numberOfRowsInSection)")
        return numberOfRowsInSection
    }

}
