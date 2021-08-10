//
//  SecurityLevelsViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol SecurityLevelsViewModel: BaseViewModel, SecurityLevelsViewModelInput, SecurityLevelsViewModelOutput {
}

public struct SecurityLevelsViewModelParams {
    public let highSecurityType: HighSecurityType

    public enum HighSecurityType {
        case sms
        case email
    }
}

public protocol SecurityLevelsViewModelInput: AnyObject {
    var params: SecurityLevelsViewModelParams { get set }
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath)
    func securityLevelTapped(at index: Int)
    func typeTapped(at index: Int)
    func backTapped()
}

public protocol SecurityLevelsViewModelOutput {
    var action: Observable<SecurityLevelsViewModelOutputAction> { get }
    var route: Observable<SecurityLevelsViewModelRoute> { get }
}

public enum SecurityLevelsViewModelOutputAction {
    case setTitle(title: String)
    case dataProvider(AppListDataProvider)
    case openOkCancelAlert(title: String, completion: (Bool) -> Void)
    case close
}

public enum SecurityLevelsViewModelRoute {
}

public class DefaultSecurityLevelsViewModel: DefaultBaseViewModel {
    public  var params: SecurityLevelsViewModelParams
    private let actionSubject = PublishSubject<SecurityLevelsViewModelOutputAction>()
    private let routeSubject = PublishSubject<SecurityLevelsViewModelRoute>()
    private var state = State() // initial state

    // MARK: Declare initializers
    public init(params: SecurityLevelsViewModelParams) {
        self.params = params
    }
}

// MARK: Declare structs for saving State
extension DefaultSecurityLevelsViewModel {
    struct State {
        var level = SecurityLevel.standart { willSet { types = newValue.initialTypeStates } }
        lazy var types = level.initialTypeStates
    }

    struct TypeState {
        var selected: Bool = false
    }
}

// MARK: Enumerate Security Levels and its Types
extension DefaultSecurityLevelsViewModel {
    enum SecurityLevel: Int, CaseIterable {
        case standart
        case highSecurity
        case individual

        struct Description {
            let title: String
            let types: [`Type`]
        }

        var description: Description {
            switch self {
            case .standart:      return Description(title: R.string.localization.security_levels_standart_packet.localized(), types: `Type`.allCases)
            case .highSecurity:  return Description(title: R.string.localization.security_levels_high_security_parameters.localized(), types: `Type`.allCases)
            case .individual:    return Description(title: R.string.localization.security_levels_individual.localized(), types: `Type`.allCases)
            }
        }

        enum `Type`: Int, CaseIterable {
            case deposit
            case withdraw
            case passwordChange
            case passwordUpdate
            case otherIpLogin
            case contactsChange
            case personalInfoChange
            case accountBlock
            case idDocumentChange
            case highSecurityActivationDeactivation

            struct Description {
                let title: String
            }

            var description: Description {
                switch self {
                case .deposit:                             return Description(title: R.string.localization.security_levels_deposit.localized())
                case .withdraw:                            return Description(title: R.string.localization.security_levels_withdraw.localized())
                case .passwordChange:                      return Description(title: R.string.localization.security_levels_password_change.localized())
                case .passwordUpdate:                      return Description(title: R.string.localization.security_levels_password_update.localized())
                case .otherIpLogin:                        return Description(title: R.string.localization.security_levels_other_ip_login.localized())
                case .contactsChange:                      return Description(title: R.string.localization.security_levels_contacts_change.localized())
                case .personalInfoChange:                  return Description(title: R.string.localization.security_levels_personal_info_change.localized())
                case .accountBlock:                        return Description(title: R.string.localization.security_levels_account_block.localized())
                case .idDocumentChange:                    return Description(title: R.string.localization.security_levels_id_document_change.localized())
                case .highSecurityActivationDeactivation:  return Description(title: R.string.localization.security_levels_high_security_activation_deactivation.localized())
                }
            }
        }
    }
}

extension DefaultSecurityLevelsViewModel.SecurityLevel {
    var initialTypeStates: [DefaultSecurityLevelsViewModel.TypeState] {
        switch self {
        case .standart:
            return description.types.map {
                switch $0 {
                case .deposit,
                     .withdraw,
                     .passwordChange,
                     .otherIpLogin,
                     .contactsChange: // selected ones
                    return .init(selected: true)
                default:
                    return .init(selected: false)
                }
            }

        case .highSecurity:
            return description.types.map {
                switch $0 {
                case .deposit,
                     .withdraw,
                     .passwordChange,
                     .passwordUpdate,
                     .otherIpLogin,
                     .contactsChange,
                     .accountBlock,
                     .idDocumentChange,
                     .highSecurityActivationDeactivation: // selected ones
                    return .init(selected: true)
                default:
                    return .init(selected: false)
                }
            }

        case .individual:
            return description.types.map { _ in
                .init(selected: false)
            }
        }
    }
}

// MARK: Extend ViewModel to SecurityLevelsViewModel
extension DefaultSecurityLevelsViewModel: SecurityLevelsViewModel {
    public var action: Observable<SecurityLevelsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SecurityLevelsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        let title = params.highSecurityType.description.title
        actionSubject.onNext(.setTitle(title: title))
        actionSubject.onNext(.dataProvider(viewModels.makeList()))
    }

    public func didSelectRow(at indexPath: IndexPath) {
        var index = indexPath.row
        if index < SecurityLevel.allCases.count {
            securityLevelTapped(at: index)
        } else {
            index -= SecurityLevel.allCases.count
            typeTapped(at: index)
        }
    }

    public func securityLevelTapped(at index: Int) {
        guard let newSecurityLevel = SecurityLevel(rawValue: index) else { return } // incorrect usage of securityLevelTapped function, wrong security level index

        if state.level != newSecurityLevel {
            // update state
            state.level = newSecurityLevel
            actionSubject.onNext(.dataProvider(viewModels.makeList()))
        }
    }

    public func typeTapped(at index: Int) {
        guard index < state.types.count else { return } // incorrect usage of securityLevelTypeTapped function, wrong security level index
        // update state
        if state.level == .individual {
            state.types[index].selected.toggle()
            actionSubject.onNext(.dataProvider(viewModels.makeList()))
        } else {
            let title = R.string.localization.security_levels_switched_to_individual.localized()
            let completion = { [weak self] (ok: Bool) -> Void in
                guard let self = self else { return }
                if ok {
                    let types = self.state.types
                    self.state.level = .individual
                    self.state.types = types
                    self.state.types[index].selected.toggle()
                    self.actionSubject.onNext(.dataProvider(self.viewModels.makeList()))
                }
            }
            actionSubject.onNext(.openOkCancelAlert(title: title, completion: completion))
        }
    }

    public func backTapped() {
        if state.level == .individual && !state.types.contains(where: { $0.selected }) {
            let title = R.string.localization.security_levels_individual_is_empty.localized()
            let completion = { [weak self] (ok: Bool) -> Void in
                if ok { self?.actionSubject.onNext(.close) }
            }
            actionSubject.onNext(.openOkCancelAlert(title: title, completion: completion))
        } else {
            actionSubject.onNext(.close)
        }
    }
}

// MARK: - Helpers for public methods
extension DefaultSecurityLevelsViewModel {
    //
    private var viewModels: AppCellDataProviders {
        var viewModels = levelViewModels
        viewModels.append(contentsOf: typeViewModels)
        return viewModels
    }
    //
    private var levelViewModels: AppCellDataProviders {
        var levelViewModels: AppCellDataProviders = []

        let levels = SecurityLevel.allCases
        for (index, level) in levels.enumerated() {
            let title = level.description.title                                  // title
            let selected = level == state.level                                  // selected
            let separator = index != levels.count - 1                            // separator
            let corners: SecurityLevelComponentViewModelParams.RoundCorners = {  // corners
                if index == 0 { return .top }
                if index == levels.count - 1 { return .bottom }
                return .none
            }()

            let viewModel = DefaultSecurityLevelComponentViewModel(params: .init(title: title,
                                                                                 selected: selected,
                                                                                 separator: separator,
                                                                                 corners: corners))

            levelViewModels.append(viewModel)
        }

        return levelViewModels
    }
    //
    private var typeViewModels: AppCellDataProviders {
        var typeViewModels: AppCellDataProviders = []

        let types = state.level.description.types
        for (index, type) in types.enumerated() {
            let title = type.description.title         // title
            let selected = state.types[index].selected // selected

            let viewModel = DefaultSecurityLevelTypeComponentViewModel(params: .init(title: title,
                                                                                     selected: selected))

            typeViewModels.append(viewModel)
        }

        return typeViewModels
    }
}

fileprivate extension SecurityLevelsViewModelParams.HighSecurityType {
    struct Description {
        let title: String
    }

    var description: Description {
        switch self {
        case .sms:   return .init(title: R.string.localization.security_levels_sms_scene_title.localized().uppercased())
        case .email: return .init(title: R.string.localization.security_levels_email_scene_title.localized().uppercased())
        }
    }
}
