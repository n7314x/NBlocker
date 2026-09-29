import SwiftUI
import UIKit
import WebKit

struct BrowserViewportLayout: Equatable {
    let contentInset: UIEdgeInsets
    let scrollIndicatorInsets: UIEdgeInsets
    let adjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior

    static func fullScreen(browserMenuVisible: Bool) -> BrowserViewportLayout {
        _ = browserMenuVisible
        return BrowserViewportLayout(
            contentInset: .zero,
            scrollIndicatorInsets: .zero,
            adjustmentBehavior: .never
        )
    }

    @MainActor
    func apply(to scrollView: UIScrollView) {
        scrollView.contentInsetAdjustmentBehavior = adjustmentBehavior
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
    }
}

struct WebView: UIViewRepresentable {
    let model: WebViewModel
    let browserMenuVisible: Bool

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(model: model)
    }

    func makeUIView(context: Context) -> WKWebView {
        if let webView = model.webView {
            connect(webView, to: context.coordinator)
            BrowserViewportLayout.fullScreen(browserMenuVisible: browserMenuVisible).apply(to: webView.scrollView)
            return webView
        }

        let configuration = WKWebViewConfiguration()
        do {
            try model.configure(configuration)
        } catch {
            AppLogger.logger(.rules).error("Initial rule installation failed: \(error.localizedDescription, privacy: .public)")
        }
        let webView = WKWebView(frame: .zero, configuration: configuration)
        connect(webView, to: context.coordinator)
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        BrowserViewportLayout.fullScreen(browserMenuVisible: browserMenuVisible).apply(to: webView.scrollView)
        webView.accessibilityIdentifier = "browser.webView"
        model.attach(webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        BrowserViewportLayout.fullScreen(browserMenuVisible: browserMenuVisible).apply(to: webView.scrollView)
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: WebViewCoordinator) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "nblocker")
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

    @MainActor
    private func connect(_ webView: WKWebView, to coordinator: WebViewCoordinator) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "nblocker")
        webView.configuration.userContentController.add(coordinator, name: "nblocker")
        webView.navigationDelegate = coordinator
        webView.uiDelegate = coordinator
    }
}
