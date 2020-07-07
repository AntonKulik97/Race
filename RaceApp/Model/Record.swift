import Foundation


class Record: NSObject,Codable{

    
    var name: String?
    var score: Int?
    var date: String?
    
    init(name: String, score:Int, date: String ) {
        self.name = name
        self.score = score
        self.date = date
    }
    
    public override init() {}
       
       public enum CodingKeys: String, CodingKey {
           case name, score, date
    }
    public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          
          try container.encode(self.name, forKey: .name)
          try container.encode(self.score, forKey: .score)
          try container.encode(self.date, forKey: .date)
      }
      
      required public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          
          self.name = try container.decodeIfPresent(String.self, forKey: .name)
          self.score = try container.decodeIfPresent(Int.self, forKey: .score)
          self.date = try container.decodeIfPresent(String.self, forKey: .date)
      }
}
