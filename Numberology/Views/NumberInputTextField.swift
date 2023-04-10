//
//  NumberInputTextField.swift
//  Numberology
//
//  Created by Beavean on 06.04.2023.
//

import SnapKit
import UIKit

final class NumberInputTextField: UITextField {
    // MARK: - Properties

    private let minimumWidth: CGFloat = 150
    private let leftViewFrame = CGRect(x: 0, y: 0, width: Constants.StyleDefaults.innerPadding, height: 0)
    private let multipleInput: Bool
    private let allowedNumbers = "0123456789"
    private let allowedPunctuationSigns = ",."
    private lazy var allowedCharacters = multipleInput ? allowedNumbers + allowedPunctuationSigns : allowedNumbers
    private lazy var allowedCharactersSet = CharacterSet(charactersIn: allowedCharacters)

    // MARK: - Initialization

    init(placeholder: String, multipleInput: Bool = false) {
        self.multipleInput = multipleInput
        super.init(frame: .zero)
        self.placeholder = placeholder
        configureUI()
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func textDidChange() {
        guard let text = text else { return }
        if !multipleInput {
            handleSingleInput(text: text)
        } else {
            handleMultipleInput(text: text)
        }
    }

    // MARK: - Configuration

    private func configureUI() {
        snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(minimumWidth)
        }
        leftView = UIView(frame: leftViewFrame)
        leftViewMode = .always
        clearButtonMode = .always
        placeholder = placeholder
        backgroundColor = .itemBackgroundColor
        addRoundedBorder()
    }

    private func setup() {
        keyboardType = multipleInput ? .decimalPad : .numberPad
        delegate = self
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    // MARK: - Input return

    func getInputtedInts() -> [Int] {
        guard let text else { return [] }
        if !multipleInput {
            if let singleNumber = Int(text) {
                return [singleNumber]
            }
        } else {
            let components = text.split(separator: ",")
            let numbers = components.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            return numbers
        }
        return []
    }

    // MARK: - Helpers

    private func handleSingleInput(text: String) {
        if Int(text) ?? 0 > Constants.APIDefaults.maxNumber {
            self.text = String(text.dropLast())
        } else {
            self.text = text.replacingOccurrences(of: "^0+(?=\\d)", with: "", options: .regularExpression)
        }
    }

    private func handleMultipleInput(text: String) {
        guard !text.isEmpty else { return }
        if text.last == "." {
            self.text = text.dropLast() + ","
        }
        guard text.first != "," else {
            self.text = String(text.dropFirst())
            return
        }
        let components = text.replacingOccurrences(of: " ", with: "")
            .split(separator: ",", omittingEmptySubsequences: false)
        let numbers = components.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        if numbers.contains(where: { $0 > Constants.APIDefaults.maxNumber }) {
            self.text = String(text.dropLast())
        } else {
            let newText = numbers.map { String($0) }.joined(separator: ", ")
            let formattedText = newText + (text.last == "," ? "," : "")
            if formattedText != text {
                self.text = formattedText
            }
        }
    }

    private func checkSingleInput(proposedText: String) -> Bool {
        if let newValue = Int(proposedText), newValue <= Constants.APIDefaults.maxNumber {
            return true
        } else if proposedText.isEmpty {
            return true
        }
        return false
    }

    private func checkMultipleInput(textField: UITextField, replacementString: String) -> Bool {
        if replacementString == "." {
            textField.text = (textField.text ?? "") + ","
            return false
        }
        return true
    }
}

extension NumberInputTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: string)

        if allowedCharactersSet.isSuperset(of: characterSet),
           let currentText = textField.text as NSString? {
            let proposedText = currentText.replacingCharacters(in: range, with: string)

            if !multipleInput {
                return checkSingleInput(proposedText: proposedText)
            } else {
                return checkMultipleInput(textField: textField, replacementString: string)
            }
        }
        return false
    }
}
