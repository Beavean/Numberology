//
//  NetworkManagerTests.swift
//  NumberologyTests
//
//  Created by Beavean on 14.04.2023.
//

@testable import Numberology
import XCTest

final class NetworkManagerTests: XCTestCase {
    private var sut: NetworkManager!
    private let timeout: TimeInterval = 2

    override func setUp() {
        super.setUp()
        sut = NetworkManager()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testSingleNumberFactFetch() {
        let expectation = expectation(description: #function)
        var receivedFacts = [NumberFact]()
        sut.fetchFactsFor(numbers: [1337]) { result in
            switch result {
            case let .success(facts):
                receivedFacts = facts
            case let .failure(error):
                XCTFail("Error fetching numbers info: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                XCTFail("Expectation timeout error")
            } else {
                XCTAssertFalse(receivedFacts.isEmpty, "Facts array should not be empty")
            }
        }
    }

    func testMultipleNumberFactsFetch() {
        let expectation = expectation(description: #function)
        var receivedFacts = [NumberFact]()
        sut.fetchFactsFor(numbers: [1337, 999, 0, 1]) { result in
            switch result {
            case let .success(facts):
                receivedFacts = facts
            case let .failure(error):
                XCTFail("Error fetching numbers info: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                XCTFail("Expectation timeout error")
            } else {
                XCTAssertFalse(receivedFacts.isEmpty, "Facts array should not be empty")
            }
        }
    }

    func testRangeOfNumbersFactsFetch() {
        let expectation = expectation(description: #function)
        var receivedFacts = [NumberFact]()
        let range = [1337, 2000]
        sut.fetchFactsForNumbers(inRange: range) { result in
            switch result {
            case let .success(facts):
                receivedFacts = facts
            case let .failure(error):
                XCTFail("Error fetching numbers info: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                XCTFail("Expectation timeout error")
            } else {
                XCTAssertFalse(receivedFacts.isEmpty, "Facts array should not be empty")
            }
        }
    }

    func testRandomNumberFactFetch() {
        let expectation = expectation(description: #function)
        var receivedFacts = [NumberFact]()
        sut.fetchFactForRandomNumber { result in
            switch result {
            case let .success(facts):
                receivedFacts = facts
            case let .failure(error):
                XCTFail("Error fetching numbers info: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                XCTFail("Expectation timeout error")
            } else {
                XCTAssertFalse(receivedFacts.isEmpty, "Facts array should not be empty")
            }
        }
    }

    func testDateFactFetch() {
        let expectation = expectation(description: #function)
        var receivedFacts = [DateFact]()
        let dateAsArray = [12, 31]
        sut.fetchDateFact(fromArray: dateAsArray) { result in
            switch result {
            case let .success(facts):
                receivedFacts = facts
            case let .failure(error):
                XCTFail("Error fetching numbers info: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                XCTFail("Expectation timeout error")
            } else {
                XCTAssertFalse(receivedFacts.isEmpty, "Facts array should not be empty")
            }
        }
    }
}
