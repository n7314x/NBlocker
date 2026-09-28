import Foundation
import WebKit

enum ScriptInjector {
    @MainActor
    static func userScript(source: String, injectionTime: RuleInjectionTime) -> WKUserScript {
        WKUserScript(
            source: source,
            injectionTime: injectionTime == .documentStart ? .atDocumentStart : .atDocumentEnd,
            forMainFrameOnly: true
        )
    }
}
