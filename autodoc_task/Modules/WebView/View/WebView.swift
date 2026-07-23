//
//  WebView.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import ATUIKit
import WebKit

protocol DisplaysWeb: UIView {
    var viewDelegate: WebViewDelegate? { get set }
    func apply(state: WebDataFlow.State)
    func load(url: URL)
}

protocol WebViewDelegate: AnyObject {
    func webViewDidStartLoading(_ view: WebView)
    func webView(_ view: WebView, didFinishLoadingWithTitle title: String?)
    func webView(_ view: WebView, didFailWithError error: Error)
}

final class WebView: UIView {
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    weak var viewDelegate: WebViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WebView: DisplaysWeb {
    func apply(state: WebDataFlow.State) {
        render(state)
    }

    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
}

private extension WebView {
    func render(_ state: WebDataFlow.State) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()

        case .loading:
            activityIndicator.startAnimating()

        case .success:
            activityIndicator.stopAnimating()

        case .failure:
            activityIndicator.stopAnimating()
        }
    }
}
// swiftlint:disable implicitly_unwrapped_optional
extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewDelegate?.webViewDidStartLoading(self)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewDelegate?.webView(self, didFinishLoadingWithTitle: webView.title)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        viewDelegate?.webView(self, didFailWithError: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        viewDelegate?.webView(self, didFailWithError: error)
    }
}
// swiftlint:enable implicitly_unwrapped_optional

private extension WebView {
    func addSubviews() {
        addSubview(webView)
        addSubview(activityIndicator)
    }

    func addConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
