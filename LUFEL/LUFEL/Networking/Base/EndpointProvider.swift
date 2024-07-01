//
//  EndpointProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation

protocol EndpointProvider {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var token: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
}

extension EndpointProvider {
    var scheme: String {
        return "https"
    }

    var baseURL: String {
        return AppConfig.baseURL
    }

    var token: String? {
        return nil
    }

    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseURL
        urlComponents.path = path
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            throw ApiError(errorCode: "ERROR-0", message: "URL error")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")

        if let token = token {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw ApiError(errorCode: "ERROR-0", message: "Error encoding http body")
            }
        }
        return urlRequest
    }
}

