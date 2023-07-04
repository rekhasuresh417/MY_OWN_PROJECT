//
//  LoginSuccessModel.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 28/07/22.
//

import Foundation
import RealmSwift

// MARK: - DMSValidateOTP
struct DMSValidateOTP: Codable {
    var status_code: Int?
    var message: String?
    var login_type: String?
    var language: String?
    var language_id: Int?
    var email: String?
    var role: String?
    var token: String?
    var user_id: Int?
    var user_name: String?
    var first_name: String?
    var last_name: String?
    var staff_id: Int?
    var workspaceName: String?
    var workspaceType: String?
    var workspace_id: Int?
    var company_id: Int?
    var country: String?
    
    var dateformat: String?
    var workspacesList: [DMSWorkspaceList]?
    var permissions: [String]?
    var module: [String]?
}

// MARK: - DMSWorkspaceList
class DMSWorkspaceList: NSObject, Codable{
    var userId, staffId, companyId, workspaceId, roleId: String?
    var role, workspaceName, workspaceType, dateformat: String?
    var permissions: [String]?
    var modules: [String]?
 
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case staffId = "staff_id"
        case companyId = "company_id"
        case workspaceId = "workspace_id"
        case permissions = "permission"
        case modules = "module"
        case roleId
        case role, workspaceName, workspaceType, dateformat
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .userId)
            userId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .staffId)
            staffId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            staffId = try container.decodeIfPresent(String.self, forKey: .staffId) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .companyId)
            companyId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            companyId = try container.decodeIfPresent(String.self, forKey: .companyId) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .workspaceId)
            workspaceId = value == 0 ? "" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            workspaceId = try container.decodeIfPresent(String.self, forKey: .workspaceId) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .roleId)
            roleId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            roleId = try container.decodeIfPresent(String.self, forKey: .roleId) ?? "0"
        }
    
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
        workspaceName = try container.decodeIfPresent(String.self, forKey: .workspaceName) ?? ""
        workspaceType = try container.decodeIfPresent(String.self, forKey: .workspaceType) ?? ""
        dateformat = try container.decodeIfPresent(String.self, forKey: .dateformat) ?? ""
        
        permissions = try container.decodeIfPresent([String].self, forKey: .permissions) ?? []
        modules = try container.decodeIfPresent([String].self, forKey: .modules) ?? []
    }
    
}


