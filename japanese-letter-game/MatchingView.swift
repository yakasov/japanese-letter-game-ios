import SwiftData
import SwiftUI

class ButtonStrings: ObservableObject {
    @Published public var correctPair: (String, Any) = ("", "")
    @Published public var button1String: String = ""
    @Published public var button2String: String = ""
    @Published public var button3String: String = ""
    @Published public var button4String: String = ""

    init() {
        randomiseButtons()
    }

    public func randomiseButtons() {
        button1String = getRandomCharacter() as! String
        button2String = getRandomCharacter() as! String
        button3String = getRandomCharacter() as! String
        button4String = getRandomCharacter() as! String

        randomiseCorrectButton()
    }

    public func randomiseCorrectButton() {
        correctPair = getCharacterPair()
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

    @State public var lowerTextString: String = "..."
    @ObservedObject public var buttonStrings = ButtonStrings()

    public var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Text(buttonStrings.correctPair.0)
                .accessibilityIdentifier("mainText")
                .foregroundColor(.black)
                .font(.system(size: 48))
            Spacer()
                .frame(height: 0)
            VStack(alignment: .center) {
                Text(lowerTextString)
                    .accessibilityIdentifier("lowerText")
                    .foregroundColor(.black)
                HStack(alignment: .center) {
                    Button(action: {
                        compareCharacters(input: buttonStrings.button1String)
                    }) {
                        Text(buttonStrings.button1String)
                    }
                    Spacer()
                        .frame(width: 10)
                    Button(action: {
                        compareCharacters(input: buttonStrings.button2String)
                    }) {
                        Text(buttonStrings.button2String)
                    }
                }
                HStack(alignment: .center) {
                    Button(action: {
                        compareCharacters(input: buttonStrings.button3String)
                    }) {
                        Text(buttonStrings.button3String)
                    }
                    Spacer()
                        .frame(width: 10)
                    Button(action: {
                        compareCharacters(input: buttonStrings.button4String)
                    }) {
                        Text(buttonStrings.button4String)
                    }
                }
            }
            .buttonStyle(LetterButtonStyle())
            .offset(y: 150)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    public func compareCharacters(input: String) {
        lowerTextString = String(
            "\(buttonStrings.correctPair) -> \(input == buttonStrings.correctPair.1 as! String)")
        buttonStrings.randomiseButtons()
    }
}

#Preview {
    MatchingView()
}
