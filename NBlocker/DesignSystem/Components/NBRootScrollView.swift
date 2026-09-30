import SwiftUI

/// Gives every root tab the same full-height, top-aligned scrolling canvas.
/// The native tab bar supplies the bottom safe-area inset for this container.
struct NBRootScrollView<Content: View>: View {
    private let spacing: CGFloat
    @ViewBuilder private let content: Content

    init(
        spacing: CGFloat = NBSpacing.large,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    content
                }
                .padding(.horizontal, NBSpacing.screen)
                .padding(.top, NBSpacing.standard)
                .padding(.bottom, NBSpacing.section)
                .frame(
                    maxWidth: .infinity,
                    minHeight: proxy.size.height,
                    alignment: .topLeading
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
