//
//  HomeProvider.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation
import ATNetworking

protocol ProvidesHome {
    func fetchHomePosts(page: Int, postCount: Int) async throws -> WebDTO.HomePostResponse
}

struct HomeProvider: ProvidesHome {
    private let homeService: WebHomeServiceProtocol

    init(homeService: WebHomeServiceProtocol) {
        self.homeService = homeService
    }

    func fetchHomePosts(page: Int, postCount: Int) async throws -> WebDTO.HomePostResponse {
        try await homeService.getHomePost(page: page, postCount: postCount)
    }
}
