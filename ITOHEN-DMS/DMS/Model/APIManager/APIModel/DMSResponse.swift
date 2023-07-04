//
//  DMSResponse.swift
//  Itohen-dms
//
//  Created by Dharma on 04/01/21.
//

import Foundation

// MARK: - DMSVerifyEmailResponse
struct DMSVerifyEmailResponse: Codable  {
    var status: String
    var code: Int
    var message: String
    var data: NoData?
}

// MARK: - NoData
struct NoData: Codable {
    
}

// MARK: - DMSVerifyOTPResponse
struct DMSVerifyOTPResponse: Codable {
    var status: String
    var code: Int
    var message: String
    var data: [DMSVerifyOTPData]
}

// MARK: - VerifyOTPData
struct DMSVerifyOTPData: Codable {
    var accessToken: String
    var workspace: [DMSWorkspaceData]
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case workspace = "workspace"
    }
    
}

// MARK: - DMSVerifyEmailResponse
struct DMSRegisterResponse: Codable  {
    var status: String
    var code: Int
    var message: String
    var data: [DMSRegisterData]
}

struct DMSRegisterData: Codable {
    var firstName, lastName, email, userType, mobileNumber: String
    var companyName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case userType = "user_type"
        case companyName = "company_name"
        case mobileNumber = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .userType)
            userType = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            userType = try container.decodeIfPresent(String.self, forKey: .userType) ?? "0"
        }
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        mobileNumber = try container.decodeIfPresent(String.self, forKey: .mobileNumber) ?? ""
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName) ?? ""
    }
}

// MARK: - DMSWorkspace
struct DMSGetWorkspace: Codable {
    var status: String
    var code: Int
    var message: String
    var data: [DMSWorkspaceData]
}

// MARK: - Datum
struct DMSWorkspaceData: Codable {
    var id, workspaceTitle, contactRole, workspaceType, contactId, notifyCount: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case workspaceTitle = "workspace_title"
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
            contactRole = try container.decodeIfPresent(String.self, forKey: .contactRole) ?? ""
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
        workspaceTitle = try container.decodeIfPresent(String.self, forKey: .workspaceTitle) ?? ""
    }
}

// MARK: - DMSLogoutResponse
struct DMSGetLogoutResponse: Codable  {
    var status: String
    var code: Int
    var message: String
    var data: NoData
}

// MARK: - DMSUserInfo
struct DMSUserInfo: Codable {
    let status: String
    let code: Int
    let message: String
    let data: DMSUserInfoData
}

// MARK: - DMSUserInfoData
struct DMSUserInfoData: Codable {
    let firstName, lastName, email: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
}

// MARK: - DMSGetIOSBuildNo
struct DMSGetIOSBuildNo: Codable {
    var status: String
    var code: Int
    var message: String
    var data: DMSGetIOSBuildNoDatum
}

// MARK: - DataClass
struct DMSGetIOSBuildNoDatum: Codable {
    let buildNo: String?
}

// MARK: - DMSCreate and Rename Workspace
struct DMSEditWorkspace: Codable {
    var status: String
    var code: Int
    var message: String
}

// MARK: - NoData
struct NoData: Codable {
    
}
