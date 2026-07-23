//
//  WebRequest.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

struct WebRequest {
    let method: HTTPMethod
    let headers: [WebRequest.Header]
    let path: String
    let query: [String: Any]?
    let body: Codable?

    struct Header: RawRepresentable {
        var key: String { rawValue.key }
        var value: String {rawValue.value }

        let rawValue: (key: String, value: String)

        init(rawValue: (key: String, value: String)) {
            self.rawValue = rawValue
        }
    }
}

extension WebRequest.Header {
    enum ContentType: String {
        case applicationJson = "application/json"
    }

    init(contentType: ContentType) {
        self.init(rawValue: (key: "Content-Type", value: contentType.rawValue))
    }
}
