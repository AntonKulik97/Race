
import Foundation

enum Keys: String{
    case firstKey = "firstKey"
}

class SettingsManager {
  
    static let shared = SettingsManager()
    let defaultSettings = Settings(name: "Антон", car: "car", police: "police_car")
    let settings = Settings()
    func getSettings() -> Settings {
        if let settings = UserDefaults.standard.value(Settings.self, forKey: Keys.firstKey.rawValue){
            return settings
        }else{return defaultSettings}
    }
    
    
    func setSettings(){
        UserDefaults.standard.set(encodable: settings, forKey: Keys.firstKey.rawValue)
    }

}


