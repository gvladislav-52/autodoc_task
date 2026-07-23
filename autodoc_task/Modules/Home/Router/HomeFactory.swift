//
//  HomeFactory.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation
import ATNetworking

struct HomeFactory {
    func build(router: Routing) -> HomeViewController {
        let provider = HomeProvider(homeService: WebHomeService())
        let viewModel = HomeViewModel(provider: provider)
        return HomeViewController(viewModel: viewModel, router: router)
    }
}
