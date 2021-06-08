//
//  ABDatePickerView.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

class ABDatePickerView: UIPickerView {
    private var holderView: ABInputView?
    private var lastChosenMonth = ""
    private var lastChosenYear = ""

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(holder: ABInputView) {
        super.init(frame: CGRect.zero)
        delegate = self
        dataSource = self

        holderView = holder
        holder.mainTextField.delegate = self
        selectDefaultDates()
    }

    private func selectDefaultDates() {
        let currentMonthIndex = Calendar.current.component(.month, from: Date())
        selectRow(currentMonthIndex-1, inComponent: 0, animated: false)
        lastChosenMonth = Helper.months()[currentMonthIndex-1]

        selectRow(0, inComponent: 1, animated: false)
        lastChosenYear = Helper.years()[0]
    }
}

extension ABDatePickerView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        holderView?.set(text: "\(lastChosenMonth)\("/")\(lastChosenYear.suffix(2))")
    }
}

extension ABDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return Helper.months().count
        case 1: return Helper.years().count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return Helper.months()[row]
        case 1: return Helper.years()[row]
        default:
            return ""
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var month = lastChosenMonth
        var year = lastChosenYear

        switch component {
        case 0:
            month = Helper.months()[row]
            lastChosenMonth = month
        case 1:
            year = Helper.years()[row]
            lastChosenYear = year
        default:
            break
        }

        holderView?.set(text: "\(month)\("/")\(year.suffix(2))")
    }
}
