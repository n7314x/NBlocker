import Foundation

enum BrowserClipboardAction {
    static func url(from value: String?) -> URL? {
        guard var candidate = value?.trimmingCharacters(in: .whitespacesAndNewlines), !candidate.isEmpty else {
            return nil
        }
        if !candidate.contains("://") {
            candidate = "https://\(candidate)"
        }
        guard
            let components = URLComponents(string: candidate),
            let scheme = components.scheme?.lowercased(),
            ["http", "https"].contains(scheme),
            let host = components.host,
            !host.isEmpty,
            let url = components.url
        else { return nil }
        return url
    }
}
