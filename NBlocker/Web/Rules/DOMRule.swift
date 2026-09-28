import Foundation

enum RuleResourceKind: String, Sendable {
    case script
    case style
}

enum RuleInjectionTime: Sendable {
    case documentStart
    case documentEnd
}

struct DOMRule: Identifiable, Equatable, Sendable {
    let id: String
    let platform: Platform?
    let relativePath: String
    let kind: RuleResourceKind
    let injectionTime: RuleInjectionTime

    init(
        id: String,
        platform: Platform?,
        relativePath: String,
        kind: RuleResourceKind = .script,
        injectionTime: RuleInjectionTime = .documentEnd
    ) {
        self.id = id
        self.platform = platform
        self.relativePath = relativePath
        self.kind = kind
        self.injectionTime = injectionTime
    }
}
