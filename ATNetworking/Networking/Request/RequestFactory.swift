//
//  RequestFactory.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

protocol RequestFactoryProtocol {
    func buildHTTPRequest(environment: WebEnvironment, webRequest: WebRequest) throws -> URLRequest
}

struct RequestFactory: RequestFactoryProtocol {
    private let jsonEncoder: JSONConverterEncoderProtocol

    init(jsonEncoder: JSONConverterEncoderProtocol) {
        self.jsonEncoder = jsonEncoder
    }

    func buildHTTPRequest(environment: WebEnvironment, webRequest: WebRequest) throws -> URLRequest {
        let headers = Dictionary(uniqueKeysWithValues: webRequest.headers.map { ($0.key, $0.value) })

        var components = URLComponents()
        components.path = webRequest.path
        components.queryItems = webRequest
            .query?
            .compactMapValues(String.init(describing:))
            .map(URLQueryItem.init)

        guard let url = components.url(relativeTo: URL(string: environment.apiBaseURL))?.absoluteURL  else {
            throw APIError.internalError(.invalidURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = webRequest.method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = if let body = webRequest.body { try jsonEncoder.encode(body)} else { nil }
        return urlRequest
    }
}
