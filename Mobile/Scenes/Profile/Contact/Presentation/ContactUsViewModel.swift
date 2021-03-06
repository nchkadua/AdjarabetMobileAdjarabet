//
//  ContactUsViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import MapKit

protocol ContactUsViewModel: BaseViewModel, ContactUsViewModelInput, ContactUsViewModelOutput {
}

public struct ContactUsViewModelParams {
    let showDismiss: Bool
}

public protocol ContactUsViewModelInput: AnyObject {
    var params: ContactUsViewModelParams { get set }
    func viewDidLoad()
}

public protocol ContactUsViewModelOutput {
    var action: Observable<ContactUsViewModelOutputAction> { get }
    var route: Observable<ContactUsViewModelRoute> { get }
}

public enum ContactUsViewModelOutputAction {
    case initialize(AppListDataProvider)
    case openUrl(_ url: URL)
    case sendMail(_ mail: String)
    case openMapItem(_ mapItem: MKMapItem, options: [String: Any])
}

public enum ContactUsViewModelRoute {
}

public class DefaultContactUsViewModel: DefaultBaseViewModel {
    public var params: ContactUsViewModelParams
    private let actionSubject = PublishSubject<ContactUsViewModelOutputAction>()
    private let routeSubject = PublishSubject<ContactUsViewModelRoute>()

    public init(params: ContactUsViewModelParams) {
        self.params = params
    }
}

extension DefaultContactUsViewModel: ContactUsViewModel {
    public var action: Observable<ContactUsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ContactUsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        var dataProviders: AppCellDataProviders = []

        //Phone
        let contactPhoneViewModel = DefaultContactPhoneComponentViewModel(params: .init())
        dataProviders.append(contactPhoneViewModel)
        //Mail
        MailListProvider.items().forEach {
            let mailViewModel = DefaultContactMailComponentViewModel(params: .init(title: $0.title, mail: $0.mail))
            mailViewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect(let mail, _): self?.didSelectMail(mail)
                default:
                    break
                }
            }).disposed(by: disposeBag)
            dataProviders.append(mailViewModel)
        }
        //Address
        let headerViewModel = DefaultAddressHeaderComponentViewModel(params: .init(title: R.string.localization.contact_addresses.localized().uppercased()))
        dataProviders.append(headerViewModel)

        AddressListProvider.list().forEach {
            let addressViewModel = DefaultContactAddressComponentViewModel(params: .init(address: $0))
            addressViewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect(let address, _): self?.didSelectAddress(address)
                default:
                    break
                }
            }).disposed(by: disposeBag)
            dataProviders.append(addressViewModel)
        }

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }

    private func didSelectMail(_ mail: String) {
        if UIApplication.shared.canOpenURL(URL(string: "googlegmail://")!) {
            guard let url = URL(string: "googlegmail:///co?to=\(mail)") else {
                actionSubject.onNext(.sendMail(mail))
                return }
            actionSubject.onNext(.openUrl(url))
        } else {
            actionSubject.onNext(.sendMail(mail))
        }
    }

    private func didSelectAddress(_ address: Address) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            guard let url = URL(string: "comgooglemaps://?center=\(address.coordinates.latitude),\(address.coordinates.longitude)&directionsmode=driving&zoom=14&views=traffic") else {
                createAppleMapsOptions(from: address)
                return
            }
            actionSubject.onNext(.openUrl(url))
        } else {
            createAppleMapsOptions(from: address)
        }
    }

    private func createAppleMapsOptions(from address: Address) {
        if UIApplication.shared.canOpenURL(URL(string: "maps://")!) {
            let latitude = address.coordinates.latitude
            let longitude = address.coordinates.longitude
            let regionDistance: CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Adjarabet"

            actionSubject.onNext(.openMapItem(mapItem, options: options))
        } else {
            let message = "No Map Application is installed"
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
        }
    }
}
