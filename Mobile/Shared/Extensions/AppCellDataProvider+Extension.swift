//
//  AppCellDataProvider+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension Array where Element == AppCellDataProvider {
    func makeSection() -> AppSectionDataProvider {
        AppSectionDataProvider(dataProviders: self)
    }

    func makeList() -> AppListDataProvider {
        AppListDataProvider(sectionDataProvider: self.makeSection())
    }
}

public extension AppCellDataProvider {
    func makeSection() -> AppSectionDataProvider {
        AppSectionDataProvider(dataProviders: [self])
    }
}

public extension AppSectionDataProvider {
    func makeList() -> AppListDataProvider {
        AppListDataProvider(sectionDataProvider: self)
    }
}

public extension Array where Element == AppSectionDataProvider {
    func makeList() -> AppListDataProvider {
        AppListDataProvider(sectionDataProviders: self)
    }
}

public extension AppListDataProvider {
    convenience init(sectionDataProvider: AppSectionDataProvider) {
        self.init(sectionDataProviders: [sectionDataProvider])
    }
}
