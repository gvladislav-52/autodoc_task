//
//  AppFactory.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import UIKit

struct AppFactory {
    func buildRootViewController() -> UIViewController {
        let navigationController = UINavigationController()
        let router = AppRouter(navigationController: navigationController)
        let homeViewController = HomeFactory().build(router: router)

        navigationController.viewControllers = [homeViewController]
        return navigationController
    }
}
