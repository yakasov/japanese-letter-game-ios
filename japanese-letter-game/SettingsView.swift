import SwiftUI

struct CharacterRow: Identifiable, Codable, Equatable {
    var id: String
    var enabled: Bool
    var position: Int
}

class CharacterRowToggles: ObservableObject {
    @Published var characterRows: [CharacterRow] = [] {
        didSet {
            saveCharacterRows(encodable: characterRows)
        }
    }

    init() {
        let unsortedRows: [CharacterRow] = loadCharacterRows()
        self.characterRows = unsortedRows.sorted(by: { $0.position < $1.position })
    }

    private func saveCharacterRows(encodable: any Encodable) {
        if let encoded = try? JSONEncoder().encode(encodable) {
            UserDefaults.standard.set(encoded, forKey: "ChosenRows")
        }
    }

    private func loadCharacterRows() -> [CharacterRow] {
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

    @ObservedObject var characterRowToggles: CharacterRowToggles = CharacterRowToggles()
    @State var firstToggle: Bool = true
    @State private var isToggleSectionExpanded: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                List {
                    DisclosureGroup(isExpanded: $isToggleSectionExpanded) {
                        ForEach($characterRowToggles.characterRows) { $c in
                            Toggle(c.id, isOn: $c.enabled)
                        }
                        Button("Debug: Log chosen rows") {
                            NSLog(characterRowToggles.characterRows.description)
                        }
                        Button("Debug: Delete saved rows") {
                            UserDefaults.standard.removeObject(forKey: "ChosenRows")
                            NSLog("Deleted ChosenRows from UserDefaults")
                        }
                    } label: {
                        Text("Toggle Rows")
                    }

                    Section("More Settings") {
                        Text("Bosh")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
