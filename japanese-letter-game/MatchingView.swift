import SwiftData
import SwiftUI

class ButtonStrings: ObservableObject {
    @Published public var correctPair: (String, Any) = ("", "")
    @Published public var button1String: String = ""
    @Published public var button2String: String = ""
    @Published public var button3String: String = ""
    @Published public var button4String: String = ""
    @Published public var lastPair: (String, Any) = ("", "")

    init() {
        randomiseButtons()
    }

    public func randomiseButtons() {
        button1String = getRandomCharacter()
        button2String = getRandomCharacter()
        button3String = getRandomCharacter()
        button4String = getRandomCharacter()

        randomiseCorrectButton()
    }

    public func randomiseCorrectButton() {
        while correctPair.0 == lastPair.0 {
            correctPair = getCharacterPair()
        }
        lastPair = correctPair
        let randomIndex = Int.random(in: 1...4)

        switch randomIndex {
        case 1: button1String = correctPair.1 as! String
        case 2: button2String = correctPair.1 as! String
        case 3: button3String = correctPair.1 as! String
        case 4: button4String = correctPair.1 as! String
        default: button1String = "ERR"
        }
    }
}

struct MatchingView: View {
    @State public var lowerTextString: String = " "
    @ObservedObject public var buttonStrings = ButtonStrings()

    public var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Text(buttonStrings.correctPair.0)
                .foregroundColor(.black)
                .font(.system(size: 48))
            Spacer()
                .frame(height: 0)
            VStack(alignment: .center) {
                Text(lowerTextString)
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                HStack(alignment: .center) {
                    Button(action: {
                        compareCharacters(input: buttonStrings.button1String)
                    }) {
                        Text(buttonStrings.button1String)
                    }
                    .accessibilityIdentifier(
                        buttonStrings.button1String == (buttonStrings.correctPair.1 as? String)
                            ? "correctButton" : "button1")
                    Spacer()
                        .frame(width: 10)
                    Button(action: {
                        compareCharacters(input: buttonStrings.button2String)
                    }) {
                        Text(buttonStrings.button2String)
                    }
                    .accessibilityIdentifier(
                        buttonStrings.button2String == (buttonStrings.correctPair.1 as? String)
                            ? "correctButton" : "button2")
                }
                HStack(alignment: .center) {
                    Button(action: {
                        compareCharacters(input: buttonStrings.button3String)
                    }) {
                        Text(buttonStrings.button3String)
                    }
                    .accessibilityIdentifier(
                        buttonStrings.button3String == (buttonStrings.correctPair.1 as? String)
                            ? "correctButton" : "button3")
                    Spacer()
                        .frame(width: 10)
                    Button(action: {
                        compareCharacters(input: buttonStrings.button4String)
                    }) {
                        Text(buttonStrings.button4String)
                    }
                    .accessibilityIdentifier(
                        buttonStrings.button4String == (buttonStrings.correctPair.1 as? String)
                            ? "correctButton" : "button4")
                }
            }
            .buttonStyle(LetterButtonStyle())
            .offset(y: 150)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.accessibilityIdentifier("MatchingViewIdentifier")
    }

    public func compareCharacters(input: String) {
        lowerTextString =
            input == buttonStrings.correctPair.1 as! String
            ? "Correct!" : "\(buttonStrings.correctPair.0) is \(buttonStrings.correctPair.1)"
        buttonStrings.randomiseButtons()
    }
}

#Preview {
    MatchingView()
}
