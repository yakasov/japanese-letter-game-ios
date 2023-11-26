import Foundation

public var JSONCharacters: [String: Any] = readJSONFile(path: "characters")
public var characterOrder: [String: Any] = readJSONFile(path: "characters_order")
public var allowedCharacters: [String: Any] = getAllowedCharacters()

private func readJSONFile(path: String) -> [String: Any] {
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

public func getAllowedCharacters() -> [String: Any] {
    return [:]
}

public func getCharacterPair() -> (String, String) {
    return ("","")
}

public func getRandomCharacter() -> String {
    return ""
}
