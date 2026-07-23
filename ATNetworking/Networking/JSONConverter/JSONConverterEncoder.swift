//
//  JSONConverterEncoder.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

protocol JSONConverterEncoderProtocol {
    func encode(data: [String: Any]) throws -> Data
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

struct JSONConverterEncoder: JSONConverterEncoderProtocol {
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        let jsonEncoder = JSONEncoder()
        do {
            return try jsonEncoder.encode(value)
        } catch {
            throw APIError.internalError(.dataEncoding)
        }
    }

    func encode(data: [String: Any]) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            throw APIError.internalError(.dataEncoding)
        }
    }
}
