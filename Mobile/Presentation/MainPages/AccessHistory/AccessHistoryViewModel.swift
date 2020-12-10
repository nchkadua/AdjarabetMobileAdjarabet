//
//  AccessHistoryViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import UAParserSwift

public protocol AccessHistoryViewModel: AccessHistoryViewModelInput, AccessHistoryViewModelOutput, ABTableViewControllerDelegate {
}

public struct AccessHistoryViewModelParams {
}

public protocol AccessHistoryViewModelInput: AnyObject {
    var params: AccessHistoryViewModelParams { get set }
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
}

public class DefaultAccessHistoryViewModel {
    public var params: AccessHistoryViewModelParams
    private let actionSubject = PublishSubject<AccessHistoryViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccessHistoryViewModelRoute>()
    private var page: PageDescription = .init()
    private var accessHistoryDataProvider: AppCellDataProviders = []
    private let dateFormatter = DateFormatter()
    @Inject(from: .useCases) private var displayAccessListUseCase: DisplayAccessListUseCase

    public init(params: AccessHistoryViewModelParams) {
        self.params = params
    }
}

extension DefaultAccessHistoryViewModel: AccessHistoryViewModel {
    public var action: Observable<AccessHistoryViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccessHistoryViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        displayEmptyList()
        displayAccessHistory()
    }

    // MARK: Display Access History

    private func displayEmptyList() {
        //        self.resetPaging()
        let initialEmptyDataProvider: AppCellDataProviders = []
        self.actionSubject.onNext(.initialize(initialEmptyDataProvider.makeList()))
    }

    private func displayAccessHistory() {
        let fromDate = dateFormatter.verboseDateString(from: Date.distantPast)
        let toDate = dateFormatter.verboseDateString(from: Date.distantFuture)
        let params: DisplayAccessListUseCaseParams = .init(fromDate: fromDate,
                                                           toDate: toDate)
        displayAccessListUseCase.execute(params: params) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let accessList):
                var datesSet: Set<String>  = []
                accessList.forEach { access in
                    let componentViewModel = self.constructComponentViewModel(from: access)
                    let dayString = self.dateFormatter.dayDateString(from: access.date)
                    if !datesSet.contains(dayString) {
                        datesSet.insert(dayString)
                        let headerViewModel = self.constructHeaderComponentViewModel(from: access)
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

    // MARK: Paging

    //    private func appendPage(history: AppCellDataProviders) {
    //        let offset = self.accessHistoryDataProvider.count
    //        self.page.setNextPage()
    //        self.page.configureHasMore(forNumberOfItems: history.count)
    //
    //        self.accessHistoryDataProvider.append(contentsOf: history)
    //
    //        let indexPathes = history.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
    //        actionSubject.onNext(.reloadItems(items: history, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    //    }
    //
    //    private func resetPaging() {
    //        self.accessHistoryDataProvider = []
    //        page.reset()
    //        page.itemsPerPage = 10
    //        page.current = 0
    //    }

    // MARK: ABTableViewControllerDelegate

    private func constructComponentViewModel(from entity: AccessListEntity) -> DefaultAccessHistoryComponentViewModel {
        let deviceType = getDeviceTypeFrom(userAgent: entity.userAgent)
        let deviceName = getDeviceNameFor(deviceType: deviceType)
        let deviceIcon = getDeviceIconFor(deviceType: deviceType)
        return .init(params: .init(ip: entity.ip, device: deviceName,
                                   date: dateFormatter.dayDateString(from: entity.date),
                                   deviceIcon: deviceIcon))
    }

    private func getDeviceTypeFrom(userAgent: String) -> DeviceType {
        let parser = UAParser(agent: userAgent)

        guard let userOS = parser.os?.name else { return .desktop }
        if userOS.contains("android") || userOS.contains("ios") {
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

    private func constructHeaderComponentViewModel(from entity: AccessListEntity) -> DefaultDateHeaderComponentViewModel {
        let stringDate = dateFormatter.dayDateString(from: entity.date)
        let headerModel = DefaultDateHeaderComponentViewModel(params: .init(title: stringDate))
        return headerModel
    }

    public func didDeleteCell(at indexPath: IndexPath) {
    }

    public func didLoadNextPage() {
    }

    public enum DeviceType {
        case mobile
        case desktop
    }
}
