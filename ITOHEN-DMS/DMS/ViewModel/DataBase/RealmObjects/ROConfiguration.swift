//
//  ROConfiguration.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import RealmSwift

class ROConfiguration: Object, Codable{
    
    @objc dynamic var language: String = "en" // default language
    @objc dynamic var languageId: String = "1" // default language code
    @objc dynamic var accessToken: String = ""
    @objc dynamic var loginType: String = Config.Text.user
    @objc dynamic var email: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var orderId: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var staffId: String = ""
    @objc dynamic var role: String = ""
    @objc dynamic var roleId: String = ""
    @objc dynamic var companyId: String = ""
    @objc dynamic var workspaceId: String = ""
    @objc dynamic var workspaceName: String = ""
    @objc dynamic var workspaceType: String = ""
    @objc dynamic var awsURL: String = ""
    @objc dynamic var dateFormat: String = "dd MMM yyyy"
    @objc dynamic var notifyCount: String = "0"
}
