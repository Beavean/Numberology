//
//  DefaultStyleLabel.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import UIKit

final class DefaultStyleLabel: UILabel {
    init(text: String = "",
         fontSize size: CGFloat = 16,
         isBold: Bool = false,
         textAlignment: NSTextAlignment = .left,
         textColor: UIColor? = .mainTextColor) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.textColor = textColor
        numberOfLines = 0
        font = isBold ? .boldTextCustomFont(size: size) : .regularTextCustomFont(size: size)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
