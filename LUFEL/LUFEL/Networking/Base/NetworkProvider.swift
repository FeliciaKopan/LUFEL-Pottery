//
//  NetworkProvider.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import Foundation

struct NetworkProvider: NetworkProviding {

    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }

    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            guard let response = response as? HTTPURLResponse else {
                throw ApiError(
                    errorCode: "ERROR-0",
                    message: "Invalid HTTP response"
                )
            }

            if response.statusCode == 401 {
                throw ApiError(
                    errorCode: "ERROR-401",
                    message: "Unauthorized"
                )
            } else {
                return try self.manageResponse(data: data, response: response)
            }
        } catch let error as ApiError {
            print(error)
            throw error
        } catch {
            throw ApiError(
                errorCode: "ERROR-0",
                message: "Unknown API error \(error.localizedDescription)"
            )
        }
    }

    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError(
                errorCode: "ERROR-0",
                message: "Invalid HTTP response"
            )
        }
        switch response.statusCode {
        case 200...299:
            do {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString ?? "No data")
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ApiError(
                    errorCode: "ERROR-0",
                    message: "Error decoding data"
                )
            }
        default:
            let string = String(data: data, encoding: .utf8)
            print("error: ", string ?? "Unknown error")
            guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: "ERROR-0",
                    message: "Unknown backend error"
                )
            }
            throw ApiError(
                statusCode: response.statusCode,
                errorCode: decodedError.error.name,
                message: decodedError.error.message
            )
        }
    }
}

private struct NetworkProviderKey: InjectionKey {
    static var currentValue: NetworkProviding = NetworkProvider()
}

extension InjectedValues {
    var networkProvider: NetworkProviding {
        get { Self[NetworkProviderKey.self] }
        set { Self[NetworkProviderKey.self] = newValue }
    }
}
