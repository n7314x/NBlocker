import Foundation

struct InstagramAccountManager: Sendable {
    var accountManagementURL: URL {
        URL(string: "https://www.instagram.com/accounts/login/") ?? Platform.instagram.startURL
    }

    @MainActor
    func openAccountManagement(in browser: WebViewModel) {
        browser.load(accountManagementURL)
    }
}
