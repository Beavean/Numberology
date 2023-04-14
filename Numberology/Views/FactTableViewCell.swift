//
//  FactTableViewCell.swift
//  Numberology
//
//  Created by Beavean on 07.04.2023.
//

import SnapKit
import UIKit

final class FactTableViewCell: UITableViewCell {
    // MARK: - UI Elements

    private let titleLabel = DefaultStyleLabel(fontSize: 28,
                                               isBold: true,
                                               textAlignment: .center,
                                               textColor: .textOnFilledBackgroundColor)
    private let descriptionLabel = DefaultStyleLabel(fontSize: 16,
                                                     isBold: true,
                                                     textAlignment: .center,
                                                     textColor: .textOnFilledBackgroundColor)

    // MARK: - Properties

    static let reuseIdentifier = String(describing: FactTableViewCell.self)

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureUI() {
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(Constants.StyleDefaults.outerPadding)
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.StyleDefaults.outerPadding)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.bottom.equalToSuperview().inset(Constants.StyleDefaults.outerPadding)
        }
    }

    func configure(withNumber number: Int, fact: String) {
        titleLabel.text = "\(number)"
        descriptionLabel.text = fact
    }

    func configure(withDate date: String, fact: String) {
        titleLabel.text = date
        descriptionLabel.text = fact
    }
}
