import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: StatisticsViewModel(context: context))
    }

    var body: some View {
        ZStack {
            // Modern light background
            Color.lightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                GlassCard(backgroundColor: .white) {
                    Text("Statistics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.darkText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.top)

                if viewModel.workouts.isEmpty {
                    emptyStateView
                } else {
                    statisticsContent
                }
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: DesignConstants.spacingLarge) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("No Statistics Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Complete workouts to see your progress")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }

    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: DesignConstants.spacingLarge) {
                // Summary Stats
                GlassCard(backgroundColor: .white) {
                    VStack(spacing: DesignConstants.spacingMedium) {
                        Text("Overall Stats")
                            .font(.headline)
                            .foregroundStyle(Color.darkText)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: DesignConstants.spacingLarge) {
                            StatisticView(
                                value: "\(viewModel.totalWorkouts)",
                                label: "Workouts"
                            )

                            StatisticView(
                                value: "\(viewModel.totalSets)",
                                label: "Total Sets"
                            )

                            StatisticView(
                                value: "\(Int(viewModel.totalVolume))",
                                label: "Total Volume"
                            )
                        }
                    }
                }

                // Volume Over Time
                if !viewModel.volumeOverTime().isEmpty {
                    GlassCard(backgroundColor: .white) {
                        VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                            Text("Volume Over Time")
                                .font(.headline)
                                .foregroundStyle(Color.darkText)

                            Chart(viewModel.volumeOverTime()) { dataPoint in
                                LineMark(
                                    x: .value("Day", dataPoint.dayNumber),
                                    y: .value("Volume", dataPoint.volume)
                                )
                                .foregroundStyle(Color.primaryBlue)
                                .interpolationMethod(.catmullRom)

                                AreaMark(
                                    x: .value("Day", dataPoint.dayNumber),
                                    y: .value("Volume", dataPoint.volume)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.primaryBlue.opacity(0.3), Color.primaryBlue.opacity(0.05)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .interpolationMethod(.catmullRom)
                            }
                            .frame(height: 200)
                            .chartXAxis {
                                AxisMarks(position: .bottom)
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading)
                            }
                        }
                    }
                }

                // Exercise Progress
                if !viewModel.exerciseNames.isEmpty {
                    GlassCard(backgroundColor: .white) {
                        VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                            Text("Exercise Progress")
                                .font(.headline)
                                .foregroundStyle(Color.darkText)

                            Picker("Exercise", selection: $viewModel.selectedExercise) {
                                ForEach(viewModel.exerciseNames, id: \.self) { name in
                                    Text(name).tag(name as String?)
                                }
                            }
                            .pickerStyle(.menu)

                            if let selectedExercise = viewModel.selectedExercise {
                                ProgressChartView(
                                    exerciseName: selectedExercise,
                                    dataPoints: viewModel.progressionDataForExercise(selectedExercise)
                                )
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    StatisticsView(context: PersistenceController.preview.container.viewContext)
}
