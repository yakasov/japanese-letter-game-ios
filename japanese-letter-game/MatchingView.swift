import SwiftData
import SwiftUI

struct ButtonStrings {
    @State public var button1String: String
    @State public var button2String: String
    @State public var button3String: String
    @State public var button4String: String
}

struct MatchingView: View {

    @State private var currentCharacter: String = "ありがとう"
    @State private var lowerTextString: String = "Lower Text"

    @State private var buttonStrings = ButtonStrings(
        button1String: "ありがとう",
        button2String: "Button 2",
        button3String: "Button 3",
        button4String: "Button 4")

    public var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Text(currentCharacter)
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
                    Button(buttonStrings.button1String) {
                        lowerTextString =
                            "\(buttonStrings.button1String == currentCharacter)"
                    }
                    Spacer()
                        .frame(width: 10)
                    Button(buttonStrings.button2String) {
                        lowerTextString =
                            "\(buttonStrings.button2String == currentCharacter)"
                    }
                }
                HStack(alignment: .center) {
                    Button(buttonStrings.button3String) {
                        lowerTextString =
                            "\(buttonStrings.button3String == currentCharacter)"
                    }
                    Spacer()
                        .frame(width: 10)
                    Button(buttonStrings.button4String) {
                        lowerTextString =
                            "\(buttonStrings.button4String == currentCharacter)"
                    }
                }
            }
            .buttonStyle(LetterButtonStyle())
            .offset(y: 150)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MatchingView()
}
