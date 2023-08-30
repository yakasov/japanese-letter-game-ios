//
//  japanese_letter_gameApp.swift
//  japanese-letter-game
//
//  Created by Angel on 30/08/2023.
//

import SwiftUI
import SwiftData

@main
struct japanese_letter_gameApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
    
    func press() {}
}
