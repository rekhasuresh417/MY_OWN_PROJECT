//
//  RMConfiguration.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import RealmSwift

class RMConfiguration: NSObject {
    
    static let shared = RMConfiguration()
    
    private let realm = try! Realm()
    
    private override init() { }
    
    private var config: ROConfiguration {
        get {
            var firstRow = realm.objects(ROConfiguration.self).first
            if firstRow == nil {
                try? realm.safeWrite {
                    realm.add(ROConfiguration())
                }
                firstRow = realm.objects(ROConfiguration.self).first
            }
            return firstRow!
        }
    }
  
    var language: String {
        set { try! realm.write { config.language = newValue }; LocalizationManager.loadLocalizableStrings() }
        get { return config.language }
    }
  
    var languageId: String {
        set { try! realm.write { config.languageId = newValue }; LocalizationManager.loadLocalizableStrings() }
        get { return config.languageId }
    }
    
    var accessToken: String {
        set { try! realm.write { config.accessToken = newValue } }
        get { return config.accessToken }
    }
    
    var loginType: String {
        set { try! realm.write { config.loginType = newValue } }
        get { return config.loginType }
    }
   
    var email: String {
        set { try! realm.write { config.email = newValue } }
        get { return config.email }
    }
    
    var roleId: String {
        set { try! realm.write { config.roleId = newValue } }
        get { return config.roleId }
    }
    
    var role: String {
        set { try! realm.write { config.role = newValue } }
        get { return config.role }
    }
    
    var userId: String {
        set { try! realm.write { config.userId = newValue } }
        get { return config.userId }
    }
    
    var orderId: String {
        set { try! realm.write { config.orderId = newValue } }
        get { return config.orderId }
    }
    
    var userName: String {
        set { try! realm.write { config.userName = newValue } }
        get { return config.userName }
    }
    
    var staffId: String {
        set { try! realm.write { config.staffId = newValue } }
        get { return config.staffId }
    }
    
    var companyId: String {
        set { try! realm.write { config.companyId = newValue } }
        get { return config.companyId }
    }
    
    var workspaceId: String {
        set { try! realm.write { config.workspaceId = newValue } }
        get { return config.workspaceId }
    }
 
    var workspaceName: String {
        set { try! realm.write { config.workspaceName = newValue } }
        get { return config.workspaceName }
    }
    
    var workspaceType: String {
        set { try! realm.write { config.workspaceType = newValue } }
        get { return config.workspaceType }
    }
   
    var dateFormat: String {
        set { try! realm.write { config.dateFormat = newValue } }
        get { return config.dateFormat }
    }
    
    var awsURL: String {
        set { try! realm.write { config.awsURL = newValue } }
        get { return config.awsURL }
    }
    
    var notifyCount: String {
        set { try! realm.write { config.notifyCount = newValue } }
        get { return config.notifyCount }
    }
    
    func deleteAllRealmObjects(completion: @escaping ()->Void = {}){
        do {
            try realm.write {
                realm.deleteAll()
                realm.add(ROConfiguration())
            }
        } catch {
            print("RMConfiguration->deleteAllRealmObjects->Write Error = \(error)")
        }
        completion()
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}

