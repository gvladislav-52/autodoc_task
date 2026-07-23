//
//  WebViewController.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import ATUIKit
import Combine

final class WebViewController: UIViewController {
    private let viewModel: WebViewModelProtocol
    private let isPresentedModally: Bool
    private var cancellables = Set<AnyCancellable>()

    private lazy var contentView: DisplaysWeb = {
        let view = WebView()
        view.viewDelegate = self
        return view
    }()

    init(viewModel: WebViewModelProtocol, isPresentedModally: Bool) {
        self.viewModel = viewModel
        self.isPresentedModally = isPresentedModally
        super.init(nibName: nil, bundle: nil)
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
        contentView.load(url: viewModel.url)
    }
}

private extension WebViewController {
    func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.contentView.apply(state: state)

                if case .success(let viewModel) = state {
                    self?.title = viewModel.title
                }
            }
            .store(in: &cancellables)
    }
}

extension WebViewController: WebViewDelegate {
    func webViewDidStartLoading(_ view: WebView) {
        viewModel.startLoading()
    }

    func webView(_ view: WebView, didFinishLoadingWithTitle title: String?) {
        viewModel.finishLoading(title: title)
    }

    func webView(_ view: WebView, didFailWithError error: Error) {
        viewModel.failLoading(error: error)
    }
}
