//
//  NumberologyUITests.swift
//  NumberologyUITests
//
//  Created by Beavean on 14.04.2023.
//

import XCTest

final class NumberologyUITests: XCTestCase {
    private var app: XCUIApplication!
    private let timeout: TimeInterval = 2

    // MARK: - Numbers view

    private lazy var titleLabel = app.staticTexts["titleLabel"]
    private lazy var appDescriptionLabel = app.staticTexts["appDescriptionLabel"]
    private lazy var dicesView = app.otherElements["dicesView"]
    private lazy var userNumberButton = app.buttons["userNumberButton"]
    private lazy var randomNumberButton = app.buttons["randomNumberButton"]
    private lazy var numberInRangeButton = app.buttons["numberInRangeButton"]
    private lazy var multipleNumbersButton = app.buttons["multipleNumbersButton"]
    private lazy var dateNumbersButton = app.buttons["dateNumbersButton"]
    private lazy var buttonsStackView = app.otherElements["buttonsStackView"]
    private lazy var informationLabel = app.staticTexts["informationLabel"]
    private lazy var userNumberView = app.otherElements["userNumberView"]
    private lazy var randomNumberView = app.otherElements["randomNumberView"]
    private lazy var numberInRangeView = app.otherElements["numberInRangeView"]
    private lazy var multipleNumbersView = app.otherElements["multipleNumbersView"]
    private lazy var dateNumbersView = app.otherElements["dateNumbersView"]
    private lazy var interactionView = app.otherElements["interactionView"]
    private lazy var displayFactButton = app.buttons["displayFactButton"]

    // MARK: - Interaction elements

    private lazy var userNumberTextField = app.textFields["userNumberTextField"]
    private lazy var randomNumberLabel = app.staticTexts["randomNumberLabel"]
    private lazy var startRangeTextField = app.textFields["startRangeTextField"]
    private lazy var separatorLabel = app.staticTexts["separatorLabel"]
    private lazy var endRangeTextField = app.textFields["endRangeTextField"]
    private lazy var numbersInputTextField = app.textFields["numbersInputTextField"]

    // MARK: - Fact Table View

    private lazy var factTableView = app.tables["factTableView"]
    private lazy var factTitleLabel = app.staticTexts["factTitleLabel"]
    private lazy var descriptionLabel = app.staticTexts["descriptionLabel"]
    private lazy var backButton = app.buttons["backButton"]

    // MARK: - Lifecycle Tetst

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - UI Tests

    func testInterfaceElements() {
        XCTAssertTrue(titleLabel.exists)
        XCTAssertTrue(appDescriptionLabel.exists)
        XCTAssertTrue(dicesView.exists)
        XCTAssertTrue(userNumberButton.exists)
        XCTAssertTrue(randomNumberButton.exists)
        XCTAssertTrue(numberInRangeButton.exists)
        XCTAssertTrue(multipleNumbersButton.exists)
        XCTAssertTrue(dateNumbersButton.exists)
        XCTAssertTrue(buttonsStackView.exists)
        XCTAssertTrue(informationLabel.exists)
        XCTAssertTrue(interactionView.exists)
        XCTAssertTrue(displayFactButton.exists)
    }

    func testInputAlert() {
        displayFactButton.tap()
        let alertTitle = app.staticTexts["Incorrect input"]
        let okButton = app.buttons["OK"]
        XCTAssertTrue(alertTitle.exists)
        okButton.tap()
        numberInRangeButton.tap()
        displayFactButton.tap()
        XCTAssertTrue(alertTitle.exists)
        okButton.tap()
        multipleNumbersButton.tap()
        displayFactButton.tap()
        XCTAssertTrue(alertTitle.exists)
    }

    func testUserNumberFact() {
        userNumberTextField.tap()
        checkHiddenElements(switchedElement: userNumberView)
        userNumberTextField.typeText("1337")
        displayFactButton.tap()
        checkFactViewForExistence(expectationName: #function) { [self] in
            XCTAssertTrue(factTableView.cells.count == 1)
        }
        backButton.tap()
        checkHiddenElements(switchedElement: userNumberView)
    }

    func testRandomNumberFact() {
        randomNumberButton.tap()
        checkHiddenElements(switchedElement: randomNumberView)
        XCTAssertTrue(randomNumberLabel.exists)
        displayFactButton.tap()
        checkFactViewForExistence(expectationName: #function) { [self] in
            XCTAssertTrue(factTableView.cells.count == 1)
        }
        backButton.tap()
        testInterfaceElements()
        checkHiddenElements(switchedElement: randomNumberView)
    }

    func testRangeOfNumbersFacts() {
        numberInRangeButton.tap()
        checkHiddenElements(switchedElement: numberInRangeView)
        XCTAssertTrue(separatorLabel.exists)
        startRangeTextField.tap()
        startRangeTextField.typeText("1")
        endRangeTextField.tap()
        endRangeTextField.typeText("9999")
        displayFactButton.tap()
        checkFactViewForExistence(expectationName: #function) { [self] in
            XCTAssertTrue(factTableView.cells.count > 1)
        }
        backButton.tap()
        checkHiddenElements(switchedElement: numberInRangeView)
    }

    func testMultipleNumbersFacts() {
        multipleNumbersButton.tap()
        checkHiddenElements(switchedElement: multipleNumbersView)
        numbersInputTextField.tap()
        numbersInputTextField.typeText("1. 1337. 9999")
        displayFactButton.tap()
        checkFactViewForExistence(expectationName: #function) { [self] in
            XCTAssertTrue(factTableView.cells.count == 3)
        }
        backButton.tap()
        checkHiddenElements(switchedElement: multipleNumbersView)
    }

    func testDateFact() {
        dateNumbersButton.tap()
        checkHiddenElements(switchedElement: dateNumbersView)
        app.pickerWheels["January"].swipeUp()
        app.pickerWheels["1"].swipeUp()
        displayFactButton.tap()
        checkFactViewForExistence(expectationName: #function) { [self] in
            XCTAssertTrue(factTableView.cells.count == 1)
        }
        backButton.tap()
        checkHiddenElements(switchedElement: dateNumbersView)
    }

    private func checkHiddenElements(switchedElement: XCUIElement) {
        XCTAssertTrue(switchedElement.exists)
        let elements = [userNumberView, randomNumberView, numberInRangeView, multipleNumbersView, dateNumbersView]
        for element in elements where element != switchedElement {
            XCTAssertFalse(element.exists)
        }
    }

    private func checkFactViewForExistence(expectationName: String, testAssertion: (() -> Void)? = nil) {
        XCTAssertTrue(factTableView.waitForExistence(timeout: timeout))
        XCTAssertTrue(factTitleLabel.waitForExistence(timeout: timeout))
        XCTAssertTrue(descriptionLabel.waitForExistence(timeout: timeout))
        XCTAssertTrue(backButton.waitForExistence(timeout: timeout))
        guard testAssertion != nil else { return }
        let currentResult = XCTWaiter.wait(for: [expectation(description: expectationName)], timeout: timeout)
        if currentResult == XCTWaiter.Result.timedOut {
            testAssertion?()
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
