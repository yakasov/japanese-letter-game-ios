import SwiftUI

struct CharacterRow: Identifiable, Codable, Equatable {
    var id: String
    var enabled: Bool
}

struct SettingsView: View {

    @State var characterRows: [CharacterRow] = loadCharacterRows()
    @State var firstToggle: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Selectable Rows") {
                        ForEach($characterRows) { c in
                            Toggle(c.id, isOn: c.enabled)
                                .onChange(of: characterRows) {
                                    NSLog("Saving \(c)")
                                    saveCharacterRows(encodable: characterRows)
                                }
                        }
                        Button("Debug: Log chosen rows") {
                            NSLog(characterRows.description)
                        }
                        Button("Debug: Log load results") {
                            NSLog("\(loadCharacterRows())")
                        }
                    }

                    Section("More Settings") {
                        Text("Bosh")
                    }
                }
            }
        }
    }
}

func saveCharacterRows(encodable: any Encodable) {
    if let encoded = try? JSONEncoder().encode(encodable) {
        UserDefaults.standard.setValue(encoded, forKey: "ChosenRows")
    }
}

func loadCharacterRows() -> [CharacterRow] {
    @State var loadedRows: [CharacterRow] = []

    if let data = UserDefaults.standard.object(forKey: "ChosenRows") as? Data {
        if let chosenRows = try? JSONDecoder().decode([CharacterRow].self, from: data) {
            loadedRows = chosenRows
        }
    }

    if loadedRows.count == 0 {
        NSLog("No previous settings!")
        return JSONCharacters.keys.map {
            CharacterRow(id: $0, enabled: true)
        }
    }
    return loadedRows
}

#Preview {
    SettingsView()
}
