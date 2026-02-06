import SwiftUI
import Charts

struct ProgressChartView: View {
    let exerciseName: String
    let dataPoints: [ProgressDataPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
            if dataPoints.isEmpty {
                Text("No data available for this exercise")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, DesignConstants.spacingXLarge)
            } else {
                // Max Weight Chart
                VStack(alignment: .leading, spacing: DesignConstants.spacingSmall) {
                    Text("Max Weight Progression")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Chart(dataPoints) { dataPoint in
                        LineMark(
                            x: .value("Day", dataPoint.dayNumber),
                            y: .value("Weight", dataPoint.maxWeight)
                        )
                        .foregroundStyle(Color.primaryBlue)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Day", dataPoint.dayNumber),
                            y: .value("Weight", dataPoint.maxWeight)
                        )
                        .foregroundStyle(Color.primaryBlue)
                    }
                    .frame(height: 150)
                    .chartXAxis {
                        AxisMarks(position: .bottom)
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }

                // Personal Record
                if let maxWeight = dataPoints.map({ $0.maxWeight }).max() {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(Color.accentYellow)
                        Text("Personal Record: \(Int(maxWeight)) kg")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.darkText)
                    }
                    .padding(.vertical, DesignConstants.spacingSmall)
                }
            }
        }
    }
}

#Preview {
    let sampleData = [
        ProgressDataPoint(date: Date(), dayNumber: 1, averageWeight: 135, maxWeight: 135, totalVolume: 1350),
        ProgressDataPoint(date: Date().addingTimeInterval(86400), dayNumber: 2, averageWeight: 140, maxWeight: 145, totalVolume: 1400),
        ProgressDataPoint(date: Date().addingTimeInterval(172800), dayNumber: 3, averageWeight: 145, maxWeight: 155, totalVolume: 1500)
    ]

    GlassCard {
        ProgressChartView(exerciseName: "Bench Press", dataPoints: sampleData)
    }
    .padding()
}
