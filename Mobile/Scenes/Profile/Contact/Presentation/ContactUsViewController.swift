//
//  ContactUsViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import MessageUI
import MapKit

public class ContactUsViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: ContactUsViewModel
    public lazy var navigator = ContactUsNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: ContactUsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: ContactUsViewModelOutputAction) {
        switch action {
        case .initialize(let dataProvider): appTableViewController.dataProvider = dataProvider
        case .openUrl(let url): openUrl(url)
        case .sendMail(let mail): sendMail(mail)
        case .openMapItem(let mapItem, let options): openMapItem(mapItem, with: options)
        case .showMessage(let message): showAlert(title: message)
        }
    }

    private func didRecive(route: ContactUsViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.contact_use_title.localized())
        setBackDismissBarButtonItemIfNeeded(completion: #selector(backButtonClick))
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.setBaseBackgroundColor(to: .secondaryBg())

        appTableViewController.tableView?.register(types: [
            ContactPhoneTableViewCell.self,
            ContactMailTableViewCell.self,
            AddressHeaderTableViewCell.self,
            ContactAddressTableViewCell.self
        ])
    }

    // MARK: Action methods
    @objc private func backButtonClick() {
        if viewModel.params.showDismiss {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func openUrl(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    //Apple Maps
    private func openMapItem(_ mapItem: MKMapItem, with options: [String: Any]) {
        mapItem.openInMaps(launchOptions: options)
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    private func sendMail(_ mail: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([mail])

            present(mailVC, animated: true)
        } else {
            showAlert(title: "Can not send email")
        }
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
