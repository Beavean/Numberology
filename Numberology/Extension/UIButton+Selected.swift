//
//  UIButton+Selected.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

extension UIButton {
    func setSelected() {
        backgroundColor = .mainFillColor
        setTitleColor(.textOnFilledBackgroundColor, for: .normal)
        removeRoundedBorder()
    }

    func setUnselected() {
        addRoundedBorder()
        backgroundColor = .itemBackgroundColor
        setTitleColor(.mainTextColor, for: .normal)
    }
}
