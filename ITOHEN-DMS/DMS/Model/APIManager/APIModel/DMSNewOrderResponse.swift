//
//  DMSNewOrderModel.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/08/22.
//

import Foundation

// MARK: - ContactsData
struct ContactsData: Codable {
    var id, name, partnerType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case partnerType = "partner_type"
    }
    
    init(id:String, name:String, partnerType:String) {
        self.id = id
        self.name = name
        self.partnerType = partnerType
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
            let value = try container.decodeIfPresent(Int.self, forKey: .partnerType)
            partnerType = value == 0 ? "" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            partnerType = try container.decodeIfPresent(String.self, forKey: .partnerType) ?? ""
        }
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
