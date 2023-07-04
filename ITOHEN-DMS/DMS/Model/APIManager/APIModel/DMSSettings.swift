//
//  DMSSettings.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 09/11/22.
//

import Foundation

// MARK: - DMSSettingsResponse
struct DMSSettingsResponse: Codable {
    var status: String?
    var status_code: Int?
    var message: String?
    var data: DMSSettingsData?
}

// MARK: - DMSSettingsData
class DMSSettingsData: NSObject, Codable{
    var generalSetting: DMSGeneralSettings?
    var notificationSettings: [DMSNotificationSettings]?
    var emailScheduleSettings: [DMSEmailScheduleSettings]?
    var selectedGeneralSettings: DMSSelectedGeneralSettings?
    var selectedNotificationSettings: DMSSelectedNotificationSettings?
    var selectedEmailScheduleSettings: DMSSelectedEmailScheduleSettings?
    var dashboardSettings: [DMSDashboardSettings]?
    
    enum CodingKeys: String, CodingKey {
        case generalSetting = "general_settings"
        case notificationSettings = "notification_settings"
        case emailScheduleSettings = "email_schedule_settings"
        case selectedGeneralSettings = "selected_general_settings"
        case selectedNotificationSettings = "selected_notification_settings"
        case selectedEmailScheduleSettings = "selected_email_schedule_settings"
        case dashboardSettings = "dashboardSettings"
    }
}

// MARK: - DMSGeneralSettings
struct DMSGeneralSettings: Codable{
    var dateformat: [DMSDateFormat]?
    var timezoneformat: [DMSTimeZoneFormat]?
}

// MARK: - DMSSelectedGeneralSettings
struct DMSSelectedGeneralSettings: Codable{
    var dateFormat, timeZoneFormat: String?

    enum CodingKeys: String, CodingKey {
        case dateFormat = "date_format"
        case timeZoneFormat = "time_zone_format"
    }
}

// MARK: - DMSSelectedNotificationSettings
struct DMSSelectedNotificationSettings: Codable{
    var emailDailyReminder, emailWeeklyReminder, emailTaskAccomplishment, emailTaskReschedule,
        emailDueToday, emailDueTomorrow, emailDailySchedule, whatsapp, linemessenger: String?
    
    enum CodingKeys: String, CodingKey {
        case emailDailyReminder = "email_daily_reminder"
        case emailWeeklyReminder = "email_weekly_reminder"
        case emailTaskAccomplishment = "email_task_accomplishment"
        case emailTaskReschedule = "email_task_reschedule"
        case emailDueToday = "email_due_today"
        case emailDueTomorrow = "email_due_tomorrow"
        case emailDailySchedule = "email_daily_schedule"
        case whatsapp = "whatsapp"
        case linemessenger = "linemessenger"
    }
}

// MARK: - DMSDashboardSettings
struct DMSDashboardSettings: Codable{
    var id: Int?
    var name: String?
    var isChecked: Bool? = false
}

// MARK: - DMSSelectedEmailScheduleSettings
struct DMSSelectedEmailScheduleSettings: Codable{
    var emailsettings: [DMSEMailSettings]?
}

// MARK: - DMSEMailSettings
struct DMSEMailSettings: Codable{
    var emailScheduleTaskId: Int?
    var days: String?
    enum CodingKeys: String, CodingKey {
        case emailScheduleTaskId = "email_schedule_task_id"
        case days
    }
}

// MARK: - DMSNotificationSettings
struct DMSNotificationSettings: Codable{
    var id: Int?
    var displayName, name, sort: String?
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case name, sort
    }
}

// MARK: - DMSEmailScheduleSettings
struct DMSEmailScheduleSettings: Codable{
    var id: Int?
    var name: String?
    var days: [String]? = []
}

// MARK: - DMSDateFormat
struct DMSDateFormat: Codable{
    var id: Int?
    var displayName, name: String?
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case name
    }
}

// MARK: - DMSTimeZoneFormat
struct DMSTimeZoneFormat: Codable{
    var id: Int?
    var name, timezone: String?
}
