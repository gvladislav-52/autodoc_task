//
//  WebHomeService.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

public protocol WebHomeServiceProtocol {
    func getHomePost(page: Int, postCount: Int) async throws -> WebDTO.HomePostResponse
}

public struct WebHomeService: WebHomeServiceProtocol {
    private let webManager: WebManagerProtocol
    public init() {
        webManager = WebManager.shared
    }

    public func getHomePost(page: Int, postCount: Int) async throws -> WebDTO.HomePostResponse {
        return try await webManager.executeNonAuthorized(
            webRequest: WebRequest(
                method: .get,
                headers: [.init(contentType: .applicationJson)],
                path: "/api/news/\(page)/\(postCount)",
                query: ["sort": "createDate,desc"],
                body: nil
            )
        )
    }
}
