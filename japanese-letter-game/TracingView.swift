import SwiftUI
import UIKit

class TimerObject: ObservableObject {
    @Published var timePassed: Double = 0.0
    @Published var characterPair: (String, String) = ("", "")
    @Published var screenTouched: Bool = false
    var timer: DispatchSourceTimer?

    init() {
        setupTimer()
    }
    
    func updateScreenTouched(newVal: Bool) {
        self.screenTouched = newVal
    }

    func setCharacters() {
        self.characterPair = getCharacterPair() as! (String, String)
    }

    func setupTimer() {
        self.timer = DispatchSource.makeTimerSource()
        self.timer?.schedule(deadline: .now(), repeating: .milliseconds(100))
        self.timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.screenTouched {
                    if self.timePassed > 3.0 {
                        self.screenTouched = false
                        self.setCharacters()
                    }
                    self.timePassed += 0.1
                } else {
                    self.timePassed = 0
                }
            }
        }
        self.timer?.resume()
    }
}

struct TracingView: View {
    @ObservedObject var timer = TimerObject()

    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in timer.updateScreenTouched(newVal: false) }
            .onEnded { _ in timer.updateScreenTouched(newVal: true) }
    }
    
    init() {
        timer.setCharacters()
    }
    
    public var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Text(timer.characterPair.1)
                    .accessibilityIdentifier("mainText")
                    .foregroundColor(.gray)
                    .font(.system(size: 216))
                CanvasWrapper()
            }
            .gesture(drag)
            Spacer()
            Text(timer.characterPair.0)
                .offset(y: -100)
                .foregroundColor(.gray)
                .font(.system(size: 32))
        }
    }
}

#Preview {
    TracingView()
}
