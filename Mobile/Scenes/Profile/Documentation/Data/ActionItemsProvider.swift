//
//  ActionsItemProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

class ActionItemsProvider {
    public static func items() -> [Action] {
        [
            Action(title: R.string.localization.terms_and_conditions.localized(), destination: .termsAndConditions),
            Action(title: R.string.localization.confidential.localized(), destination: .confidential)
        ]
    }
}

public struct Action {
    public var title: String
    public var destination: DocumentationNavigator.Destination
}
