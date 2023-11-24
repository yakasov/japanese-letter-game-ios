import SwiftUI

struct CharacterRow: Identifiable {
    var id: String
    var enabled: Bool = true
}

struct SettingsView: View {
    
    @State var characterRows = JSONCharacters.keys.map {
        CharacterRow(id: $0) }
    @State var firstToggle: Bool = true
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Selectable Rows") {
                        ForEach($characterRows) { c in
                            Toggle(c.id, isOn: c.enabled)
                        }
                        Button("Debug: Log chosen rows") {
                            NSLog(characterRows.description)
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

#Preview {
    SettingsView()
}

