//  DMSNotificationResponse.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/08/22.
//

import Foundation

// MARK: - DMSNotification
struct DMSNotification: Codable {
    var status: String
    var status_code: Int
    var message: String?
    var data: [DMSNotificationData]
}

// MARK: - DMSNotificationData
class DMSNotificationData: NSObject, Codable {
    var id, notificationTitle, notificationDescription, notificationType, notificationURL, readNotification, redirection: String?
    var notifiedUser, workspaceID, createdBy, createdAt, updatedAt, notificationDetails: String?

    enum CodingKeys: String, CodingKey {
        case id
        case notificationTitle = "title"
        case notificationDescription = "description"
        case notificationType = "type"
        case readNotification = "read_notification"
        case notificationURL = "URL"
        case notifiedUser = "notified_user"
        case workspaceID = "workspace_id"
        case createdBy = "date"
        case createdAt
        case updatedAt
        case redirection = "no_redirection"
        case notificationDetails = "notification_details"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
        }
        notificationTitle = try container.decodeIfPresent(String.self, forKey: .notificationTitle) ?? ""
        notificationDescription = try container.decodeIfPresent(String.self, forKey: .notificationDescription) ?? ""
        notificationType = try container.decodeIfPresent(String.self, forKey: .notificationType) ?? ""
        readNotification = try container.decodeIfPresent(String.self, forKey: .readNotification) ?? ""
        notificationURL = try container.decode(String.self, forKey: .notificationURL)
        
        notifiedUser = try container.decodeIfPresent(String.self, forKey: .notifiedUser)
        workspaceID = try container.decodeIfPresent(String.self, forKey: .workspaceID)
        createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        redirection = try container.decodeIfPresent(String.self, forKey: .redirection) ?? ""
        notificationDetails = try container.decodeIfPresent(String.self, forKey: .notificationDetails) ?? ""
    
    }
}
