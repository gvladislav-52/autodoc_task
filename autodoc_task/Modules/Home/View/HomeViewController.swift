//
//  ViewController.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 21.07.2026.
//

import ATUIKit
import Combine
import ATResources

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModelProtocol
    private let router: Routing
    private var cancellables = Set<AnyCancellable>()

    private lazy var contentView: DisplaysHome = {
        let view = HomeView()
        view.viewDelegate = self
        return view
    }()

    init(viewModel: HomeViewModelProtocol, router: Routing) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        title = Strings.Home.Screen.title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.loadHome()
    }
}

private extension HomeViewController {
    func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.contentView.apply(state: state)
                self?.handleFailureIfNeeded(state)
            }
            .store(in: &cancellables)
    }

    func handleFailureIfNeeded(_ state: HomeDataFlow.State) {
        guard case .failure(let failure) = state else {
            return
        }
        guard presentedViewController == nil else {
            return
        }
        showErrorAlert(message: failure.message)
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: Strings.Home.ErrorAlert.title,
            message: truncatedErrorMessage(message),
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: Strings.Home.ErrorAlert.retry, style: .default) { [weak self] _ in
                self?.viewModel.loadHome()
            }
        )
        alert.addAction(UIAlertAction(title: Strings.Home.ErrorAlert.cancel, style: .cancel))

        present(alert, animated: true)
    }

    func truncatedErrorMessage(_ message: String, maxLength: Int = 240) -> String {
        guard message.count > maxLength else {
            return message
        }
        let endIndex = message.index(message.startIndex, offsetBy: maxLength)
        return String(message[..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines) + "…"
    }
}

extension HomeViewController: HomeViewDelegate {
    func homeView(_ view: HomeView, willDisplayItemAt index: Int) {
        viewModel.loadNextPageIfNeeded(currentIndex: index)
    }

    func homeView(_ view: HomeView, didSelectPost post: HomePostsModel) {
        guard let url = URL(string: post.fullUrl) else {
            return
        }
        router.route(to: .webView(url: url))
    }

    func homeViewDidPullToRefresh(_ view: HomeView) {
        viewModel.refreshHome()
    }
}
