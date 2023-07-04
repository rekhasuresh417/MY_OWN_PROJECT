//
//  DMSWorkspaceModel.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/08/22.
//

import Foundation

// MARK: - WorkspaceDetails
class WorkspaceDetails{
    var workspaceList:[DMSWorkspaceList] = []
    var currentWorkspace: DMSWorkspaceList?
}

// MARK: - DMSGetWorkspace
struct DMSGetWorkspace: Codable {
    var status: String?
    var message: String?
    var status_code: Int?
    var data: [DMSWorkspaceData]?
}

// MARK: - DMSWorkspaceData
struct DMSWorkspaceData: Codable {
    var id, name, contactRole, workspaceType, contactId, notifyCount: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case contactRole = "contact_role"
        case workspaceType = "workspace_type"
        case contactId = "contact_id"
        case notifyCount = "notifyCount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .contactRole)
            contactRole = value == 0 ? "" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            contactRole = try container.decodeIfPresent(String.self, forKey: .contactRole) ?? "Admin"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .contactId)
            contactId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            contactId = try container.decodeIfPresent(String.self, forKey: .contactId) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .workspaceType)
            workspaceType = value == 0 ? "" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            workspaceType = try container.decodeIfPresent(String.self, forKey: .workspaceType) ?? ""
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .notifyCount)
            notifyCount = value == 0 ? "" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            notifyCount = try container.decodeIfPresent(String.self, forKey: .notifyCount) ?? ""
        }
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
