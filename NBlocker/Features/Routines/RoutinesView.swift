import SwiftUI

struct RoutinesView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        List {
            ForEach(environment.routines.routines) { routine in
                VStack(alignment: .leading, spacing: 4) {
                    Text(routine.name).font(.headline)
                    Text(routine.isEnabled ? "Enabled" : "Disabled")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
                .listRowBackground(NBColor.card)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Routines")
    }
}
