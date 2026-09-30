import SwiftUI

struct CurrentRoutineCard: View {
    let routine: Routine?

    var body: some View {
        NBCard(padding: NBSpacing.standard) {
            HStack(spacing: NBSpacing.standard) {
                Image(systemName: routine?.strictMode.isEnabled == true ? "lock.shield.fill" : "clock.badge.checkmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(routine?.strictMode.isEnabled == true ? NBColor.warning : Color.accentColor)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Current Routine").font(.caption).foregroundStyle(NBColor.secondaryText)
                    Text(routine?.name ?? "No scheduled routine").font(.subheadline.weight(.semibold))
                }
                Spacer()
                Text(routine?.strictMode.isEnabled == true ? "Strict" : "Normal")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
    }
}
