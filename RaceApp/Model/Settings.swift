import Foundation

class Settings: NSObject,Codable{
    var name: String?
    var car: String?
    var police: String?
    
    init(name: String, car: String, police: String) {
        self.name = name
        self.car = car
        self.police = police
    }
    
    public override init() {}
    
    public enum CodingKeys: String, CodingKey {
        case name, car, police
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.car, forKey: .car)
        try container.encode(self.police, forKey: .police)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.car = try container.decodeIfPresent(String.self, forKey: .car)
        self.police = try container.decodeIfPresent(String.self, forKey: .police)
    }
    
}


