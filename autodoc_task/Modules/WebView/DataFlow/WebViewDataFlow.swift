//
//  WebViewDataFlow.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import Foundation

enum WebDataFlow {
    enum State {
        case idle
        case loading
        case success(ViewModelSuccess)
        case failure(ViewModelFailure)
    }

    struct ViewModelSuccess {
        let title: String?
    }

    struct ViewModelFailure {
        let message: String
    }
}
