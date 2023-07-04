//
//  DMSTaskTemplateResponse.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

// MARK: - DMSGetTaskData
class DMSGetTaskData: NSObject, Codable {
    var status: String
    var status_code: Int
    var message: String?
    var templateID: Int? = 0
    var templateName: String? = ""
    var data: [EditTaskTemplateData]
    var orderTaskCount: OrderTaskCount?
    var pic: [Contact]?
    var deliveryDates: [DeliveryDates]?
}

// MARK: - EditTaskTemplateData
class EditTaskTemplateData: NSObject, Codable {
    var task_title: String
    var task_subtitles: [EditTaskSubTitleData]
    var collapsed: Bool? = false
    
    var asDictionary: [String: Any] {
        return [
            "task_title" : task_title,
            "task_subtitles" : task_subtitles
        ]
    }
    
    init(taskTitle: String, taskSubTitles: [EditTaskSubTitleData], collapsed: Bool = false) {
        // init properties here
        self.task_title = taskTitle
        self.task_subtitles = taskSubTitles
    }
}

// MARK: - DeliveryDates
struct DeliveryDates: Codable{
    let delivery_date: String?
}

// MARK: - EditTaskSubTitleData
struct EditTaskSubTitleData: Codable {
    
    var taskID, taskSeq: String?
    var catTitle, taskTitle, taskPic, subTaskPic, taskStartDate, subTaskStartDate, taskEndDate, subTaskEndDate, taskAccomplishedDate, subTaskAccomplishedDate, rescheduled: String?
    var taskContacts:[String]?
    var subtasks: [SubTasksData]? = []
    var isSubTask: Bool?
    
    var asDictionary: [String: Any] {
        return [
            "title" : taskTitle ?? "",
            "startdate" : taskStartDate ?? "",
            "enddate" : taskEndDate ?? "",
            "pic_id": taskPic ?? ""
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case taskID = "id"
        case taskSeq = "task_seq"
        case taskTitle = "subtitle"
        case catTitle = "title"
        case taskPic = "pic_id"
        case taskStartDate = "start_date"
        case taskEndDate = "end_date"
        case taskAccomplishedDate = "accomplished_date"
        case rescheduled = "rescheduled"
        case taskContacts = "task_contacts"
        case subtasks = "subtasks"
    }
    
    init(taskID: String, taskSeq: String, catTitle: String, taskTitle: String, taskPic: String, subTaskPic: String, taskStartDate: String, subTaskStartDate: String, taskEndDate: String, subTaskEndDate: String, taskAccomplishedDate: String, subTaskAccomplishedDate: String, rescheduled: String, taskContacts:[String], subTasks: [SubTasksData], isSubTask:Bool?) {
        // init properties here
        self.taskID = taskID
        self.taskSeq = taskSeq
     
        self.taskTitle = taskTitle
        self.catTitle = catTitle
       
        self.taskPic = taskPic
        self.subTaskPic = subTaskPic
       
        self.taskStartDate = taskStartDate
        self.subTaskStartDate = subTaskStartDate
              
        self.taskEndDate = taskEndDate
        self.subTaskEndDate = subTaskEndDate
      
        self.taskAccomplishedDate = taskAccomplishedDate
        self.subTaskAccomplishedDate = subTaskAccomplishedDate
      
        self.rescheduled = rescheduled
        self.taskContacts = taskContacts
        self.subtasks = subTasks
        self.isSubTask = isSubTask
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .rescheduled)
            rescheduled = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            rescheduled = try container.decodeIfPresent(String.self, forKey: .rescheduled) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .taskID)
            taskID = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            taskID = try container.decodeIfPresent(String.self, forKey: .taskID) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .taskSeq)
            taskSeq = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            taskSeq = try container.decodeIfPresent(String.self, forKey: .taskSeq) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .taskPic)
            taskPic = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            taskPic = try container.decodeIfPresent(String.self, forKey: .taskPic) ?? "0"
        }
        catTitle = try container.decodeIfPresent(String.self, forKey: .catTitle) ?? ""
        taskTitle = try container.decodeIfPresent(String.self, forKey: .taskTitle) ?? ""
        taskStartDate = try container.decodeIfPresent(String.self, forKey: .taskStartDate) ?? ""
        taskEndDate = try container.decodeIfPresent(String.self, forKey: .taskEndDate) ?? ""
        taskAccomplishedDate = try container.decodeIfPresent(String.self, forKey: .taskAccomplishedDate) ?? ""
        taskContacts = try container.decodeIfPresent([String].self, forKey: .taskContacts) ?? []
        subtasks = try container.decodeIfPresent([SubTasksData].self, forKey: .subtasks) ?? []
    }
}

// MARK: - SubTasksData
struct SubTasksData: Codable {
    var id, picId: String?
    var title, subtitle, subtasktitle, subTaskStartDate, subTaskEndDate, subTaskAccomplishedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, subtasktitle
        case subTaskStartDate = "start_date"
        case subTaskEndDate = "end_date"
        case subTaskAccomplishedDate = "accomplished_date"
        case picId = "pic_id"
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
            let value = try container.decodeIfPresent(Int.self, forKey: .picId)
            picId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            picId = try container.decodeIfPresent(String.self, forKey: .picId) ?? "0"
        }
       
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
        subtasktitle = try container.decodeIfPresent(String.self, forKey: .subtasktitle) ?? ""
        subTaskStartDate = try container.decodeIfPresent(String.self, forKey: .subTaskStartDate) ?? ""
        subTaskEndDate = try container.decodeIfPresent(String.self, forKey: .subTaskEndDate) ?? ""
        subTaskAccomplishedDate = try container.decodeIfPresent(String.self, forKey: .subTaskAccomplishedDate) ?? ""
    }
    
}

// MARK: - DMSGetRescheduleHistoryResponse
struct DMSGetRescheduleHistoryResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [DMSGetRescheduleHistoryData]?
}

// MARK: - DMSGetRescheduleHistoryData
class DMSGetRescheduleHistoryData: NSObject, Codable {
    let catTitle, taskTitle, startDate, endDate: String?
    let rescheduledStartDate, rescheduledEndDate, reason, rescheduledType: String?
    let picId, prevPICId: Int?
    let createdAt, prevStaffName, nextStaffName, userName: String?

    enum CodingKeys: String, CodingKey {
        case catTitle = "cat_title"
        case taskTitle = "task_title"
        case startDate = "start_date"
        case endDate = "end_date"
        case rescheduledStartDate = "rescheduled_start_date"
        case rescheduledEndDate = "rescheduled_end_date"
        case reason = "reason"
        case rescheduledType = "rescheduled_type"
        case picId = "pic_id"
        case prevPICId = "prev_pic_id"
        case createdAt = "created_at"
        case prevStaffName = "prevStaffName"
        case nextStaffName = "nextStaffName"
        case userName = "userName"
        
    }
}

// MARK: - DMSGetFilterTaskResponse
struct DMSGetFilterTaskResponse: Codable {
    var status: String
    var status_code: Int
    var message: String?
    var data: DMSGetFilterTaskData?
}

// MARK: - DMSGetFilterTaskData
class DMSGetFilterTaskData: NSObject, Codable {
    var factory: [ContactsData]?
    var buyer: [ContactsData]?
    var pcu: [ContactsData]?
    var style: [DMSStyleData]?
}

// MARK: - DMSStyleData
class DMSStyleData: NSObject, Codable {
    var id, step_level: Int?
    var style_no, order_no, status: String?
}

// MARK: - DMSGetStylesResponse
struct DMSGetStylesResponse: Codable {
    var status: String
    var status_code: Int
    var message: String?
    var data: [DMSStyleData]?
}

// MARK: - OrderTaskCount
class OrderTaskCount:NSObject, Codable{
    var totalTask, scheduledTasks, accomplishedTasks, yetToStart, pending: Int?
}
