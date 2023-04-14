//
//  MultipleNumbersView.swift
//  Numberology
//
//  Created by Beavean on 06.04.2023.
//

import SnapKit
import UIKit

final class MultipleNumbersView: UIView {
    // MARK: - UI Elements

    private let numbersInputTextField = NumberInputTextField(placeholder: "For example: 1, 99, 1337",
                                                             multipleInput: true)

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureUI() {
        addSubview(numbersInputTextField)
        numbersInputTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.StyleDefaults.itemHeight)
            $0.left.right.top.equalToSuperview()
        }
        numbersInputTextField.accessibilityIdentifier = "numbersInputTextField"
    }

    // MARK: - Helpers

    private func swapNumbersAndRemoveDuplicates() {
        let numberStrings = numbersInputTextField.text?.split(separator: ",")
        let numbers = numberStrings?.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        var uniqueNumbers: [Int] = []
        if let unwrappedNumbers = numbers {
            for number in unwrappedNumbers where !uniqueNumbers.contains(number) {
                uniqueNumbers.append(number)
            }
        }
        let sortedNumbers = uniqueNumbers.sorted()
        numbersInputTextField.text = sortedNumbers.map(String.init).joined(separator: ", ")
    }
}

extension MultipleNumbersView: NumberInputContainer {
    var numbers: [Int] {
        swapNumbersAndRemoveDuplicates()
        return numbersInputTextField.inputNumbers
    }
}
