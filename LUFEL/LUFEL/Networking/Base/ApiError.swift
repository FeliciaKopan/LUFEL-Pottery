//
//  ApiError.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation

struct ApiError: Error {

    let error: ErrorObject

    struct ErrorObject: Decodable {
        let name: String
        let status: Int
        let message: String
    }

    init(statusCode: Int = 0, errorCode: String, message: String) {
        error = ErrorObject(name: "\(errorCode)", status: statusCode, message: message)
    }

    var errorCodeNumber: String {
        let numberString = String(error.status)
        return numberString
    }

    private enum CodingKeys: String, CodingKey {
        case error
    }
}

extension ApiError: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decode(ErrorObject.self, forKey: .error)
    }
}
