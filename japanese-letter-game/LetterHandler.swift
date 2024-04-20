import Foundation

public var JSONCharacters: [String: Any] = readJSONFile(path: "characters")
public var characterOrder: [String: Any] = readJSONFile(path: "characters_order")
private var currentRandomCharacters: [String] = []

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
    /// Returns a dictionary of { "row": [ {"English": "Hiragana", ...} ] }.
    let characterRowToggles: CharacterRowToggles = CharacterRowToggles()
    let enabledRows = characterRowToggles.loadCharacterRows().filter({ $0.enabled })
    return JSONCharacters.filter({ key, _ in
        enabledRows.contains { $0.id == key }
    })
}

public func getFlattenedCharacters() -> [String: Any] {
    /// Flattens the result of getAllowedCharacters() into
    /// an array of [ "English": "Hiragana", ... ] for easy picking.
    
    let shouldSwap = UserDefaults.standard.bool(forKey: "swapLanguages")
    
    return Dictionary(
        getAllowedCharacters().values
            .compactMap { value -> [[String: String]]? in
                let array = value as? [Any]
                return array?.compactMap { $0 as? [String: String] }
            }
            .joined()
            .map { dictionary in
                dictionary.map { shouldSwap ? ($0.value, $0.key) : ($0.key, $0.value) }
            }
            .joined(),
        uniquingKeysWith: { (_, last) in last }
    )
}

public func getCharacterPair() -> (String, Any) {
    return getFlattenedCharacters().randomElement()!
}

public func getRandomCharacter() -> String {
    /// Provides a single character from getFlattenedCharacters().
    /// This value is then added to a currentRandomCharacters array -
    /// it will get a different character if it is already in the array to avoid
    /// duplicate characters.
    if currentRandomCharacters.count >= 4 {
        currentRandomCharacters = []
    }
    
    let characterDictionary: [String: Any] = getFlattenedCharacters()
    var randomCharacter: String = characterDictionary.randomElement()!.value as! String
    while currentRandomCharacters.contains(randomCharacter) {
        randomCharacter = characterDictionary.randomElement()!.value as! String
    }
    currentRandomCharacters.append(randomCharacter)
    return randomCharacter
}
