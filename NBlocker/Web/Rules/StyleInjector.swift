import Foundation

enum StyleInjector {
    static func script(for css: String, identifier: String) -> String {
        let encoded = try? JSONEncoder().encode(css)
        let cssLiteral = encoded.flatMap { String(data: $0, encoding: .utf8) } ?? "\"\""
        let safeIdentifier = identifier.replacingOccurrences(of: "'", with: "")
        return """
        (() => {
          const id = 'nblocker-style-\(safeIdentifier)';
          const install = () => {
            const parent = document.head || document.documentElement;
            if (!parent) return;
            let style = document.getElementById(id);
            if (!style) {
              style = document.createElement('style');
              style.id = id;
              parent.appendChild(style);
            }
            style.textContent = \(cssLiteral);
          };
          install();
          if (!document.documentElement) {
            document.addEventListener('DOMContentLoaded', install, { once: true });
          }
        })();
        """
    }
}
