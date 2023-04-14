//
//  Constants.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

enum Constants {
    enum URLComponents {
        static let scheme = "http"
        static let host = "numbersapi.com"
        static let defaultKey = "default"
        static let defaultFact = "No interesting facts were found for this number..."
        static let randomNumberWithFactQuery = "random"
    }

    enum APIDefaults {
        static let maxNumber = 999_999_999_999
    }

    enum StyleDefaults {
        static let cornerRadius: CGFloat = 10
        static let itemHeight: CGFloat = 52
        static let outerPadding: CGFloat = 16
        static let innerPadding: CGFloat = 8
        static let animationDuration = 0.3
    }

    enum Colors: String, CaseIterable {
        case borderColor
        case itemBackgroundColor
        case mainFillColor
        case mainTextColor
        case textOnFilledBackgroundColor
        case screenBackgroundColor

        var color: UIColor? { UIColor(named: rawValue) }
    }

    enum Images: String {
        case close

        var image: UIImage? { UIImage(named: rawValue) }
    }

    enum Fonts {
        static let openSansRegular = "OpenSans-Regular"
        static let opensSansSemiBold = "OpenSans-SemiBold"
    }
}
