import Foundation

final class OAuth2TokenStorage {

    private enum Keys: String {
        case bearerToken
    }

    private let userDefaults = UserDefaults.standard
    var token: String? {
        get {
            loadUserDefaults(for: .bearerToken, as: String.self)
        }
        set {
            saveUserDefaults(value: newValue, at: .bearerToken)
        }
    }

    private func loadUserDefaults<T: Codable>(for key: Keys, as dataType: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let count = try? JSONDecoder().decode(dataType.self, from: data) else {
            return nil
        }
        return count
    }

    private func saveUserDefaults<T: Codable>(value: T, at key: Keys) {
        guard let data = try? JSONEncoder().encode(value) else {
            print("Can't save data to UserDefaults")
            return
        }
        userDefaults.set(data, forKey: key.rawValue)
    }
}
