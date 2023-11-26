import Foundation

var JSONCharacters: [String: Any] = readJSONFile(path: "characters")
var characterOrder: [String: Any] = readJSONFile(path: "characters_order")
var allowedCharacters: [String: Any] = getAllowedCharacters()

func readJSONFile(path: String) -> [String: Any] {
    do {
        if let bundlePath = Bundle.main.path(forResource: path, ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
        {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                as? [String: Any]
            {
                return json
            }
        }
    } catch {
        return [:]
    }
    return [:]
}

func getAllowedCharacters() -> [String: Any] {
    return [:]
}

func getCharacterPair() -> (String, String) {
    return ("","")
}

func getRandomCharacter() -> String {
    return ""
}
