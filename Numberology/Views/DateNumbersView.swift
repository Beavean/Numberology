//
//  DateNumbersView.swift
//  Numberology
//
//  Created by Beavean on 09.04.2023.
//

import SnapKit
import UIKit

final class DateNumbersView: UIView {
    // MARK: - UI Elements

    private let datePicker = UIPickerView()

    // MARK: - Properties

    private let months = Month.allCases.map { $0.name }
    private let days = Array(1...31)

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        configureUI()
        setupDatePicker()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureUI() {
        snp.makeConstraints {
            $0.height.equalTo(Constants.StyleDefaults.itemHeight)
        }
        addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupDatePicker() {
        datePicker.delegate = self
        datePicker.dataSource = self
    }
}

// MARK: - NumberInputContainer

extension DateNumbersView: NumberInputContainer {
    func getNumbers() -> [Int] {
        let selectedMonth = Month.allCases.map { $0.rawValue }[datePicker.selectedRow(inComponent: 0)]
        let selectedDay = days[datePicker.selectedRow(inComponent: 1)]
        return [selectedMonth, selectedDay]
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension DateNumbersView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return days.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(months[row])
        case 1:
            return String(days[row])
        default:
            return nil
        }
    }
}
