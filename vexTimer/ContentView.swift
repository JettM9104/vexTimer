import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var timer: Timer? = nil
    @State private var timeRemaining: Int = 0
    @State private var isRunning: Bool = false
    @State private var initialTime: Int = 60  // Default 60 seconds

    // Dictionary to keep multiple players for overlapping sounds
    @State private var audioPlayers: [String: AVAudioPlayer] = [:]

    var body: some View {
        VStack(spacing: 20) {
            Text("\(timeFormatted(timeRemaining))")
                .font(.system(size: 120))

            HStack(spacing: 30) {
                Button(action: startTimer) {
                    Image(systemName: "play.fill")
                        .font(.title)
                }

                Button(action: pauseTimer) {
                    Image(systemName: "pause.fill")
                        .font(.title)
                }

                Button(action: stopTimer) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                }

                Button(action: skipToZero) {
                    Image(systemName: "forward.end.fill")
                        .font(.title)
                }
            }

            Stepper("Set Timer: \(initialTime) sec", value: $initialTime, in: 10...600, step: 5)
        }
        .padding()
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        if timeRemaining == 0 {
            timeRemaining = initialTime
        }

        playSound(name: "sound1")
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1
            
            if timeRemaining == 35 || timeRemaining == 25 {
                playSound(name: "sound2")
            }

            if timeRemaining <= 0 {
                stopTimer()
            }
        }
    }

    func pauseTimer() {
        if isRunning {
            playSound(name: "sound4")
        }
        timer?.invalidate()
        isRunning = false
    }

    func stopTimer() {
        playSound(name: "sound3")
        timer?.invalidate()
        timeRemaining = 0
        isRunning = false
    }

    func skipToZero() {
        playSound(name: "sound5")
        timer?.invalidate()
        timeRemaining = 0
        isRunning = false
    }

    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file not found: \(name).mp3")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.play()

            // Keep reference so the player stays alive
            audioPlayers[name] = player
        } catch {
            print("Could not load sound file.")
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
