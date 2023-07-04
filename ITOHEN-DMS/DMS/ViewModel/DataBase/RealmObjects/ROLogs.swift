//
//  ROLogs.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import RealmSwift

class ROLogs: Object, Codable{
    @objc dynamic var timestamp: Date? = nil
    @objc dynamic var type: String = LogType.NONE.rawValue
    @objc dynamic var tag: String = ""
    @objc dynamic var message: String = ""
    @objc dynamic var exceptionDetails: String = ""
    
    // read-only properties
    var logType:LogType{
        return LogType.init(rawValue: self.type)!
    }
    
    var asDictionary: [String: Any] {
        return [
            "timestamp" : Int32(timestamp?.timeIntervalSince1970 ?? 0),
            "type" : type,
            "tag" : tag,
            "message" : message,
            "exceptionDetails" : exceptionDetails
        ]
    }
}

enum LogType: String{
    case INFO = "Info"
    case WARNING = "Warning"
    case ERROR = "Error"
    case APIERROR = "ApiError"
    case APISUCCESS = "ApiSuccess"
    case NONE = "None"
}
