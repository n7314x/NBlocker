import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            LabeledContent("Version", value: "0.1.0")
            LabeledContent("Data model", value: "Local-first")
            Text("NBlocker is an independent distraction-control app and is not affiliated with Instagram, YouTube, Meta, or Google.")
                .font(.footnote)
                .foregroundStyle(NBColor.secondaryText)
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("About")
    }
}
