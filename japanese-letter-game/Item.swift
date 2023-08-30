//
//  Item.swift
//  japanese-letter-game
//
//  Created by Angel on 30/08/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
