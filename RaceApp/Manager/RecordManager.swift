import Foundation

enum RecordKeys: String{
    case recordKey = "recordKey"
}

class RecordManager {
    
    static let shared = RecordManager()
    
    let defaultRecord = [Record(name: "Антон", score: 100, date: "")]
    let record = [Record()]
    func getRecords() -> [Record] {
        if let record = UserDefaults.standard.value([Record].self, forKey: RecordKeys.recordKey.rawValue){
            return record
        }else{return defaultRecord}
    }
    
    
    func setRecords(){
        UserDefaults.standard.set(encodable: [record], forKey: RecordKeys.recordKey.rawValue)
    }

    
}
