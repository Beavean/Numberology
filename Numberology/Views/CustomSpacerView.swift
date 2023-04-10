//
//  CustomSpacerView.swift
//  Numberology
//
//  Created by Beavean on 08.04.2023.
//

import UIKit

final class CustomSpacerView: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
