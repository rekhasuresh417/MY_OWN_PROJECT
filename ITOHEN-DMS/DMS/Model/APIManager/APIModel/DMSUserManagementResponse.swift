//
//  DMSUserManagementResponse.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 09/02/21.
//

import Foundation


// MARK: - DMSGetPartnerContacts
struct DMSGetPartnerContacts: Codable {
    let status: String
    let code: Int
    let message: String
    let data: [PartnerContactsData]
}

// MARK: - PartnerContactsData
struct PartnerContactsData: Codable {
    let id, contactRole, contactInactive, contactEmail, contactName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case contactRole = "contact_role"
        case contactInactive = "contact_inactive"
        case contactEmail = "contact_email"
        case contactName = "contact_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
            id = value == 0 ? "0" : String(value)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        }
        contactRole = try container.decodeIfPresent(String.self, forKey: .contactRole) ?? ""
        contactInactive = try container.decodeIfPresent(String.self, forKey: .contactInactive) ?? ""
        contactEmail = try container.decodeIfPresent(String.self, forKey: .contactEmail) ?? ""
        contactName = try container.decodeIfPresent(String.self, forKey: .contactName) ?? ""
    }
}


// MARK: - DMSGetPartnerLists
struct DMSGetPartnerLists: Codable {
    let status: String
    let code: Int
    let message: String
    let data: PartnerListsData
}

// MARK: - PartnerListsData
struct PartnerListsData: Codable {
    let buyers, pcu, factory: [ContactsData]?
}


// MARK: - DMSAddPartnerContact
struct DMSAddPartnerContact: Codable {
    let status: String
    let code: Int
    let message: String
    let data: [DMSAddPartnerContactData]
}

// MARK: - DMSAddPartnerContactData
struct DMSAddPartnerContactData: Codable {
    let id, contactName: String

    enum CodingKeys: String, CodingKey {
        case id
        case contactName = "contact_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
            id = value == 0 ? "0" : String(value)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        }
        contactName = try container.decodeIfPresent(String.self, forKey: .contactName) ?? ""
    }
}

// MARK: - DMSContactStatus
struct DMSContactActiveStatus: Codable {
    let status: String
    let code: Int
    let message: String
    let data: NoData
}
