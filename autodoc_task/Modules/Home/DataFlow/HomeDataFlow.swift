//
//  HomeDataFlow.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation

enum HomeDataFlow {
    enum State {
        case idle
        case loading
        case success(ViewModelSuccess)
        case failure(ViewModelFailure)
    }

    struct ViewModelSuccess {
        let posts: [HomePostsModel]
        var isLoadingNextPage: Bool = false
        var isRefreshing: Bool = false
    }

    struct ViewModelFailure {
        let message: String
    }
}
