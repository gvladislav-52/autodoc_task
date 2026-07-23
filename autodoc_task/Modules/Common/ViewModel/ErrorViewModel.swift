//
//  ErrorViewModel.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation
import ATNetworking
import ATResources

struct ErrorViewModel {
    let message: String

    init(_ error: APIError) {
        message = error.mapAPIError()
    }
}

fileprivate extension APIError {
    func mapAPIError() -> String {
        switch self {
        case .backend(let backendError):
            return backendError.mapBackendError()
        case .internalError(let internalError):
            return internalError.mapInternalError()
        case .common(let commonError):
            return commonError.mapCommonError()
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension APIError.Backend {
    func mapBackendError() -> String {
        switch self {
        case .unauthorized:
            return Strings.APIError.Backend.unauthorized
        case .httpFailed(let statusCode):
            return Strings.APIError.Backend.httpFailed(statusCode)
        case .requestTimeout:
            return Strings.APIError.Backend.requestTimeout
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension APIError.Internal {
    func mapInternalError() -> String {
        switch self {
        case .badResponse:
            return Strings.APIError.InternalError.badResponse
        case .invalidRequest:
            return Strings.APIError.InternalError.invalidRequest
        case .invalidURL:
            return Strings.APIError.InternalError.invalidURL
        case .networkUnavailable:
            return Strings.APIError.InternalError.networkUnavailable
        case .dataEncoding:
            return Strings.APIError.InternalError.dataEncoding
        case .dataDecoding:
            return Strings.APIError.InternalError.dataDecoding
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension APIError.Common {
    func mapCommonError() -> String {
        switch self {
        case .unknown(let underlyingError):
            return Strings.APIError.Common.unknown(underlyingError)
        @unknown default:
            fatalError()
        }
    }
}
