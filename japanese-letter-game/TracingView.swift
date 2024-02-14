import SwiftUI
import UIKit

class TimerObject: ObservableObject {
    @Published var timePassed: Double = 0.0
    @Published var characterPair: (String, String) = ("", "")
    @Published var screenTouched: Bool = true
    var timer: DispatchSourceTimer?
    @Published var canvas: Canvas
    

    init(canvas: Canvas) {
        self.canvas = canvas;
        print(ObjectIdentifier(canvas))
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
                    if self.timePassed > 3.0 {
                        NSLog("Passed 3.0 seconds")
                        print(ObjectIdentifier(self.canvas))
                        runVisionRecognition(canvas: self.canvas)
                        NSLog("Post runMLKitRecognition")
                        self.screenTouched = true
                        self.setCharacters()
                        // self.canvas.resetPaths()
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
    
    init() {
        NSLog("Tracing init")
        let canvas = Canvas()
        print(ObjectIdentifier(canvas))
        self.timer = TimerObject(canvas: canvas)
        self.timer.setCharacters()
        
        canvas.onTouchesBegan = { [self] in timer.screenTouched = true }
        canvas.onTouchesEnded = { [self] in
            timer.screenTouched = false
            timer.canvas = canvas
        }

    }
    
    
    public var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Text(self.timer.characterPair.1)
                    .accessibilityIdentifier("mainText")
                    .foregroundColor(.gray)
                    .font(.system(size: 216))
                CanvasWrapper(canvas: self.$timer.canvas)
            }
            Spacer()
            Text(self.timer.characterPair.0)
                .offset(y: -100)
                .foregroundColor(.gray)
                .font(.system(size: 32))
        }
    }
}

#Preview {
    TracingView()
}
