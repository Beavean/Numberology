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

    func fetchNumbersInfo(numbers: [Int], completion: @escaping (Result<[FactData], Error>) -> Void) {
        let numbersString = numbers.map { String($0) }.joined(separator: ",")
        guard let url = generateUrl(forQuery: numbersString) else {
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

    func fetchNumbersInfoInRange(range: [Int], completion: @escaping (Result<[FactData], Error>) -> Void) {
        guard range.count == 2, let url = generateUrl(forQuery: "\(range[0])..\(range[1])") else {
            completion(.failure(NetworkManagerError.invalidRange))
            return
        }
        fetchInfoForMultipleNumbers(url: url, completion: completion)
    }

    func fetchRandomNumberWithFact(completion: @escaping (Result<[FactData], Error>) -> Void) {
        let randomQuery = Constants.URLComponents.randomNumberWithFactQuery
        guard let url = generateUrl(forQuery: randomQuery) else {
            completion(.failure(NetworkManagerError.invalidRequest))
            return
        }
        fetchInfoForSingleNumber(url: url, number: nil, completion: completion)
    }

    func fetchDate(fromArray array: [Int], completion: @escaping (Result<[FactData], Error>) -> Void) {
        guard array.count == 2, let url = generateUrl(forQuery: "\(array[0])/\(array[1])") else {
            completion(.failure(NetworkManagerError.invalidRequest))
            return
        }
        fetchDate(url: url, completion: completion)
    }

    // MARK: - Helpers

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
                                             completion: @escaping (Result<[FactData], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode([String: String].self, from: data)
                let factDataArray = decodedResponse.map { FactData(number: $0.key, fact: $0.value) }
                let sortedData = self.sortData(from: factDataArray)
                completion(.success(sortedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func fetchInfoForSingleNumber(url: URL,
                                          number: Int?,
                                          completion: @escaping (Result<[FactData], Error>) -> Void) {
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
                let factData = FactData(number: String((number ?? fetchedNumber) ?? 0), fact: responseText)
                completion(.success([factData]))
            } else {
                completion(.failure(NetworkManagerError.noData))
            }
        }.resume()
    }

    private func fetchDate(url: URL, completion: @escaping (Result<[FactData], Error>) -> Void) {
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
                let factData = FactData(number: self.dateDictionaryKey, fact: responseText)
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

    private func sortData(from data: [FactData]) -> [FactData] {
        data.sorted {
            guard let num1 = Int($0.number), let num2 = Int($1.number) else {
                if Int($0.number) != nil {
                    return true
                } else if Int($1.number) != nil {
                    return false
                } else {
                    return $0.number < $1.number
                }
            }
            return num1 < num2
        }
    }
}
