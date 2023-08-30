//
//  ContentView.swift
//  japanese-letter-game
//
//  Created by Angel on 30/08/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack() {
            Text("Text")
                .accessibilityIdentifier("mainText")
            Spacer()
                
            VStack() {
                ControlGroup {
                    Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/, action: button1)
                        .accessibilityIdentifier("button1")
                    Button("Button 2", action: button2)
                        .accessibilityIdentifier("button2")
                }
                ControlGroup {
                    Button("Button 3", action: button3)
                        .accessibilityIdentifier("button3")
                    Button("Button 4", action: button4)
                        .accessibilityIdentifier("button4")
                }
            }
        }
    }
    
    func button1() {NSLog("1")}
    func button2() {NSLog("2")}
    func button3() {NSLog("3")}
    func button4() {NSLog("4")}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
