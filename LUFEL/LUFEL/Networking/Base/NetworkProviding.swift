//
//  NetworkProviding.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation

protocol NetworkProviding {
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
}

