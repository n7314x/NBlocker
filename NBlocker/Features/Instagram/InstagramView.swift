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
    @State private var browserButtonPosition: CGPoint?

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
        GeometryReader { proxy in
            let bounds = browserButtonBounds(in: proxy)
            let restingPosition = CGPoint(x: bounds.maxX, y: bounds.maxY)
            let buttonPosition = browserButtonPosition ?? restingPosition
            let menuPosition = browserMenuPosition(near: buttonPosition, in: proxy)

            ZStack {
                if showsBrowserMenu {
                    Color.black.opacity(0.30)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture { setBrowserMenu(false) }
                        .transition(.opacity)
                        .zIndex(10)
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
                            .padding(.bottom, 72)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .allowsHitTesting(!showsBrowserMenu)
                .zIndex(5)

                BrowserMenuView(
                    model: model,
                    showAccounts: { performMenuAction(showAccountControls) },
                    openClipboard: { performMenuAction { _ = model.openClipboardURL() } },
                    showSettings: { performMenuAction { showsSettings = true } },
                    exitToHome: { performMenuAction(exitToHome) }
                )
                .position(menuPosition)
                .scaleEffect(showsBrowserMenu ? 1 : 0.84, anchor: menuPosition.y < buttonPosition.y ? .bottom : .top)
                .opacity(showsBrowserMenu ? 1 : 0)
                .blur(radius: showsBrowserMenu ? 0 : 7)
                .allowsHitTesting(showsBrowserMenu)
                .accessibilityHidden(!showsBrowserMenu)
                .zIndex(20)

                BrowserToolbar(
                    position: $browserButtonPosition,
                    restingPosition: restingPosition,
                    movementBounds: bounds,
                    isExpanded: showsBrowserMenu,
                    menuWillClose: { setBrowserMenu(false) }
                ) {
                    setBrowserMenu(!showsBrowserMenu)
                }
            }
            .coordinateSpace(name: "browserChrome")
            .onChange(of: proxy.size) { _, _ in
                guard let browserButtonPosition else { return }
                self.browserButtonPosition = CGPoint(
                    x: min(max(browserButtonPosition.x, bounds.minX), bounds.maxX),
                    y: min(max(browserButtonPosition.y, bounds.minY), bounds.maxY)
                )
            }
        }
    }

    private func browserButtonBounds(in proxy: GeometryProxy) -> CGRect {
        let radius: CGFloat = 29
        let margin = NBSpacing.standard
        let minX = proxy.safeAreaInsets.leading + margin + radius
        let maxX = proxy.size.width - proxy.safeAreaInsets.trailing - margin - radius
        let minY = proxy.safeAreaInsets.top + margin + radius
        let maxY = proxy.size.height - proxy.safeAreaInsets.bottom - margin - radius
        return CGRect(x: minX, y: minY, width: max(0, maxX - minX), height: max(0, maxY - minY))
    }

    private func browserMenuPosition(near button: CGPoint, in proxy: GeometryProxy) -> CGPoint {
        let halfWidth: CGFloat = 158
        let verticalSpacing: CGFloat = 70
        let x = min(max(button.x, halfWidth + NBSpacing.small), proxy.size.width - halfWidth - NBSpacing.small)
        let spaceAbove = button.y - proxy.safeAreaInsets.top
        let y = spaceAbove > 118 ? button.y - verticalSpacing : button.y + verticalSpacing
        return CGPoint(x: x, y: y)
    }

    private func setBrowserMenu(_ isPresented: Bool) {
        withAnimation(reduceMotion ? NBAnimation.quick : .spring(response: 0.30, dampingFraction: 0.82)) {
            showsBrowserMenu = isPresented
        }
    }

    private func performMenuAction(_ action: () -> Void) {
        setBrowserMenu(false)
        action()
    }

    private func showAccountControls() {
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

    private func exitToHome() {
        model.stopTracking()
        environment.router.selectedTab = .home
        environment.router.presentedBrowser = nil
        dismiss()
    }
}
