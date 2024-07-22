//
//  AddressProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 22.07.2024.
//

import Foundation

class AddressProvider: AddressProviding {
    private let userDefaultsKey = "savedAddresses"
    private var addresses: [AddressDetails] = []

    init() {
        loadAddresses()
    }

    func getAddresses() -> [AddressDetails] {
        return addresses
    }

    func addAddress(_ address: AddressDetails) {
        addresses.insert(address, at: 0)
        saveAddresses()
    }

    func removeAddress(_ address: AddressDetails) {
        if let index = addresses.firstIndex(where: { $0 == address }) {
            addresses.remove(at: index)
            saveAddresses()
        }
    }

    private func saveAddresses() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(addresses) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func loadAddresses() {
        if let savedAddresses = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedAddresses = try? decoder.decode([AddressDetails].self, from: savedAddresses) {
                addresses = loadedAddresses
            }
        }
    }
}

private struct AddressProviderKey: InjectionKey {
    static var currentValue: AddressProviding = AddressProvider()
}

// MARK: - InjectedValues extension

extension InjectedValues {
    var addressProvider: AddressProviding {
        get { Self[AddressProviderKey.self] }
        set { Self[AddressProviderKey.self] = newValue }
    }
}
