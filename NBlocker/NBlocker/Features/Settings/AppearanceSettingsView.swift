import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("appearance.reduceNativeMotion") private var reduceMotion = false

    var body: some View {
        List {
            Toggle("Reduce native motion", isOn: $reduceMotion)
            Text("NBlocker uses OLED black and follows the system accessibility settings. Website appearance is configured per platform.")
                .font(.footnote)
                .foregroundStyle(NBColor.secondaryText)
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Appearance")
    }
}
