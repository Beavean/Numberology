//
//  NumbersOption.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import Foundation

enum NumbersOption {
    case userNumber
    case randomNumber
    case numberInRange
    case multipleNumbers
    case dateNumbers

    var labelTitle: String {
        switch self {
        case .userNumber:
            return "Enter here:"
        case .randomNumber:
            return "Random number:"
        case .numberInRange:
            return "Input a range of up to 100 numbers:"
        case .multipleNumbers:
            return "Enter any numbers separated by comma:"
        case .dateNumbers:
            return "Pick date:"
        }
    }

    var alertMessage: String {
        switch self {
        case .userNumber:
            return "Enter a valid number"
        case .randomNumber:
            return "Unknown error"
        case .numberInRange:
            return "Input numbers in both text field to display facts for a range of numbers"
        case .multipleNumbers:
            return "Enter any amount of numbers separated by comma"
        case .dateNumbers:
            return "Enter a valid date"
        }
    }
}
