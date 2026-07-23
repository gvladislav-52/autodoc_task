//
//  JSONConverterDecoder.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

protocol JSONConverterDecoderProtocol {
    func decode<T>(_ type: T.Type, _ data: Data) throws -> T where T: Codable
}

struct JSONConverterDecoder: JSONConverterDecoderProtocol {
    private let jsonDecoder = JSONDecoder()
    func decode<T>(_ type: T.Type, _ data: Data) throws -> T where T: Codable {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw APIError.internalError(.dataDecoding)
        }
    }
}
