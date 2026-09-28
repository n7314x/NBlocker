import SwiftUI

struct NBBottomBar: View {
    @Binding var selection: RootTab
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GlassEffectContainer(spacing: 6) {
            HStack(spacing: 2) {
                ForEach(RootTab.allCases) { tab in
                    Button {
                        guard selection != tab else { return }
                        HapticManager.play(.selection)
                        withAnimation(reduceMotion ? NBAnimation.quick : NBAnimation.interactive) {
                            selection = tab
                        }
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: selection == tab ? "\(tab.symbolName).fill" : tab.symbolName)
                                .font(.system(size: 17, weight: .semibold))
                                .contentTransition(.symbolEffect(.replace))

                            Text(tab.compactTitle)
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundStyle(selection == tab ? Color.white : NBColor.secondaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 43)
                        .background {
                            if selection == tab {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.16))
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("tab.\(tab.rawValue)")
                    .accessibilityLabel(tab.title)
                }
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .glassEffect(.regular.interactive(), in: Capsule())
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 2)
    }
}
