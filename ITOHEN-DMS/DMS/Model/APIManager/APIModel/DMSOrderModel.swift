//
//  DMSOrderModel.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/08/22.
//

import Foundation

// MARK: - DMSGetOrderList
struct DMSGetOrderList: Codable {
    var status: String?
    var status_code: Int?
    var message: String?
    var data: [DMSGetOrderListData]?
}

// MARK: - DMSGetOrderListData
class DMSGetOrderListData: NSObject, Codable {
    var id, orderNo, styleNo, buyerName, factoryName: String?
    var totalQuantity, noOfDelivery: String?
    var pcuName, manufacturingStartDate, manufacturingEndDate, workspaceName:String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNo = "order_no"
        case styleNo = "style_no"
        case buyerName
        case pcuName
        case factoryName
        case totalQuantity = "total_quantity"
        case noOfDelivery = "no_of_delivery"
        case manufacturingStartDate = "manufacturing_start_date"
        case manufacturingEndDate = "manufacturing_end_date"
        case workspaceName
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
        }
        orderNo = try container.decodeIfPresent(String.self, forKey: .orderNo) ?? ""
        styleNo = try container.decodeIfPresent(String.self, forKey: .styleNo) ?? ""
        buyerName = try container.decodeIfPresent(String.self, forKey: .buyerName) ?? ""
        factoryName = try container.decodeIfPresent(String.self, forKey: .factoryName) ?? ""
        totalQuantity = try container.decodeIfPresent(String.self, forKey: .totalQuantity) ?? "0"
        noOfDelivery = try container.decodeIfPresent(String.self, forKey: .noOfDelivery) ?? "0"
        pcuName = try container.decodeIfPresent(String.self, forKey: .pcuName)

        manufacturingStartDate = try container.decodeIfPresent(String.self, forKey: .manufacturingStartDate)
        manufacturingEndDate = try container.decodeIfPresent(String.self, forKey: .manufacturingEndDate)

        workspaceName = try container.decodeIfPresent(String.self, forKey: .workspaceName) ?? ""
    }
}

// MARK: - DMSStaffPermissions
struct DMSStaffPermissions: Codable {
    var status_code: Int
    var data: DMSWorkspaceList?
}

// MARK: - DMSStaffPermissionData
class DMSStaffPermissionData: NSObject, Codable{
    var permission: [String]? = []
}

// MARK: - DMSAddNewOrder
class DMSAddNewOrder: NSObject, Codable {
    var status: String?
    var status_code: Int
    var message: String?
    var id: String?
    var totalQuantity: String?
    var errors: Errors?
}


// MARK: - DMSDashboardWidgets
class DMSDashboardWidgets: NSObject, Codable {
    var status: String?
    var status_code: Int
    var message: String?
    var data: DMSDashboardWidgetsData?
}

// MARK: - DMSNewDashboardWidgets
class DMSNewDashboardWidgets: NSObject, Codable {
    var status: String?
    var status_code: Int
    var message: String?
    var data: DMSNewDashboardWidgetsData?
}

// MARK: - DMSNewDashboardWidgetsData
class DMSNewDashboardWidgetsData: NSObject, Codable {
    var widgetNames: [DMSDashboardWidgetsName]?
    var dashboardWidgets: [String]?
}

// MARK: - DMSDashboardWidgetsName
struct DMSDashboardWidgetsName: Codable{
    var id: Int?
    var name: String?
}

// MARK: - DMSDashboardWidgetsData
class DMSDashboardWidgetsData: NSObject, Codable {
    var Buyer, Factory, Order, PCU, Staff: Int?
    var updateBuyerDate, updateFactoryDate, updateOrderDate, updatePCUDate, updateStaffDate: String?
}

// MARK: - DMSGetTopDelay
struct DMSGetTopDelay: Codable {
    var status: String?
    var status_code: Int?
    var message: String?
    var data: DMSGetTopDelayData?
}

// MARK: - DMSGetTopDelayData
class DMSGetTopDelayData: NSObject, Codable{
    var top5proddelayed: [DMSTopProdDelay]?
    var top5taskdelayed: [DMSTopTaskDelay]?
}

// MARK: - DMSTopProdDelay
struct DMSTopProdDelay: Codable{
    var typeOfProduction, orderNo, styleNo: String?
    var delay: Int?

    enum CodingKeys: String, CodingKey {
        case delay
        case typeOfProduction = "type_of_production"
        case orderNo = "order_no"
        case styleNo = "style_no"
    }
}

// MARK: - DMSTopTaskDelay
struct DMSTopTaskDelay: Codable{
    var orderNo, styleNo, taskTitle, taskScheduleStartDate, taskScheduleEndDate, taskAccomplishedDate, staffName: String?
    var taskPIC, noOfDays: Int?

    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case styleNo = "style_no"
        case taskTitle = "task_title"
        case taskScheduleStartDate = "task_schedule_start_date"
        case taskScheduleEndDate = "task_schedule_end_date"
        case taskAccomplishedDate = "task_accomplished_date"
        case staffName
        case taskPIC = "task_pic"
        case noOfDays
    }
}

// MARK: - DMSOrderStatus
class DMSOrderStatus: NSObject, Codable{
    var status: String?
    var status_code: Int?
    var message: String?
    let taskCount: [DMSOrderStatusTaskCount]?
    let taskChart: [DMSOrderStatusTaskChart]?
    let prodData: [DMSOrderStatusProdData]?
}

// MARK: - DMSOrderStatusTaskCount
struct DMSOrderStatusTaskCount: Codable{
    let total, completed, delay, delayedCompleted, inProgress, yetToStart: Int?
}

// MARK: - DMSOrderStatusTaskChart
struct DMSOrderStatusTaskChart: Codable{
    let cat_title, task_title, task_schedule_start_date, task_schedule_end_date, task_accomplished_date: String?
}

// MARK: - DMSOrderStatusProdData
struct DMSOrderStatusProdData: Codable{
    let orderNo, styleNo, cutStartDate, cutEndDate, sewStartDate, sewEndDate, packStartDate, packEndDate, cutStatus, sewStatus, packStatus: String?
    let total, cutPerDay, sewPerDay, packPerDay, cutCompleted, sewCompleted, packCompleted : Int?
    let cutTargets, sewTargets, packTargets, cutPercentage, sewPercentage, packPercentage: Double?
}
