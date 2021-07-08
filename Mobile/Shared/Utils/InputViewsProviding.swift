//
//  InputViewsProviding.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/20/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol InputViewsProviding: AnyObject {
    var disposeBag: DisposeBag { get }
    var inputViews: [ABInputView] { get }
    func nextTextField(for textField: UITextField) -> UITextField?
}

public extension InputViewsProviding where Self: UIViewController {
    var inputViewTextFilds: [UITextField] { inputViews.map { $0.mainTextField } }

    func nextTextField(for textField: UITextField) -> UITextField? {
        let textFields = inputViewTextFilds
        guard let index = textFields.firstIndex(of: textField), index != textFields.count - 1 else {return nil}
        return textFields[index + 1]
    }

    /// Start observing textfield's editingDidEndOnExit
    /// - Parameter block: block will be called after the final textField returns
    func startObservingInputViewsReturn(block: @escaping () -> Void) {
        inputViewTextFilds.forEach { (textField: UITextField) in
            textField.rx.controlEvent([.editingDidEndOnExit]).subscribe { [weak self, weak textField] _ in
                guard let self = self, let textField = textField else {return}

                if let next = self.nextTextField(for: textField) {
                    next.becomeFirstResponder()
                } else {
                    block()
                }
            }.disposed(by: disposeBag)
        }
    }
}
