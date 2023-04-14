//
//  NumbersViewController.swift
//  Numberology
//
//  Created by Beavean on 05.04.2023.
//

import SnapKit
import UIKit

protocol NumberInputContainer: AnyObject {
    var numbers: [Int] { get }
}

final class NumbersViewController: UIViewController {
    // MARK: - UI Elements

    private let titleLabel: DefaultStyleLabel = {
        let label = DefaultStyleLabel(text: "Interesting Numbers", fontSize: 28, isBold: true)
        label.textAlignment = .center
        label.textColor = .mainTextColor
        return label
    }()
    private let appDescriptionLabel: DefaultStyleLabel = {
        let label = DefaultStyleLabel(text: "This App about facts of Numbers and Dates", fontSize: 16, isBold: false)
        label.textAlignment = .center
        label.textColor = .mainTextColor
        return label
    }()
    private let dicesView = DicesView(mainColor: .mainFillColor, backgroundFillColor: .itemBackgroundColor)
    private let userNumberButton = OperationButton(title: "User number")
    private let randomNumberButton = OperationButton(title: "Random number")
    private let numberInRangeButton = OperationButton(title: "Range of numbers")
    private let multipleNumbersButton = OperationButton(title: "Multiple numbers")
    private let dateNumbersButton = OperationButton(title: "Date numbers")
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private lazy var informationLabel = DefaultStyleLabel(text: numbersOption.labelTitle, fontSize: 14)
    private let userNumberView = UserNumberView()
    private let randomNumberView = RandomNumberView()
    private let numberInRangeView = NumberInRangeView()
    private let multipleNumbersView = MultipleNumbersView()
    private let dateNumbersView = DateNumbersView()
    private let interactionView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
    private let horizontalPadding = Constants.StyleDefaults.outerPadding
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
        guard !numberInputContainer.numbers.isEmpty else {
            showInfoAlert(title: alertTitle, message: numbersOption.alertMessage)
            return
        }
        displayFactButton.showBlurLoader()
        switch numbersOption {
        case .userNumber, .multipleNumbers:
            networkManager.fetchNumbersInfo(numbers: numberInputContainer.numbers) { [weak self] result in
                self?.handleNetworkManagerResult(result)
            }
        case .randomNumber:
            networkManager.fetchRandomNumberWithFact { [weak self] result in
                self?.handleNetworkManagerResult(result)
            }
        case .numberInRange:
            let rangeNumbers = numberInputContainer.numbers
            networkManager.fetchNumbersInfoInRange(range: numberInputContainer.numbers) { [weak self] result in
                self?.handleNetworkManagerResult(result, rangeStart: rangeNumbers.first, rangeEnd: rangeNumbers.last)
            }
        case .dateNumbers:
            networkManager.fetchDate(fromArray: numberInputContainer.numbers) { [weak self] result in
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
            $0.top.equalTo(appDescriptionLabel.snp.bottom).offset(outerPadding)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(buttonsStackView.snp.top).offset(-outerPadding)
            $0.width.equalTo(dicesView.snp.height)
            $0.width.lessThanOrEqualToSuperview().inset(outerPadding)
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
        userNumberButton.setUnselected()
        randomNumberButton.setUnselected()
        numberInRangeButton.setUnselected()
        multipleNumbersButton.setUnselected()
        dateNumbersButton.setUnselected()
        interactionView.arrangedSubviews.forEach { $0.isHidden = true }
        switch numbersOption {
        case .userNumber:
            userNumberButton.setSelected()
            userNumberView.isHidden = false
            numberInputContainer = userNumberView
        case .randomNumber:
            randomNumberButton.setSelected()
            randomNumberView.isHidden = false
            numberInputContainer = randomNumberView
        case .numberInRange:
            numberInRangeButton.setSelected()
            numberInRangeView.isHidden = false
            numberInputContainer = numberInRangeView
        case .multipleNumbers:
            multipleNumbersButton.setSelected()
            multipleNumbersView.isHidden = false
            numberInputContainer = multipleNumbersView
        case .dateNumbers:
            dateNumbersButton.setSelected()
            dateNumbersView.isHidden = false
            numberInputContainer = dateNumbersView
        }
    }

    // MARK: - Helpers

    private func handleNetworkManagerResult(_ result: Result<[NumberFact], Error>,
                                            rangeStart: Int? = nil,
                                            rangeEnd: Int? = nil) {
        DispatchQueue.main.async {
            self.displayFactButton.hideBlurLoader()
            switch result {
            case let .success(data):
                let controller = FactTableViewController(data: data,
                                                         rangeStartNumber: rangeStart,
                                                         rangeEndNumber: rangeEnd)
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
            displayFactButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardEndFrame.height + innerPadding)
            }
        } else {
            displayFactButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(innerPadding)
            }
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
