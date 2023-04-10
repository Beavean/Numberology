//
//  NetworkManagerError.swift
//  Numberology
//
//  Created by Beavean on 09.04.2023.
//

import Foundation

enum NetworkManagerError: Error {
    case noData
    case invalidRequest
    case invalidRange

    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data received from server"
        case .invalidRequest:
            return "Invalid request"
        case .invalidRange:
            return "Invalid range"
        }
    }
}
