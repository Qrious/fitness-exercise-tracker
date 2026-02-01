import SwiftUI
import Combine

struct TimerView: View {
    @StateObject private var timerManager = TimerManager()

    var body: some View {
        GlassCard {
            VStack(spacing: DesignConstants.spacingMedium) {
                Text("Rest Timer")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(timerManager.timeString)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()

                HStack(spacing: DesignConstants.spacingMedium) {
                    Button(timerManager.isRunning ? "Pause" : "Start") {
                        timerManager.toggleTimer()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        timerManager.reset()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

class TimerManager: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning = false

    private var timer: AnyCancellable?
    private var startTime: Date?

    var timeString: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func toggleTimer() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func start() {
        guard !isRunning else { return }

        isRunning = true
        startTime = Date().addingTimeInterval(-elapsedTime)

        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let startTime = self.startTime else { return }
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
    }

    func pause() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }

    func reset() {
        pause()
        elapsedTime = 0
        startTime = nil
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        TimerView()
            .padding()
    }
}
