//
//  UIView+BlurLoader.swift
//  Numberology
//
//  Created by Beavean on 08.04.2023.
//

import UIKit

extension UIView {
    func showBlurLoader() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let spinner = UIActivityIndicatorView(style: .large)
        blurView.frame = bounds
        blurView.clipsToBounds = true
        blurView.addRoundedBorder()
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        spinner.center = blurView.contentView.center
        spinner.hidesWhenStopped = true
        blurView.contentView.addSubview(spinner)
        isUserInteractionEnabled = false
        addSubview(blurView)
        spinner.startAnimating()
        UIView.animate(withDuration: Constants.StyleDefaults.animationDuration) {
            blurView.alpha = 1
        }
    }

    func hideBlurLoader() {
        guard let blurView = subviews.filter({ $0 is UIVisualEffectView }).first else { return }
        UIView.animate(withDuration: Constants.StyleDefaults.animationDuration) {
            blurView.alpha = 0.0
        } completion: { _ in
            self.isUserInteractionEnabled = true
            blurView.removeFromSuperview()
        }
    }
}
