//
//  BalanceProfileButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class BalanceProfileButton: UIButton {
    @Inject public var userBalanceService: UserBalanceService
    private let disposeBag = DisposeBag()

    private var balance: Double? {
        didSet {
            configure(text: balance?.formattedBalanceWithCurrencySign)
        }
    }

    public override init(frame: CGRect) {
       super.init(frame: frame)
       sharedInitialize()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       sharedInitialize()
    }

    private func sharedInitialize() {
        userBalanceService.balanceObservable.subscribe(onNext: { [weak self] balance in
            self?.balance = balance
        })
        .disposed(by: disposeBag)

        self.balance = userBalanceService.balance
    }

    public override func setNeedsLayout() {
        super.setNeedsLayout()
        self.balance = userBalanceService.balance
    }

    private func configure(text: String?) {
        setTitle(text, for: .normal)
        sizeToFit()
    }
}
