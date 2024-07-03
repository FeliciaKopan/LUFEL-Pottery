//
//  CountyProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import Foundation
import Combine

protocol CountyProviding {
    func fetchCounties() -> AnyPublisher<[County], Error>
}
