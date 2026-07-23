//
//  AppRouter.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import ATUIKit

final class AppRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AppRouter: Routing {
    func route(to route: AppRoute) {
        switch route {
        case .webView(let url):
            showWebView(url: url)
        }
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool = true) {
        navigationController?.presentedViewController?.dismiss(animated: animated)
    }
}

private extension AppRouter {
    func showWebView(url: URL) {
        guard let navigationController else { return }

        if navigationController.presentedViewController == nil {
            let webViewController = WebFactory().build(url: url, isPresentedModally: false)
            navigationController.pushViewController(webViewController, animated: true)
        } else {
            let webViewController = WebFactory().build(url: url, isPresentedModally: true)
            let modalNavigationController = UINavigationController(rootViewController: webViewController)
            modalNavigationController.modalPresentationStyle = .fullScreen
            navigationController.present(modalNavigationController, animated: true)
        }
    }
}
