//
//  CountyProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import Foundation
import Combine

class CountyProvider: CountyProviding {
    func fetchCounties() -> AnyPublisher<[County], Error> {
        guard let url = Bundle.main.url(forResource: "Counties", withExtension: "json") else {
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }

        return Future { promise in
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let countyData = try decoder.decode([String: [String]].self, from: data)
                var counties = countyData.map { County(name: $0.key, localities: $0.value) }
                counties.sort { $0.name < $1.name }
                promise(.success(counties))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

private struct CountyProviderKey: InjectionKey {
    static var currentValue: CountyProviding = CountyProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var countyProvider: CountyProviding {
        get { Self[CountyProviderKey.self] }
        set { Self[CountyProviderKey.self] = newValue }
    }
}
