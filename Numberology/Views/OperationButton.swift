//
//  OperationButton.swift
//  Numberology
//
//  Created by Beavean on 06.04.2023.
//

import SnapKit
import UIKit

final class OperationButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        configureButton(withTitle: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton(withTitle title: String) {
        addDefaultShadow()
        setTitle(title, for: .normal)
        titleLabel?.font = .boldTextCustomFont(size: 12)
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
        layer.cornerRadius = Constants.StyleDefaults.cornerRadius
        snp.makeConstraints {
            $0.width.equalTo(snp.height)
        }
    }
}
