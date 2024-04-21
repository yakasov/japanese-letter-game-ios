import SwiftUI

struct LetterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
            .frame(maxWidth: 175, maxHeight: 150)
            .background(.purple)
            .cornerRadius(10)
            .font(.system(size: 32))
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .frame(maxWidth: .infinity)
            .background(.black)
            .font(.system(size: 14))
    }
}
