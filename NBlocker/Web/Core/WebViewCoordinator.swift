import Foundation
import WebKit

@MainActor
final class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    weak var model: WebViewModel?

    init(model: WebViewModel) {
        self.model = model
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url, let model else { return .cancel }
        switch model.navigationDisposition(for: url) {
        case .allow:
            return .allow
        case let .redirect(url):
            webView.load(URLRequest(url: url))
            return .cancel
        case let .block(reason):
            model.didBlockNavigation(reason: reason)
            return .cancel
        case .requestExternalOpen:
            model.pendingExternalURL = url
            return .cancel
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
        model?.didStartNavigation(webView)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        model?.didFinishNavigation(webView)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation?,
        withError error: any Error
    ) {
        model?.didFailNavigation(webView)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        model?.receiveBridgeMessage(message.body)
    }
}
