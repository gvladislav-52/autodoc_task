//
//  APIError.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

public enum APIError: Error {
    case backend(Backend)
    case internalError(Internal)
    case common(Common)

    public enum Backend: Error {
        case unauthorized
        case httpFailed(Int)
        case requestTimeout
    }

    public enum Internal: Error {
        case badResponse
        case invalidRequest
        case invalidURL
        case networkUnavailable
        case dataEncoding
        case dataDecoding
    }

    public enum Common: Error {
        case unknown(Error)
    }
}
