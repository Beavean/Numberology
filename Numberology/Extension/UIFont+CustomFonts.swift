//
//  UIFont+CustomFonts.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

extension UIFont {
    static func regularTextCustomFont(size: CGFloat = 16) -> UIFont? {
        if let font = UIFont(name: Constants.Fonts.openSansRegular, size: size) {
            return font
        } else {
            print("\(#function) not found")
            return nil
        }
    }

    static func boldTextCustomFont(size: CGFloat = 16) -> UIFont? {
        if let font = UIFont(name: Constants.Fonts.opensSansSemiBold, size: size) {
            return font
        } else {
            print("\(#function) not found")
            return nil
        }
    }
}
