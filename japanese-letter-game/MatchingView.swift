import SwiftData
import SwiftUI

struct MatchingView: View {
    
    @State var currentCharacter: String = "ありがとう"
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Text(currentCharacter)
                .accessibilityIdentifier("mainText")
                .foregroundColor(.black)
                .font(.system(size: 48))
            Spacer()
                .frame(height: 0)
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Button("Button") {
                        currentCharacter = "Button 1"
                        NSLog(JSONCharacters.description)
                        NSLog("1")
                    }
                    Spacer()
                        .frame(width: 10)
                    Button("Button 2") {
                        currentCharacter = "Button 2"
                        NSLog("2")
                    }
                }
                HStack(alignment: .center) {
                    Button("Button 3") {
                        currentCharacter = "Button 3"
                        NSLog("3")
                    }
                    Spacer()
                        .frame(width: 10)
                    Button("Button 4") {
                        currentCharacter = "Button 4"
                        NSLog("4")
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
