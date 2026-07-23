//
//  WebEnvironment.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

enum WebEnvironment {
    static let current = Self.production
    case production
    case test
    case dev

    var apiBaseURL: String {
        switch WebEnvironment.current {
        case .production:
            "https://webapi.autodoc.ru"
        case .test:
            "https://webapi.autodoc.ru"
        case .dev:
            "https://webapi.autodoc.ru"
        }
    }
}
