//
//  CountyData.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import Foundation

struct County: Codable {
    let name: String
    var localities: [String]
}

struct CountyData: Codable {
    let counties: [String: [String]]
}
