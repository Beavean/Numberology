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

    private var data = [NumberFact]()
    private var dateFact = [DateFact]()
    private var isFetchingMoreData = false
    private var currentEndNumber: Int?
    private var requestedRangeEndNumber: Int?
    private let networkManager = NetworkManager()
    private var isShowingDateFact = false

    // MARK: - Lifecycle

    init(numerFacts: [NumberFact], rangeStartNumber: Int? = nil, rangeEndNumber: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        data = numerFacts
        guard let rangeStartNumber, let rangeEndNumber else { return }
        currentEndNumber = rangeStartNumber + numerFacts.count
        requestedRangeEndNumber = rangeEndNumber
    }

    init(dateFact: [DateFact]) {
        super.init(nibName: nil, bundle: nil)
        self.dateFact = dateFact
        isShowingDateFact = true
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
        tableView.isScrollEnabled = tableView.contentSize.height >= tableView.bounds.size.height
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
        tableView.prefetchDataSource = self
        tableView.accessibilityIdentifier = "factTableView"
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
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "backButton"
    }

    // MARK: - Helpers

    private func fetchMoreFacts() {
        guard let currentEndNumber,
              let requestedRangeEndNumber,
              currentEndNumber < requestedRangeEndNumber else { return }
        isFetchingMoreData = true
        let range = [currentEndNumber, requestedRangeEndNumber]
        networkManager.fetchFactsForNumbersIn(range: range) { [weak self] result in
            self?.handleNetworkManagerResult(result)
        }
    }

    private func handleNetworkManagerResult(_ result: Result<[NumberFact], Error>) {
        DispatchQueue.main.async { [self] in
            switch result {
            case let .success(fetchedData):
                guard let oldEndNumber = currentEndNumber else { return }
                currentEndNumber = oldEndNumber + data.count
                data.append(contentsOf: fetchedData)
                tableView.reloadData()
                isFetchingMoreData = false
            case let .failure(error):
                showError(error)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isShowingDateFact ? dateFact.count : data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FactTableViewCell.reuseIdentifier,
                                                       for: indexPath)
            as? FactTableViewCell
        else { return UITableViewCell() }
        if isShowingDateFact {
            cell.configure(withDate: dateFact[indexPath.row].date, fact: dateFact[indexPath.row].fact)
        } else {
            cell.configure(withNumber: data[indexPath.row].number, fact: data[indexPath.row].fact)
        }
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension FactTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxIndexPath = indexPaths.max(),
              maxIndexPath.row >= data.count / 2,
              !isFetchingMoreData
        else { return }
        fetchMoreFacts()
    }
}
