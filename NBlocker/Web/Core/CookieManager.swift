import WebKit

@MainActor
enum CookieManager {
    static func clearWebsiteData(for platform: Platform) async {
        let store = WKWebsiteDataStore.default()
        let records = await store.dataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes())
        let matching = records.filter { record in
            let name = record.displayName.lowercased()
            return platform == .instagram ? name.contains("instagram") : name.contains("youtube") || name.contains("google")
        }
        await store.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: matching)
    }
}
