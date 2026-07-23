//
//  WebDTO+HomeInfoResponse.swift
//  ATNetworking
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

public extension WebDTO {
    struct HomePostResponse: Codable {
        public let news: [HomePost]
        public let totalCount: Int

        public init(news: [HomePost], totalCount: Int) {
            self.news = news
            self.totalCount = totalCount
        }
    }

    struct HomePost: Codable {
        public let id: Int
        public let title: String
        public let description: String
        public let publishedDate: String
        public let url: String
        public let fullUrl: String
        public let titleImageUrl: String?
        public let categoryType: String

        public init(
            id: Int,
            title: String,
            description: String,
            publishedDate: String,
            url: String,
            fullUrl: String,
            titleImageUrl: String?,
            categoryType: String
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.publishedDate = publishedDate
            self.url = url
            self.fullUrl = fullUrl
            self.titleImageUrl = titleImageUrl
            self.categoryType = categoryType
        }
    }
}
