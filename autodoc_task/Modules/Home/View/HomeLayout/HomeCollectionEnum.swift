//
//  HomeCollectionEnum.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

enum HomeCollectionSection: Int, CaseIterable {
    case posts
}

enum HomeCollectionItem: Hashable {
    case posts(HomePostsModel)
}
