//
//  RMLogs.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import RealmSwift

class RMLogs: NSObject {
    
    static let shared = RMLogs.init()
    
    func log(type:LogType, tag:String, message:String, exceptionDetails:String = ""){
        
        let realm = try! Realm()
        let log = ROLogs.init()
        log.timestamp = Date()
        log.type = type.rawValue
        log.tag = tag
        log.message = message
        log.exceptionDetails = exceptionDetails
        do {
            try realm.safeWrite(){
                realm.add(log)
            }
        }catch {
            print("RMLogs->log->Write Error = \(error)")
        }
    }
    
    func getAllLogs() -> Results<ROLogs>{
        let realm = try! Realm()
        return realm.objects(ROLogs.self).sorted(byKeyPath: "timestamp", ascending: true)
    }
    
    func removeAllLogs(){
        let realm = try! Realm()
        let logs = realm.objects(ROLogs.self)
        do {
            try realm.safeWrite {
                realm.delete(logs)
            }
        }catch {
            print("RMLogs->removeAllLogs->Write Error = \(error)")
        }
    }
}
