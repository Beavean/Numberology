//
//  UIView+Border.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

extension UIView {
    func addRoundedBorder(withColor color: UIColor? = .borderColor) {
        layer.cornerRadius = Constants.StyleDefaults.cornerRadius
        layer.borderColor = color?.cgColor
        layer.borderWidth = 1
    }

    func removeRoundedBorder() {
        layer.borderWidth = 0
    }
}
