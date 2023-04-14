//
//  UIViewController+Alert.swift
//  Numberology
//
//  Created by Beavean on 08.04.2023.
//

import UIKit

extension UIViewController {
    func showInfoAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showError(_ error: Error?) {
        if let error {
            showInfoAlert(title: "Error", message: error.localizedDescription)
        } else if let networkManagerError = error as? NetworkManagerError {
            showInfoAlert(title: "Error", message: networkManagerError.localizedDescription)
        } else {
            showInfoAlert(title: "Error", message: "Unknown error occurred.")
        }
    }
}
