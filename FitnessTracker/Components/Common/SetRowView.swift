import SwiftUI

/// Row view for displaying a workout set
struct SetRowView: View {
    let setNumber: Int
    let weight: Double
    let reps: Int16
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text("Set \(setNumber)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .leading)

            Spacer()

            HStack(spacing: DesignConstants.spacingMedium) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(weight))")
                        .font(.headline)
                        .foregroundStyle(Color.darkText)
                    Text("kg")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 60, alignment: .trailing)

                Text("×")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(reps)")
                        .font(.headline)
                        .foregroundStyle(Color.darkText)
                    Text("reps")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 60, alignment: .trailing)
            }

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .imageScale(.medium)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, DesignConstants.spacingSmall)
    }
}

#Preview {
    VStack {
        SetRowView(setNumber: 1, weight: 135, reps: 10) {}
        SetRowView(setNumber: 2, weight: 185, reps: 8) {}
        SetRowView(setNumber: 3, weight: 225, reps: 5) {}
    }
    .padding()
}
