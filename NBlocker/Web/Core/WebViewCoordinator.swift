import Foundation
import WebKit

@MainActor
final class WebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    weak var model: WebViewModel?

    init(model: WebViewModel) {
        self.model = model
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url, let model else { return .cancel }
        let context = NavigationContext(
            isMainFrame: navigationAction.targetFrame?.isMainFrame ?? true,
            isUserInitiated: navigationAction.navigationType == .linkActivated ||
                navigationAction.navigationType == .formSubmitted
        )
        switch model.navigationDisposition(for: url, context: context) {
        case .allow:
            return .allow
        case let .redirect(url):
            webView.load(URLRequest(url: url))
            return .cancel
        case let .block(reason):
            model.didBlockNavigation(reason: reason)
            return .cancel
        case .cancelSilently:
            model.didCancelBackgroundNavigation()
            return .cancel
        case .requestExternalOpen:
            model.pendingExternalURL = url
            return .cancel
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
        model?.didStartNavigation(webView)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation?) {
        model?.didCommitNavigation(webView)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        model?.didFinishNavigation(webView)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation?,
        withError error: any Error
    ) {
        model?.didFailNavigation(webView, error: error)
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation?,
        withError error: any Error
    ) {
        model?.didFailNavigation(webView, error: error)
    }

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        guard navigationAction.targetFrame == nil, let url = navigationAction.request.url else {
            return nil
        }
        model?.handleNewWindowRequest(
            url,
            context: NavigationContext(
                isMainFrame: true,
                isUserInitiated: navigationAction.navigationType == .linkActivated ||
                    navigationAction.navigationType == .formSubmitted
            ),
            in: webView
        )
        return nil
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        model?.webContentProcessDidTerminate()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        model?.receiveBridgeMessage(message.body)
    }
}
