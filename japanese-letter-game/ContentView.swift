//
//  ContentView.swift
//  japanese-letter-game
//
//  Created by Angel on 30/08/2023.
//

import SwiftData
import SwiftUI

struct LetterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
            .frame(maxWidth: 175, maxHeight: 150)
            .background(.purple)
            .cornerRadius(10)
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

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0.0) {
                Text("ありがとう")
                    .accessibilityIdentifier("mainText")
                    .foregroundColor(.black)
                    .font(.system(size: 48))
                Spacer()
                    .frame(height: 0)
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Button("Button") {
                            NSLog("1")
                        }
                        Spacer()
                            .frame(width: 10)
                        Button("Button 2") {
                            NSLog("2")
                        }
                    }
                    HStack(alignment: .center) {
                        Button("Button 3") {
                            NSLog("3")
                        }
                        Spacer()
                            .frame(width: 10)
                        Button("Button 4") {
                            NSLog("4")
                        }
                    }
                }
                .buttonStyle(LetterButtonStyle())
                .offset(y: 150)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("Matching") {}
                    Spacer()
                    Button("Tracing") {}
                    Spacer()
                    Button("Pairing") {}
                    Spacer()
                    HStack {
                        Divider()
                            .frame(width: 1)
                            .background(.black)
                        Button("Settings") {}
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
