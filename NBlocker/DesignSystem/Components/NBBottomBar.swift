import SwiftUI

struct NBBottomBar: View {
    @Binding var selection: RootTab
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GlassEffectContainer(spacing: NBSpacing.small) {
            HStack(spacing: NBSpacing.xSmall) {
                ForEach(RootTab.allCases) { tab in
                    Button {
                        guard selection != tab else { return }
                        HapticManager.play(.selection)
                        withAnimation(reduceMotion ? NBAnimation.quick : NBAnimation.interactive) {
                            selection = tab
                        }
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: selection == tab ? "\(tab.symbolName).fill" : tab.symbolName)
                                .contentTransition(.symbolEffect(.replace))
                                .animation(NBAnimation.quick, value: selection == tab)
                            Text(tab.title).font(.caption2.weight(.medium))
                        }
                        .foregroundStyle(selection == tab ? Color.white : NBColor.secondaryText)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background {
                            if selection == tab {
                                Capsule()
                                    .fill(Color.accentColor.opacity(0.14))
                                    .padding(.horizontal, 4)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("tab.\(tab.rawValue)")
                }
            }
            .padding(6)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
        .padding(.horizontal, NBSpacing.standard)
        .padding(.top, 4)
    }
}
