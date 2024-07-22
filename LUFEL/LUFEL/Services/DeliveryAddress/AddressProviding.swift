//
//  AddressProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 22.07.2024.
//

import Foundation

protocol AddressProviding {
    func getAddresses() -> [AddressDetails]
    func addAddress(_ address: AddressDetails)
    func removeAddress(_ address: AddressDetails)
}
