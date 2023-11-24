import Foundation

var JSONCharacters: [String: Any] = readJSONFile()

func readJSONFile() -> [String: Any] {
    do {
        if let bundlePath = Bundle.main.path(forResource: "characters", ofType: "json"),
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
