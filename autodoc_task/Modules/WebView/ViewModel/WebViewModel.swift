//
//  WebViewModel.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import Foundation
import Combine

protocol WebViewModelProtocol: AnyObject {
    var statePublisher: Published<WebDataFlow.State>.Publisher { get }
    var url: URL { get }

    func startLoading()
    func finishLoading(title: String?)
    func failLoading(error: Error)
}

final class WebViewModel {
    @Published private(set) var state: WebDataFlow.State = .idle
    let url: URL
    init(url: URL) {
        self.url = url
    }
}

extension WebViewModel: WebViewModelProtocol {
    var statePublisher: Published<WebDataFlow.State>.Publisher {
        $state
    }

    func startLoading() {
        state = .loading
    }

    func finishLoading(title: String?) {
        state = .success(WebDataFlow.ViewModelSuccess(title: title))
    }

    func failLoading(error: Error) {
        state = .failure(WebDataFlow.ViewModelFailure(message: error.localizedDescription))
    }
}
