//
//  NetworkManager.swift
//  Numberology
//
//  Created by Beavean on 07.04.2023.
//

import Foundation

final class NetworkManager {
    // MARK: - Properties

    private let dateDictionaryKey = "Picked Date Fact:"

    // MARK: - Fetch methods

    func fetchFactsFor(numbers: [Int], completion: @escaping (Result<[NumberFact], Error>) -> Void) {
        guard let url = createUrlQuery(forNumbers: numbers, withOption: .multipleNumbers) else {
            completion(.failure(NetworkManagerError.invalidRequest))
            return
        }
        if numbers.count > 1 {
            fetchInfoForMultipleNumbers(url: url, completion: completion)
        } else {
            fetchInfoForSingleNumber(url: url,
                                     number: numbers.first,
                                     completion: completion)
        }
    }

    func fetchFactsForNumbers(inRange range: [Int], completion: @escaping (Result<[NumberFact], Error>) -> Void) {
        if range.count > 1, let url = createUrlQuery(forNumbers: range, withOption: .numberInRange) {
            fetchInfoForMultipleNumbers(url: url, completion: completion)
        } else if range.count == 1 {
            guard let url = createUrlQuery(forNumbers: range, withOption: .userNumber) else {
                completion(.failure(NetworkManagerError.invalidRange))
                return
            }
            fetchInfoForSingleNumber(url: url,
                                     number: range.first,
                                     completion: completion)
        }
    }

    func fetchFactForRandomNumber(completion: @escaping (Result<[NumberFact], Error>) -> Void) {
        guard let url = createUrlQuery(withOption: .randomNumber) else {
            completion(.failure(NetworkManagerError.invalidRequest))
            return
        }
        fetchInfoForSingleNumber(url: url, number: nil, completion: completion)
    }

    func fetchDateFact(fromArray array: [Int], completion: @escaping (Result<[DateFact], Error>) -> Void) {
        guard let url = createUrlQuery(forNumbers: array, withOption: .dateNumbers) else {
            completion(.failure(NetworkManagerError.invalidRequest))
            return
        }
        fetchDate(url: url, completion: completion)
    }

    // MARK: - Helpers

    private func createUrlQuery(forNumbers array: [Int] = [], withOption option: NumbersOption) -> URL? {
        let query: String
        switch option {
        case .randomNumber:
            query = Constants.URLComponents.randomNumberWithFactQuery
        case .numberInRange:
            guard array.count == 2 else { return nil }
            query = "\(array[0])..\(array[1])"
        case .userNumber, .multipleNumbers:
            if array.count > 1 {
                query =  array.map { String($0) }.joined(separator: ",")
            } else {
                query = "\(array[0])"
            }
        case .dateNumbers:
            guard array.count == 2 else { return nil }
            query = "\(array[0])/\(array[1])"
        }
        return generateUrl(forQuery: query)
    }

    private func generateUrl(forQuery query: String) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.URLComponents.scheme
        components.host = Constants.URLComponents.host
        components.path = "/" + query
        components.queryItems = [URLQueryItem(name: Constants.URLComponents.defaultKey,
                                              value: Constants.URLComponents.defaultFact)]
        return components.url
    }

    private func fetchInfoForMultipleNumbers(url: URL,
                                             completion: @escaping (Result<[NumberFact], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkManagerError.noData))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode([Int: String].self, from: data)
                let factDataArray = decodedResponse.map { NumberFact(number: $0.key, fact: $0.value) }
                let sortedData = factDataArray.sorted { $0.number < $1.number }
                completion(.success(sortedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func fetchInfoForSingleNumber(url: URL,
                                          number: Int?,
                                          completion: @escaping (Result<[NumberFact], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkManagerError.noData))
                return
            }
            if let responseText = String(data: data, encoding: .utf8) {
                let fetchedNumber = self.extractNumber(from: responseText)
                let factData = NumberFact(number: (number ?? fetchedNumber) ?? 0, fact: responseText)
                completion(.success([factData]))
            } else {
                completion(.failure(NetworkManagerError.noData))
            }
        }.resume()
    }

    private func fetchDate(url: URL, completion: @escaping (Result<[DateFact], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkManagerError.noData))
                return
            }
            if let responseText = String(data: data, encoding: .utf8) {
                let factData = DateFact(date: self.extractDateFromFact(responseText), fact: responseText)
                completion(.success([factData]))
            } else {
                completion(.failure(NetworkManagerError.noData))
            }
        }.resume()
    }

    private func extractNumber(from input: String) -> Int? {
        let pattern = "^(\\d+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let match = regex?.firstMatch(in: input,
                                         options: [],
                                         range: NSRange(location: 0, length: input.utf16.count)) {
            let numberRange = match.range(at: 1)
            let number = Int((input as NSString).substring(with: numberRange))
            return number
        }
        return nil
    }

    private func extractDateFromFact(_ string: String) -> String {
        let words = string.split(separator: " ")
        guard words.count >= 2 else { return "" }
        let month = String(words[0])
        let date = String(words[1])
        let monthDate = "\(month) \(date)"
        return monthDate
    }
}
