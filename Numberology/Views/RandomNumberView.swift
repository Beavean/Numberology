//
//  RandomNumberView.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import SnapKit
import UIKit

final class RandomNumberView: UIView {
    // MARK: - UI Elements

    private let randomNumberLabel = CustomLabel(text: """
                                                Tap on Display Fact button
                                                to get a number with random available fact
                                                """,
                                                fontSize: 16,
                                                isBold: true,
                                                textAlignment: .center)

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
        addSubview(randomNumberLabel)
        randomNumberLabel.snp.makeConstraints {
            $0.height.equalTo(Constants.StyleDefaults.itemHeight)
            $0.left.right.top.equalToSuperview()
        }
    }
}

extension RandomNumberView: NumberInputContainer {
    func getNumbers() -> [Int] {
        [0]
    }
}
