import Foundation
import WebKit

enum RuleEngineError: LocalizedError, Equatable {
    case missingResource(String)
    case unreadableResource(String)

    var errorDescription: String? {
        switch self {
        case let .missingResource(path): "Missing bundled web rule: \(path)"
        case let .unreadableResource(path): "Could not read bundled web rule: \(path)"
        }
    }
}

struct RuleEngine {
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func enabledRules(for platform: Platform, settings: PlatformSettings) -> [DOMRule] {
        let shared = [
            DOMRule(id: "shared.bootstrap", platform: nil, relativePath: "Shared/bootstrap.js", injectionTime: .documentStart),
            DOMRule(id: "shared.messaging", platform: nil, relativePath: "Shared/messaging.js", injectionTime: .documentStart),
            DOMRule(id: "shared.observer", platform: nil, relativePath: "Shared/dom-observer.js", injectionTime: .documentStart),
            DOMRule(id: "shared.style", platform: nil, relativePath: "Shared/shared.css", kind: .style, injectionTime: .documentStart)
        ]

        switch platform {
        case .instagram:
            return shared + InstagramRuleProvider().rules(for: settings.instagram)

        case .youtube:
            return shared + YouTubeRuleProvider().rules(for: settings.youtube)
        }
    }

    @MainActor
    func install(
        platform: Platform,
        settings: PlatformSettings,
        into controller: WKUserContentController
    ) throws {
        controller.removeAllUserScripts()
        controller.addUserScript(ScriptInjector.userScript(
            source: try configurationSource(platform: platform, settings: settings),
            injectionTime: .documentStart
        ))
        for rule in enabledRules(for: platform, settings: settings) {
            let source = try source(for: rule)
            controller.addUserScript(ScriptInjector.userScript(source: source, injectionTime: rule.injectionTime))
        }
    }

    func source(for rule: DOMRule) throws -> String {
        let path = rule.relativePath as NSString
        let fileName = path.lastPathComponent as NSString
        let resourceName = fileName.deletingPathExtension
        let fileExtension = fileName.pathExtension
        let subdirectory = "WebResources/\(path.deletingLastPathComponent)"
        let fullPath = "\(subdirectory)/\(fileName)"
        guard let url = bundle.url(
            forResource: resourceName,
            withExtension: fileExtension.isEmpty ? nil : fileExtension,
            subdirectory: subdirectory
        ) else {
            throw RuleEngineError.missingResource(fullPath)
        }
        guard let raw = try? String(contentsOf: url, encoding: .utf8) else {
            throw RuleEngineError.unreadableResource(fullPath)
        }
        return rule.kind == .style ? StyleInjector.script(for: raw, identifier: rule.id) : raw
    }

    private func configurationSource(platform: Platform, settings: PlatformSettings) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data: Data
        switch platform {
        case .instagram: data = try encoder.encode(settings.instagram)
        case .youtube: data = try encoder.encode(settings.youtube)
        }
        guard let json = String(data: data, encoding: .utf8) else {
            throw RuleEngineError.unreadableResource("generated configuration")
        }
        return "window.__NBLOCKER_CONFIG__ = \(json);"
    }
}
