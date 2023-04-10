//
//  FactTableViewController.swift
//  Numberology
//
//  Created by Beavean on 07.04.2023.
//

import SnapKit
import UIKit

final class FactTableViewController: UITableViewController {
    // MARK: - Properties

    private var sortedData: [(key: String, value: String)] = []

    // MARK: - Lifecycle

    init(data: [String: String]) {
        super.init(nibName: nil, bundle: nil)
        sortedData = data.sorted { $0.key < $1.key }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainFillColor
        configureTableView()
        configureNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        updateScrollingEnabled()
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Configuration

    private func configureTableView() {
        tableView.register(FactTableViewCell.self, forCellReuseIdentifier: FactTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainFillColor
        appearance.shadowColor = .clear
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: Constants.Images.close.image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .textOnFilledBackgroundColor
        navigationItem.rightBarButtonItem = backButton
    }

    // MARK: - Helpers

    private func updateScrollingEnabled() {
        if tableView.contentSize.height <= tableView.bounds.size.height {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FactTableViewCell.reuseIdentifier,
                                                       for: indexPath)
            as? FactTableViewCell
        else { return UITableViewCell() }
        let title = sortedData[indexPath.row].key
        let text = sortedData[indexPath.row].value
        cell.configure(withTitle: title, text: text)
        return cell
    }
}
