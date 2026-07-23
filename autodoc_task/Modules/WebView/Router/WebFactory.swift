//
//  WebFactory.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import Foundation

struct WebFactory {
    func build(url: URL, isPresentedModally: Bool) -> WebViewController {
        let viewModel = WebViewModel(url: url)
        return WebViewController(viewModel: viewModel, isPresentedModally: isPresentedModally)
    }
}
