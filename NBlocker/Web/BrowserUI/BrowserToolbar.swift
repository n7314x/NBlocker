import SwiftUI

struct BrowserToolbar: View {
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        FloatingBrowserMenuButton(isExpanded: isExpanded, action: action)
    }
}
