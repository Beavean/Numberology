//
//  NumberInRangeView.swift
//  Numberology
//
//  Created by Beavean on 06.04.2023.
//

import SnapKit
import UIKit

final class NumberInRangeView: UIView {
    // MARK: - UI Elements

    private lazy var startRangeTextField = NumberInputTextField(placeholder: "Range start")
    private let separatorLabel: DefaultStyleLabel = {
        let label = DefaultStyleLabel(text: "...", fontSize: 16, isBold: true)
        label.textAlignment = .center
        return label
    }()

    private let endRangeTextField = NumberInputTextField(placeholder: "Range end")

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
        let leftSpacer = Spacer()
        let rightSpacer = Spacer()
        let stack = UIStackView(arrangedSubviews: [leftSpacer,
                                                   startRangeTextField,
                                                   separatorLabel,
                                                   endRangeTextField,
                                                   rightSpacer])
        stack.axis = .horizontal
        stack.distribution = .fill
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        separatorLabel.snp.makeConstraints {
            $0.width.equalTo(rightSpacer)
        }
        leftSpacer.snp.makeConstraints {
            $0.width.equalTo(rightSpacer)
        }
    }

    // MARK: - Helpers

    private func swapTextFieldsIfNeeded() {
        guard let text1 = startRangeTextField.text,
              let text2 = endRangeTextField.text,
              let number1 = Int(text1),
              let number2 = Int(text2),
              number1 > number2
        else { return }
        startRangeTextField.text = text2
        endRangeTextField.text = text1
    }
}

extension NumberInRangeView: NumberInputContainer {
    var numbers: [Int] {
        swapTextFieldsIfNeeded()
        return startRangeTextField.inputNumbers + endRangeTextField.inputNumbers
    }
}
