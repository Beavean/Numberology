//
//  NumbersViewController.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import SnapKit
import UIKit

protocol NumberInputContainer {
    func getNumbers() -> [Int]
}

final class NumbersViewController: UIViewController {
    // MARK: - UI Elements

    private let titleLabel: CustomLabel = {
        let label = CustomLabel(text: "Interesting Numbers", fontSize: 28, isBold: true)
        label.textAlignment = .center
        label.textColor = .mainTextColor
        return label
    }()

    private let appDescriptionLabel: CustomLabel = {
        let label = CustomLabel(text: "This App about facts of Numbers and Dates", fontSize: 16, isBold: false)
        label.textAlignment = .center
        label.textColor = .mainTextColor
        return label
    }()

    private let dicesView = DicesView(mainColor: .mainFillColor, backgroundFillColor: .itemBackgroundColor)

    private let userNumberButton = OperationButton(title: "User\nnumber")
    private let randomNumberButton = OperationButton(title: "Random\nnumber")
    private let numberInRangeButton = OperationButton(title: "Number\nin a range")
    private let multipleNumbersButton = OperationButton(title: "Multiple\nnumbers")
    private let dateNumbersButton = OperationButton(title: "Date\nnumbers")
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private lazy var informationLabel: CustomLabel = {
        let label = CustomLabel(text: numbersOption.labelTitle, fontSize: 14)
        return label
    }()

    private let userNumberView = UserNumberView()
    private let randomNumberView = RandomNumberView()
    private let numberInRangeView = NumberInRangeView()
    private let multipleNumbersView = MultipleNumbersView()
    private let dateNumbersView = DateNumbersView()
    private let interactionView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    private let displayFactButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainFillColor
        button.titleLabel?.font = UIFont.boldTextCustomFont()
        button.setTitleColor(.textOnFilledBackgroundColor, for: .normal)
        button.setTitle("Display Fact", for: .normal)
        button.layer.cornerRadius = Constants.StyleDefaults.cornerRadius
        return button
    }()

    // MARK: - Properties

    private let outerPadding = Constants.StyleDefaults.outerPadding
    private let innerPadding = Constants.StyleDefaults.innerPadding
    private let horizontalPadding = Constants.StyleDefaults.verticalPadding
    private let alertTitle = "Incorrect input"
    private let networkManager = NetworkManager()
    private lazy var numberInputContainer: NumberInputContainer = userNumberView
    private var numbersOption: NumbersOption = .userNumber {
        didSet {
            setupState()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTargets()
        setupState()
        registerForKeyboardNotifications()
        addKeyboardDismissal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Actions

    @objc private func userNumberButtonPressed() {
        numbersOption = .userNumber
    }

    @objc private func randomNumberButtonPressed() {
        numbersOption = .randomNumber
    }

    @objc private func numberInRangeButtonPressed() {
        numbersOption = .numberInRange
    }

    @objc private func multipleNumbersButtonPressed() {
        numbersOption = .multipleNumbers
    }

    @objc private func dateNumbersButtonPressed() {
        numbersOption = .dateNumbers
    }

    @objc private func displayFactButtonPressed() {
        guard !numberInputContainer.getNumbers().isEmpty else {
            showInfoAlert(title: alertTitle, message: numbersOption.alertMessage)
            return
        }
        displayFactButton.showBlurLoader()
        switch numbersOption {
        case .userNumber, .multipleNumbers:
            networkManager.fetchNumbersInfo(numbers: numberInputContainer.getNumbers()) { [weak self] result in
                self?.handleNetworkManagerResult(result)
            }
        case .randomNumber:
            networkManager.fetchRandomNumberWithFact { [weak self] result in
                self?.handleNetworkManagerResult(result)
            }
        case .numberInRange:
            networkManager.fetchNumbersInfoInRange(range: numberInputContainer.getNumbers()) { [weak self] result in
                self?.handleNetworkManagerResult(result)
            }
        case .dateNumbers:
            networkManager.fetchDate(fromArray: numberInputContainer.getNumbers()) { [weak self] result in
                self?.handleNetworkManagerResult(result)
            }
        }
    }

    // MARK: - Configuration

    private func configureUI() {
        view.backgroundColor = .screenBackgroundColor
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(horizontalPadding * 2)
            $0.left.right.equalToSuperview()
        }

        view.addSubview(appDescriptionLabel)
        appDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(horizontalPadding)
            $0.left.right.equalToSuperview()
        }

        view.addSubview(displayFactButton)
        displayFactButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(outerPadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(innerPadding)
            $0.height.equalTo(Constants.StyleDefaults.itemHeight)
        }

        interactionView.addArrangedSubview(userNumberView)
        interactionView.addArrangedSubview(randomNumberView)
        interactionView.addArrangedSubview(numberInRangeView)
        interactionView.addArrangedSubview(multipleNumbersView)
        interactionView.addArrangedSubview(dateNumbersView)
        view.addSubview(interactionView)
        interactionView.snp.makeConstraints {
            $0.bottom.equalTo(displayFactButton.snp.top).offset(-outerPadding)
            $0.height.equalTo(Constants.StyleDefaults.itemHeight)
            $0.left.right.equalToSuperview().inset(outerPadding)
        }

        view.addSubview(informationLabel)
        informationLabel.snp.makeConstraints {
            $0.bottom.equalTo(interactionView.snp.top).offset(-innerPadding)
            $0.left.right.equalToSuperview().inset(outerPadding)
        }

        configureButtonsStackView()

        view.addSubview(dicesView)
        dicesView.snp.makeConstraints {
            $0.top.equalTo(appDescriptionLabel.snp.bottom).offset(horizontalPadding)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(buttonsStackView.snp.top).offset(-horizontalPadding)
            $0.width.equalTo(dicesView.snp.height)
        }
    }

    private func configureButtonsStackView() {
        buttonsStackView.addArrangedSubview(userNumberButton)
        buttonsStackView.addArrangedSubview(randomNumberButton)
        buttonsStackView.addArrangedSubview(numberInRangeButton)
        buttonsStackView.addArrangedSubview(multipleNumbersButton)
        buttonsStackView.addArrangedSubview(dateNumbersButton)
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints {
            $0.bottom.equalTo(informationLabel.snp.top).offset(-outerPadding)
            $0.left.right.equalToSuperview().inset(outerPadding)
        }
    }

    private func addTargets() {
        userNumberButton.addTarget(self, action: #selector(userNumberButtonPressed), for: .touchUpInside)
        randomNumberButton.addTarget(self, action: #selector(randomNumberButtonPressed), for: .touchUpInside)
        numberInRangeButton.addTarget(self, action: #selector(numberInRangeButtonPressed), for: .touchUpInside)
        multipleNumbersButton.addTarget(self, action: #selector(multipleNumbersButtonPressed), for: .touchUpInside)
        dateNumbersButton.addTarget(self, action: #selector(dateNumbersButtonPressed), for: .touchUpInside)
        displayFactButton.addTarget(self, action: #selector(displayFactButtonPressed), for: .touchUpInside)
    }

    private func setupState() {
        view.endEditing(true)
        informationLabel.text = numbersOption.labelTitle
        userNumberButton.setAsUnselected()
        randomNumberButton.setAsUnselected()
        numberInRangeButton.setAsUnselected()
        multipleNumbersButton.setAsUnselected()
        dateNumbersButton.setAsUnselected()
        interactionView.arrangedSubviews.forEach { $0.isHidden = true }
        switch numbersOption {
        case .userNumber:
            userNumberButton.setAsSelected()
            userNumberView.isHidden = false
            numberInputContainer = userNumberView
        case .randomNumber:
            randomNumberButton.setAsSelected()
            randomNumberView.isHidden = false
            numberInputContainer = randomNumberView
        case .numberInRange:
            numberInRangeButton.setAsSelected()
            numberInRangeView.isHidden = false
            numberInputContainer = numberInRangeView
        case .multipleNumbers:
            multipleNumbersButton.setAsSelected()
            multipleNumbersView.isHidden = false
            numberInputContainer = multipleNumbersView
        case .dateNumbers:
            dateNumbersButton.setAsSelected()
            dateNumbersView.isHidden = false
            numberInputContainer = dateNumbersView
        }
    }

    // MARK: - Helpers

    private func handleNetworkManagerResult(_ result: Result<[String: String], Error>) {
        DispatchQueue.main.async {
            self.displayFactButton.hideBlurLoader()
            switch result {
            case let .success(dictionary):
                let controller = FactTableViewController(data: dictionary)
                self.navigationController?.pushViewController(controller, animated: true)
            case let .failure(error):
                self.showError(error)
            }
        }
    }
}

// MARK: - Keyboard helpers

private extension NumbersViewController {
    private func addKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillMove(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillMove(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillMove(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            dicesView.alpha = 1
            displayFactButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardEndFrame.height + innerPadding)
            }
        } else {
            dicesView.alpha = 0
            displayFactButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(innerPadding)
            }
        }
        UIView.animate(withDuration: duration) {
            self.dicesView.alpha = self.dicesView.alpha == 0 ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
}
