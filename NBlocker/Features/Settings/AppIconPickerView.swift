import SwiftUI

struct AppIconPickerView: View {
    @State private var errorMessage: String?
    @State private var selectedName: String?
    private let manager = AppIconManager()

    var body: some View {
        List {
            Section {
                ForEach(AppIconCatalog.options) { option in
                    Button {
                        Task {
                            do {
                                try await manager.select(option)
                                selectedName = manager.currentName
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: option.symbolName).frame(width: 30)
                            Text(option.title)
                            Spacer()
                            if selectedName == option.alternateName {
                                Image(systemName: "checkmark").foregroundStyle(.tint)
                            }
                        }
                    }
                    .disabled(option != .defaultIcon && !manager.supportsAlternateIcons)
                }
            } footer: {
                if !manager.supportsAlternateIcons {
                    Text("Alternate slots become available after original NBlocker artwork is added to the build.")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("App Icons")
        .onAppear { selectedName = manager.currentName }
        .alert("Icon unavailable", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) { Button("OK", role: .cancel) {} } message: { Text(errorMessage ?? "") }
    }
}
