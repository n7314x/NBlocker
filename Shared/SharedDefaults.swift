import Foundation

enum SharedDefaults {
    static var suite: UserDefaults? {
        UserDefaults(suiteName: AppGroup.identifier)
    }
}
