//
//  AccessHistoryViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import UAParserSwift

public protocol AccessHistoryViewModel: AccessHistoryViewModelInput, AccessHistoryViewModelOutput {
}

public struct AccessHistoryViewModelParams {
}

public protocol AccessHistoryViewModelInput: AnyObject {
    var params: AccessHistoryViewModelParams { get set }
    func calendarTabItemClicked()
    func viewDidLoad()
}

public protocol AccessHistoryViewModelOutput {
    var action: Observable<AccessHistoryViewModelOutputAction> { get }
    var route: Observable<AccessHistoryViewModelRoute> { get }
}

public enum AccessHistoryViewModelOutputAction {
    case initialize(AppListDataProvider)
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
}

public enum AccessHistoryViewModelRoute {
    case openAccessHistoryCalendar(params: AccessHistoryCalendarViewModelParams)
}

public class DefaultAccessHistoryViewModel: DefaultBaseViewModel {
    public var params: AccessHistoryViewModelParams
    private let actionSubject = PublishSubject<AccessHistoryViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccessHistoryViewModelRoute>()
    private var accessHistoryDataProvider: AppCellDataProviders = []
    private let dateFormatter = ABDateFormater(with: .day)
    private var filteredParams: DisplayAccessListUseCaseParams?
    @Inject(from: .useCases) private var displayAccessListUseCase: DisplayAccessListUseCase

    private let dayDateFormatter = ABDateFormater(with: .day)
    private let hourDateFormatter = ABDateFormater(with: .dateTime)

    enum DeviceType {
        case mobile
        case desktop
    }

    public init(params: AccessHistoryViewModelParams) {
        self.params = params
    }
}

extension DefaultAccessHistoryViewModel: AccessHistoryViewModel {
    public var action: Observable<AccessHistoryViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccessHistoryViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        displayUnfilteredAccessHistory()
    }

    public func calendarTabItemClicked() {
        var params = AccessHistoryCalendarViewModelParams()
        if let filteredParams = filteredParams {
            params.fromDate = dayDateFormatter.date(from: filteredParams.fromDate)
            params.toDate = dayDateFormatter.date(from: filteredParams.toDate)
        }
        subscribeToFilterViewModelParams(params)
        routeSubject.onNext(.openAccessHistoryCalendar(params: params))
    }

    private func subscribeToFilterViewModelParams(_ params: AccessHistoryCalendarViewModelParams) {
        params.paramsOutputAction.subscribe(onNext: {[weak self] action in
            guard let self = self else { return }
            switch action {
            case .filterSelected(let fromDate, let toDate):
                self.constructFilteredParams(fromDate: fromDate,
                                             toDate: toDate)
                self.displayFilteredAccessHistory(params: self.filteredParams!)
            }
        })
        .disposed(by: disposeBag)
    }

    private func constructFilteredParams(fromDate: Date?, toDate: Date?) {
        let fromDate = dayDateFormatter.string(from: fromDate ?? Date.distantPast)
        let toDate = dayDateFormatter.string(from: toDate ?? Date.distantFuture)
        let params: DisplayAccessListUseCaseParams = .init(fromDate: fromDate,
                                                           toDate: toDate)
        self.filteredParams = params
    }

    // MARK: Display Access History

    private func displayEmptyList() {
        let initialEmptyDataProvider: AppCellDataProviders = []
        self.actionSubject.onNext(.initialize(initialEmptyDataProvider.makeList()))
    }

    private func displayFilteredAccessHistory(params: DisplayAccessListUseCaseParams) {
        displayAccessHistory(params: params)
    }

    private func displayUnfilteredAccessHistory() {
        let fromDate = dateFormatter.string(from: Date.distantPast)
        let toDate = dateFormatter.string(from: Date.distantFuture)
        let params: DisplayAccessListUseCaseParams = .init(fromDate: fromDate,
                                                           toDate: toDate)
        displayAccessHistory(params: params)
    }

    private func displayAccessHistory(params: DisplayAccessListUseCaseParams) {
        self.displayEmptyList()
        displayAccessListUseCase.execute(params: params) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let accessList):
                var datesSet: Set<String>  = []
                self.accessHistoryDataProvider = []
                for (index, access) in accessList.enumerated() {
                    let componentViewModel = self.constructComponentViewModel(from: access)
                    let dayString = self.dayDateFormatter.string(from: access.date)
                    if !datesSet.contains(dayString) {
                        datesSet.insert(dayString)
                        let headerViewModel = self.constructHeaderComponentViewModel(from: access, index: index)
                        self.accessHistoryDataProvider.append(headerViewModel)
                    }
                    self.accessHistoryDataProvider.append(componentViewModel)
                }
                self.actionSubject.onNext(.initialize(self.accessHistoryDataProvider.makeList()))
            case .failure(let error):
                self.displayEmptyList()
                print(error)
            }
        }
    }

    private func constructComponentViewModel(from entity: AccessListEntity) -> DefaultAccessHistoryComponentViewModel {
        let deviceType = getDeviceTypeFrom(userAgent: entity.userAgent)
        let deviceName = getDeviceNameFor(deviceType: deviceType)
        let deviceIcon = getDeviceIconFor(deviceType: deviceType)
        return .init(params: .init(ip: entity.ip, device: deviceName,
                                   date: hourDateFormatter.string(from: entity.date),
                                   deviceIcon: deviceIcon))
    }

    // Move somewhere to utils. change strings to enums
    private func getDeviceTypeFrom(userAgent: String) -> DeviceType {
        let parser = UAParser(agent: userAgent)
        guard let userOS = parser.os?.name else { return .desktop }

        if userOS.range(of: "windows", options: .caseInsensitive) != nil {
            return .desktop
        }
        if userOS.range(of: "mac", options: .caseInsensitive) != nil {
            return .desktop
        }

        if userOS.range(of: "ios", options: .caseInsensitive) != nil {
            return .mobile
        }

        if userOS.range(of: "android", options: .caseInsensitive) != nil {
            return .mobile
        }
        return .desktop
    }

    private func getDeviceNameFor(deviceType: DeviceType) -> String {
        switch deviceType {
        case .desktop:
            return R.string.localization.access_history_device_desktop()
        case .mobile:
            return R.string.localization.access_history_device_mobile()
        }
    }

    private func getDeviceIconFor(deviceType: DeviceType) -> UIImage {
        switch deviceType {
        case .desktop:
            return R.image.accessHistory.deviceDesktop()!
        default:
            return R.image.accessHistory.deviceMobile()!
        }
    }

    private func constructHeaderComponentViewModel(from entity: AccessListEntity, index: Int) -> DefaultDateHeaderComponentViewModel {
        let stringDate = dayDateFormatter.string(from: entity.date)

        let shouldShowSeparator = index > 0
        return DefaultDateHeaderComponentViewModel(params: .init(title: stringDate, showSeparator: shouldShowSeparator))
    }
}
