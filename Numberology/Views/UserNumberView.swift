//
//  UserNumberView.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import SnapKit
import UIKit

final class UserNumberView: UIView {
    // MARK: - UI Elements

    private lazy var userNumberTextField = NumberInputTextField(placeholder: textFieldPlaceholder)

    // MARK: - Properties

    private let textFieldPlaceholder: String = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.locale = Locale.current
        if let formattedMaxNumber = numberFormatter.string(from: NSNumber(value: Constants.APIDefaults.maxNumber)) {
            return "Input any number up to \(formattedMaxNumber)"
        }
        return "Input any number"
    }()

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
        addSubview(userNumberTextField)
        userNumberTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.StyleDefaults.itemHeight)
            $0.left.right.top.equalToSuperview()
        }
    }
}

extension UserNumberView: NumberInputContainer {
    var numbers: [Int] {
        userNumberTextField.inputNumbers

    }
}
