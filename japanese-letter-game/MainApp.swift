import SwiftData
import SwiftUI

@main
struct MainApp: App {

    @State private var currentView: String = "MatchingView"
    public var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack {
                    switch currentView {
                    case "MatchingView": MatchingView()
                    case "TracingView": TracingView()
                    case "PairingView": PairingView()
                    case "SettingsView": SettingsView()
                    default: MatchingView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button("Matching") {
                            currentView = "MatchingView"
                        }
                        Spacer()
                        Button("Tracing") {
                            currentView = "TracingView"
                        }
                        Spacer()
                        Button("Pairing") {
                            currentView = "PairingView"
                        }
                        Spacer()
                        HStack {
                            Divider()
                                .frame(width: 1)
                                .background(.black)
                            Button("Settings") {
                                currentView = "SettingsView"
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
