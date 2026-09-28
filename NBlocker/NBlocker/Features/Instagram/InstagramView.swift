import SwiftUI

struct InstagramView: View {
    @State private var model: WebViewModel

    init(settings: PlatformSettings, usageTracker: UsageTracker) {
        _model = State(initialValue: WebViewModel(
            platform: .instagram,
            settings: settings,
            usageTracker: usageTracker
        ))
    }

    var body: some View {
        PlatformBrowserView(model: model)
    }
}

struct PlatformBrowserView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    let model: WebViewModel
    @State private var showsSettings = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            WebView(model: model).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    BrowserCloseButton {
                        model.stopTracking()
                        dismiss()
                    }
                }
                .padding(.horizontal, NBSpacing.standard)
                .padding(.top, NBSpacing.small)

                if model.state.isLoading {
                    BrowserLoadingBar(progress: model.state.estimatedProgress)
                        .padding(.horizontal, NBSpacing.standard)
                        .padding(.top, NBSpacing.small)
                }
                Spacer()

                if let message = model.state.message {
                    BrowserErrorView(message: message, dismiss: model.clearMessage)
                        .padding(.horizontal, NBSpacing.standard)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if model.isToolbarVisible {
                    BrowserToolbar(model: model) { showsSettings = true }
                        .padding(.top, NBSpacing.small)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .tint(model.platform.accentColor)
        .animation(NBAnimation.quick, value: model.isToolbarVisible)
        .onDisappear { model.stopTracking() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                model.resumeTracking()
            } else {
                model.stopTracking()
            }
        }
        .confirmationDialog(
            "Open this link outside NBlocker?",
            isPresented: Binding(
                get: { model.pendingExternalURL != nil },
                set: { if !$0 { model.pendingExternalURL = nil } }
            )
        ) {
            Button("Open in Safari") { model.openPendingExternalURL() }
            Button("Cancel", role: .cancel) { model.pendingExternalURL = nil }
        } message: {
            Text("NBlocker filters only the supported platform website.")
        }
        .sheet(isPresented: $showsSettings, onDismiss: {
            model.update(settings: environment.settings.values)
        }) {
            switch model.platform {
            case .instagram:
                InstagramSettingsView(settings: environment.settings.values.instagram) {
                    environment.settings.replaceInstagram(with: $0)
                }
            case .youtube:
                YouTubeSettingsView(settings: environment.settings.values.youtube) {
                    environment.settings.replaceYouTube(with: $0)
                }
            }
        }
    }
}
