//
//  HomePostsModel.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

struct HomePostsModel: Hashable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: URL?
    let categoryType: String
}

extension HomePostsModel {
    var contentConfiguration: HomePostsContentConfiguration {
        HomePostsContentConfiguration(
            id: id,
            title: title,
            description: description,
            publishedDate: publishedDate,
            url: url,
            fullUrl: fullUrl,
            titleImageUrl: titleImageUrl,
            categoryType: categoryType
        )
    }
}
