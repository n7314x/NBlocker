import SwiftUI

struct PlatformCarouselView: View {
    @Binding var platform: Platform
    let open: (Platform) -> Void

    var body: some View {
        NBPlatformCarousel(selection: $platform, open: open)
    }
}
