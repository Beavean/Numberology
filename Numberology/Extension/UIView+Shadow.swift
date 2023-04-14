//
//  UIView+Shadow.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

extension UIView {
    func addDefaultShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        layer.masksToBounds = false
    }
}
