//
//  AddressDetails.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 22.07.2024.
//

import Foundation

struct AddressDetails: Codable, Equatable {
    let fullName: String
    let phoneNumber: String
    let address: String
    let county: String
    let locality: String
}
