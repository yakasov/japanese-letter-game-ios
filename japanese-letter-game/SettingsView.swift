import SwiftUI

struct CharacterRow: Identifiable, Codable, Equatable {
    var id: String
    var enabled: Bool
    var position: Int
}

class CharacterRowToggles: ObservableObject {
    @Published public var characterRows: [CharacterRow] = [] {
        didSet {
            saveCharacterRows(encodable: characterRows)
        }
    }

    public init() {
        let unsortedRows: [CharacterRow] = loadCharacterRows()
        self.characterRows = unsortedRows.sorted(by: { $0.position < $1.position })
    }

    private func saveCharacterRows(encodable: any Encodable) {
        if let encoded = try? JSONEncoder().encode(encodable) {
            UserDefaults.standard.set(encoded, forKey: "ChosenRows")
        }
    }

    public func loadCharacterRows() -> [CharacterRow] {
        @State var loadedRows: [CharacterRow]

        if let data = UserDefaults.standard.object(forKey: "ChosenRows") as? Data {
            let chosenRows = try? JSONDecoder().decode([CharacterRow].self, from: data)
            if chosenRows?.count == 0 {
                return JSONCharacters.keys.map {
                    CharacterRow(id: $0, enabled: true, position: characterOrder[$0] as! Int)
                }
            }
            return chosenRows!
        }

        return []
    }
}

struct SettingsView: View {

    @ObservedObject private var characterRowToggles: CharacterRowToggles = CharacterRowToggles()
    @State private var isToggleSectionExpanded: Bool = false
    @State private var swapLanguages: Bool = false

    public var body: some View {
        NavigationView {
            VStack {
                List {
                    DisclosureGroup(isExpanded: $isToggleSectionExpanded) {
                        ForEach($characterRowToggles.characterRows) { $c in
                            Toggle(c.id, isOn: $c.enabled)
                        }
                    } label: {
                        Text("Show row choices")
                    }
                    Button("Debug: Log chosen rows") {
                        NSLog(characterRowToggles.characterRows.description)
                    }
                    Button("Debug: Delete saved rows") {
                        UserDefaults.standard.removeObject(forKey: "ChosenRows")
                        NSLog("Deleted ChosenRows from UserDefaults")
                    }
                    Button("Debug: Log JSONCharacters") {
                        NSLog("\(JSONCharacters)")
                    }
                    Button("Debug: Log AllowedCharacters") {
                        NSLog("\(getAllowedCharacters())")
                    }
                    Button("Debug: Log FlattenedCharacters") {
                        NSLog("\(getFlattenedCharacters())")
                    }

                    Section("More Settings") {
                        Toggle("Swap English and Japanese", isOn: Binding(
                            get: { UserDefaults.standard.bool(forKey: "swapLanguages") },
                            set: { newValue in
                                UserDefaults.standard.set(newValue, forKey: "swapLanguages")
                                swapLanguages = newValue
                            }
                        ))
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
