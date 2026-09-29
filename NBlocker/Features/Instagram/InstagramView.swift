import SwiftUI

struct InstagramView: View {
    @State private var model: WebViewModel

    init(settings: PlatformSettings, usageTracker: UsageTracker) {
        let minimumPreparationDuration = ProcessInfo.processInfo.arguments.contains("-NBlockerUITesting") ? 60.0 : 0.7
        _model = State(initialValue: WebViewModel(
            platform: .instagram,
            settings: settings,
            usageTracker: usageTracker,
            minimumPreparationDuration: minimumPreparationDuration
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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let model: WebViewModel
    @State private var showsSettings = false
    @State private var showsAccounts = false
    @State private var showsBrowserMenu = false
    @State private var showsLinkActions = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            WebView(model: model)
                .ignoresSafeArea()
                .opacity(isReady ? 1 : 0)
                .allowsHitTesting(isReady && !showsBrowserMenu)
                .accessibilityIdentifier("browser.webView")

            if isReady {
                browserChrome
                    .transition(.opacity)
            } else {
                BrowserLaunchView(
                    platform: model.platform,
                    presentation: model.state.presentation,
                    retry: model.retry,
                    close: closeBrowser
                )
                .transition(.opacity)
            }
        }
        .tint(model.platform.accentColor)
        .accessibilityIdentifier("browser.\(model.platform.rawValue)")
        .animation(reduceMotion ? nil : NBAnimation.quick, value: model.state.presentation)
        .animation(reduceMotion ? nil : NBAnimation.quick, value: showsBrowserMenu)
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
        .confirmationDialog("Current Link", isPresented: $showsLinkActions) {
            Button("Copy Link", systemImage: "doc.on.doc", action: model.copyCurrentURL)
            Button("Open in Safari", systemImage: "safari", action: model.openCurrentURLExternally)
            Button("Cancel", role: .cancel) {}
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
        .sheet(isPresented: $showsAccounts) {
            InstagramAccountSwitcherView {
                InstagramAccountManager().openAccountManagement(in: model)
            }
        }
    }

    private var isReady: Bool {
        model.state.presentation == .ready
    }

    private var browserChrome: some View {
        ZStack {
            if showsBrowserMenu {
                Color.black.opacity(0.28)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture { showsBrowserMenu = false }
                    .transition(.opacity)
            }

            VStack(spacing: NBSpacing.small) {
                if model.platform == .instagram {
                    BrowserMetricsBar(model: model)
                        .padding(.horizontal, NBSpacing.standard)
                }

                if model.state.isLoading {
                    BrowserLoadingBar(progress: model.state.estimatedProgress)
                        .padding(.horizontal, NBSpacing.standard)
                }

                Spacer()

                if let message = model.state.message {
                    BrowserErrorView(message: message, dismiss: model.clearMessage)
                        .padding(.horizontal, NBSpacing.standard)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                HStack {
                    Spacer(minLength: NBSpacing.xLarge)
                    if showsBrowserMenu {
                        BrowserMenuView(
                            model: model,
                            showAccounts: showAccountControls,
                            showLinkActions: {
                                showsBrowserMenu = false
                                showsLinkActions = true
                            },
                            showSettings: {
                                showsBrowserMenu = false
                                showsSettings = true
                            },
                            closeBrowser: closeBrowser,
                            dismiss: { showsBrowserMenu = false }
                        )
                        .transition(.scale(scale: 0.94, anchor: .bottomTrailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, NBSpacing.standard)

                HStack {
                    Spacer()
                    BrowserToolbar(isExpanded: showsBrowserMenu) {
                        showsBrowserMenu.toggle()
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
                .padding(.horizontal, NBSpacing.standard)
                .padding(.bottom, NBSpacing.small)
            }
        }
    }

    private func showAccountControls() {
        showsBrowserMenu = false
        switch model.platform {
        case .instagram:
            showsAccounts = true
        case .youtube:
            if let url = URL(string: "https://accounts.google.com/") {
                model.load(url)
            }
        }
    }

    private func closeBrowser() {
        model.stopTracking()
        dismiss()
    }
}
