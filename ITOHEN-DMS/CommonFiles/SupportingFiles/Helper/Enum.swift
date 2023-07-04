//
//  Enum.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 03/08/22.
//

import Foundation

enum UserRole : String{
    case admin = "1"
    case manager = "2"
    case staff = "3"
    case guest = "4"
    case superviser = "5"
    case Merchandiser = "6"
}

enum UserType : String {
    case buyer = "Buyer"
    case pcu = "PCU"
    case factory = "Factory"
}

enum Days : String {
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
}

enum DateFormat : String{
    case D_SP_M_SP_Y = "d M Y"
    case D_M_Y = "d-m-Y"
    case Y_M_D = "Y-m-d"
    case Y_SP_M_SP_D = "Y M d"
    case Y_SL_M_SL_D = "Y/m/d"
}

enum DMS_DateFormat : String{
    case DD_SP_MMM_SP_YYYY = "dd MMM yyyy"
    case DD_MM_YYYY = "dd-MM-yyyy"
    case YYYY_MM_DD = "yyyy-MM-dd"
    case YYY_SP_MMM_SP_DD = "yyyy MMM dd"
    case YYY_SL_MMM_SL_DD = "yyyy/MM/dd"
}

enum NotificationSettings: String{
    case emailDueToday = "Task Due Today"
    case emailDueTomorrow = "Task Due Tomorrow"
    case emailTaskReschedule = "Task Rescheduled"
    case emailDailyReminder = "Daily Reminder"
    case emailWeeklyReminder = "Weekly Reminder"
    case emailTaskAccomplishment = "Accomplished Tasks"
}

enum DashboardSettings: String{
    case prodStatus = "Production Status"
    case taskStatus = "Task Status"
    case top5DelayedTask = "Top 5 Delayed Task"
    case top5DelayedProd = "Top 5 Delayed Production"
    case notifications = "Notifications"
    case ongoingList = "Ongoing List"
    case orderStatus = "Order Status"
}

enum EmailScheduleSettings: String{
    case orderStatus = "Order Status"
    case delayedTasks = "Delayed Tasks"
    case completedTasks = "Completed Tasks"
}

enum Permissions: String{
    // Order Module
    case addOrder = "Add Order"
    case viewAllOrder = "View All Orders"
    case editOrder = "Edit Order"
    
    // Factory Module
    case addFactory = "Factory Add"
    case editFactory = "Factory Edit"
    
    // PCU Module
    case addPCU = "PCU Add"
    case editPCU = "PCU Edit"
    
    // Buyer Module
    case addBuyer = "Buyer Add"
    case editBuyer = "Buyer Edit"
    
    // Fabric Module
    case addFabric = "Fabric Add"
    
    // Category Module
    case addCategory = "Category Add"
    
    // Article Module
    case addArticle = "Article Add"
    
    // Color Module
    case addColor = "Color Add"
    case editColor = "Color Edit"
    
    // Size Module
    case addSize = "Size Add"
    case editSize = "Size Edit"
    
    // Task Module
    case taskEditTemplate = "Task Edit Template"
    case taskFileUpload = "Task File Upload"
    case taskFileDelete = "Task File Delete"
    
    // Task Update Module
    case viewTaskUpdates = "View Task Updates"
    case addTaskUpdates = "Add Task Updates"
    case editOthersTask = "Edit Others Task"
 
    // Sub Taske Module
    case addSubTask = "add_sub_task"
    case deleteSubTask = "delete_sub_task"
   // case editSubTask = "edit_sub_task"
    
    // Pending Task Module
    case pendingTask = "Pending Task"
    case downloadPendingTaskReport = "Download Pending Task Report"
    
    // Data Input Module
    case viewDataInput = "View Data Input"
    case addDataInput = "Add Data Input"
    case editDataInput = "Edit Data Input"

    // Staffs Module
    case viewStaff = "View Staff"
    case addStaff = "Staff Add"
    case editStaff = "Staff Edit"
    
    // Inquiry - Buyer
    case buyerViewInquiry = "View Inquiry"
    case buyerAddInquiry = "Create Inquiry" // No need
    case buyerEditInquiry = "Edit Inquiry" // No need
    case buyerSentToFactory = "Sent Inquiry"
    case buyerViewResponse = "View Response"
    case buyerDeleteInquiry = "Delete Inquiry"

    // Inquiry - Factory
    case factoryViewInquiry = "View Factory Inquiry"
    case factoryAddResponse = "Add Response"
   
    // Fabric
    case viewFabricInquiry = "View Fabric Inquiry"
    case addFabricInquiry = "Add Fabric Inquiry"
    case editFabricInquiry = "Edit Fabric Inquiry"
    case sentToSupplier = "Sent To Supplier"
    case viewSupplierResponse = "View Supplier Response"
    case addSupplierResponse = "Add Supplier Response"
    case deleteFabricInquiry = "Delete Fabric Inquiry"
    
    // Inquiry - Purchase Order
    case generatePO = "Generate PO"
    case viewPO = "View PO"
    case confirmPO = "Confirm PO" // no need
    case cancelPO = "Cancel PO"
    
    // Inquiry - Materials & Label
    case viewMaterialsAndLabels = "View Materials And Labels"
    case addAndEditMaterialsAndLabels = "Add and Edit Materials And Labels"
}

enum DashBoardWidgets : String{
    case productionStatus = "1"
    case top5DelayedTask = "4"
    case top5DelayedProduction = "2"
    case notifications = "7"
    case ongoingList = "6"
    case orderStatus = "5"
}

enum SKUTypes {
    case color
    case size
}

enum ContactDisplayType {
    case view
    case edit
}

enum TaskInputDisplayType {
    case view
    case edit
    case add
}

enum TaskTVSections {
    case selectTemplate
    case uploadFile
    case downloadFile
    case reOrder
    case categoriesAndTasks
    case addNewCategory
}

enum HomeItemType {
    case addNewOrder
    case task
    case dataInput
    case orderStatus
    case userManagement
    case logistics
}

/// AppState helps to set root view controller based on app flows
enum AppState {
    case signIn
    case newUser
    case tabbar
}

// Pagination
enum TableSection: Int {
    case inquiryList
    case loader
}

// Fabric Type
enum FabricMasterType: String {
    case yarnQuality = "YarnQuality"
    case material = "Meterial"
    case composition = "Composition"
}

// MaterialsAndLabelType
enum MaterialsAndLabelType: String {
    case printArtWork = "PrintArtWork"
    case mainLabel = "MainLabel"
    case washCare = "WashCare"
    case hangTag = "HangTag"
    case barCode = "BarCode"
    case polyBag = "PolyBag"
    case carton = "Carton"
}
