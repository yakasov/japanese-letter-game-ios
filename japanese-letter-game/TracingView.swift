import SwiftUI
import UIKit
import Combine

class TimerObject: ObservableObject {
    @Published var timePassed: Double = 0.0
    @Published var characterPair: (String, String) = ("", "")
    @Published var result: String = ""
    @Published var screenTouched: Bool = true
    var timer: DispatchSourceTimer?
    var canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
        setupTimer()
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
                if !self.screenTouched {
                    if self.timePassed > 1.5 {
                        runVisionRecognition(canvas: self.canvas) { [weak self] (topCandidateString) in
                            guard let topCandidateString = topCandidateString else {
                                self?.result = "_"
                                return
                            }
                            self?.result =  topCandidateString
                        }
                        self.screenTouched = true
                        self.setCharacters()
                        self.canvas.resetPaths()
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
    @ObservedObject var timer: TimerObject
    @State var canvas = Canvas()
    @State var resultText: String = ""
    @State var firstRun: Bool = true
    @State var correctInARow: Int = 0

    init() {
        let canvas = Canvas()
        self.timer = TimerObject(canvas: canvas)
        self.timer.setCharacters()
        canvas.onTouchesBegan = { [self] in timer.screenTouched = true }
        canvas.onTouchesEnded = { [self] in timer.screenTouched = false }
        _canvas = State<Canvas>(initialValue: canvas)
    }

    public var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Text(self.correctInARow >= 3 ? "" : self.timer.characterPair.1)
                    .accessibilityIdentifier("mainText")
                    .foregroundColor(.gray)
                    .background(.clear)
                    .font(.system(size: 256))
                CanvasWrapper(canvas: $canvas)
            }
            Spacer()
            VStack {
                Text(self.timer.characterPair.0)
                    .offset(y: -100)
                    .foregroundColor(.gray)
                    .font(.system(size: 32))
                Text(resultText)
                    .onReceive(timer.$result) { newValue in
                        if self.firstRun {
                            self.firstRun = false
                        } else {
                            if newValue.lowercased().contains(self.timer.characterPair.1.lowercased()) {
                                self.resultText = "Vision sees \(self.timer.characterPair.1)!"
                                self.correctInARow += 1
                            } else {
                                self.resultText = "Vision does not see \(self.timer.characterPair.1)."
                                self.correctInARow = 0
                            }
                        }
                    }
                .offset(y: -90)
                .foregroundColor(.gray)
                .font(.system(size: 32))
            }
        }
        .accessibilityIdentifier("TracingViewIdentifier")
    }
}
