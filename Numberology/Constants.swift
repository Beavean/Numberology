//
//  Constants.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

// TODO: Make to _
// TODO: remove IQKBDmanager and make UIImage view resizable
// TODO: Consider periphery

enum Constants {
    enum API {
        static let maxNumber = 9999

    }

    enum Style {
        static let cornerRadius: CGFloat = 10
        static let itemHeight: CGFloat = 52
        static let outerPadding: CGFloat = 16
        static let innerPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 24
    }

    enum Colors: String, CaseIterable {
        case borderColor
        case itemBackgroundColor
        case mainFillColor
        case mainTextColor
        case textOnFilledBackgroundColor
        case viewBackgroundColor

        var color: UIColor? { UIColor(named: rawValue) }
    }

    enum Fonts {
        static let openSansRegular = "OpenSans-Regular"
        static let opensSansSemiBold = "OpenSans-SemiBold"
    }
}
