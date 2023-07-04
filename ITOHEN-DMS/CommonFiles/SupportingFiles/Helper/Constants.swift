//
//  Constants.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation
import UIKit

struct Config {
    
    static func infoForKey(_ key: String) -> String {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "") ?? ""
    }
    static let baseURL = Config.infoForKey("Server URL")
    static let appVersionUpdateURL = "https://dms.itohen.pro/app/mobileapps.html"
    static let stepLevel = 6
    static let aesKey = "QwertyUIOP!2#4"
    static let aesIV = "ITOHENDMS"
    
    struct API {
       
        static let GET_LANGUAGES = "get-languages"
        
        static let GET_STAFF_LANGUAGES = "get-language-details"
        
        static let UPDATE_USER_LANGUAGE = "update-user-language"
        
        static let UPDATE_STAFF_LANGUAGE = "update-staff-language"
        
        static let GET_COUNTRIES = "get-countries"
        
        static let GET_OTP = "user-get-otp"
        
        static let GET_STAFF_OTP = "staff-get-otp"
        
        static let SIGNUP_USER = "register-user"
        
        static let VERIFY_OTP = "verify-otp"
        
        static let VERIFY_STAFF_OTP = "staff-verify-otp"
        
        static let LOGOUT = "logout"
        
        static let GET_WORKSPACE = "get-workspace"
        
        static let GET_DASHBOARD_WIDGETS = "dashboard-widgets"
        
        static let GET_NEW_DASHBOARD_WIDGETS = "newdashboard-widgets"
        
        static let GET_ONGOING_LIST = "ongoing-list"
        
        static let GET_TOP_DELAY_LIST = "get-topdelay"
        
        static let GET_STAFF_PERMISSIONS = "get-staff-role"
        
        static let GET_ORDER_STATUS = "get-order-status"
        
        static let GET_NOTIFICATION_LIST = "notification-dashboard"
        
        static let READ_NOTIFICATION = "read_notification"
 
        static let GET_FILES =  "get-styles"
        
        static let GET_TASK_FILTER =  "get-filter"
        
        // Data Input
        static let GET_PRODUCTION_DATA =  "get-order-production"
        
        static let GET_CALENDAR_DATA =  "get-calendar-data"
        
        static let GET_SKU_DATA =  "get-sku-data"
        
        static let ADD_INPUT_DATA =  "add-data-input"
        
        static let ADD_INPUT_DATA_EXCESS =  "add-data-input-excess"
        
        static let ADD_PRODUCTION_DATA =  "add-order-production"
        
        static let GET_HOLIDAYS = "get-holidays"
        
        static let GET_WEEKOFFS = "get-weekOffs"
       
        // Task Update
        static let GET_TASK_DATA =  "get-task-data"
        
        static let ACCOMPLISHED_TASK = "accomplished-task"
        
        static let UPDATE_TASK = "update-task"
        
        static let ADD_SUB_TASK = "add-subtask"
        
        static let DELETE_SUB_TASK = "delete-subtask"
        
        static let UPDATE_ACTUAL_START_DATE = "actual-start-date"
        
        static let RESCHEDULE_TASK = "reschedule-task"
        
        static let RESCHEDULE_HISTORY = "reschedule-history"
        
      // User Settings
        static let GET_STAFF_SETTINGS = "get-staff-settings"
        
        static let GET_USER_SETTINGS = "get-user-settings"
        
        static let SAVE_STAFF_PREFERENCE = "staff-preference"
        
        static let SAVE_USER_PREFERENCE = "user-preference"
        
        static let SAVE_STAFF_NOTIFICATION_SETTING = "staff-notification-settings"
        
        static let SAVE_USER_NOTIFICATION_SETTING = "notification-settings"
       
        static let SAVE_DASHBOARD_SETTING = "add-dashboard-widgets"
        
        static let SAVE_STAFF_EMAIL_SETTING = "staff-email-settings"
        
        static let SAVE_USER_EMAIL_SETTING = "email-settings"
        
        // Inquiry
        static let CHECK_BUYER_NOTIFICATION = "check-buyer-notification"
        
        static let CHECK_FACTORY_NOTIFICATION = "check-factory-notification"
      
        static let READ_BUYER_NOTIFICATION = "read-buyer-notification"
        
        static let READ_FACTORY_NOTIFICATION = "read-factory-notification"
        
        static let GET_INQUIRY_LIST = "get-inquiry"
        
        static let GET_INQUIRY_FACTORY_RESPONSE = "inquiry-factory-response"
        
        static let GET_FACTORY_INQUIRY_LIST = "factory-get-inquiry"
        
        static let SAVE_INQUIRY_FACTORY_RESPONSE = "save-inquiry-factory-response"
        
        static let GET_FACTORY_LIST_RESPONSE = "get-factory-list-response"
        
        static let SAVE_BUYER_INQUIRY_FACTORY_RESPONSE = "save-buyer-inquiry-factory-response"
        
        static let SAVE_INQUIRY_CONTACT = "save-inquiry-contact"
        
        static let INQUIRY_FACTORY_CONTACT = "inquiry-factory-list"
        
        static let GET_INQUIRY_FACTORY = "get-inquiry-factory"
        
        static let SEND_INQUIRY = "send-inquiry"
      
        static let DELETE_INQUIRY = "delete-inquiry"
        
        static let VIEW_PO = "view-po"
        
        static let GENERATE_PO = "generate-po"
        
        static let CANCEL_PO = "cancel-po"
        
        
        // Materials And Label
        static let GET_LABEL_INQUIRY_IDS = "get-label-inquiry-ids"
       
        static let GET_INQUIRY_PO_CHAT = "get-inquiry-po-chat"
        
        static let GET_LABEL_CONTENT = "get-label-content"
        
        static let ADD_LABEL_CONTENT = "add-label-content"
        
        static let EDIT_LABEL_CONTENT = "edit-label-content"
        
        static let LABEL_FILE_UPLOAD = "label-file-upload"

        static let DELETE_LABEL_CONTENT = "label-file-delete"
        
        // Fabric
        static let GET_FABRIC_MASTER = "get-fabric-master"
        
        static let ADD_FABRIC_MASTER_DATA = "add-fabric-master-data"
        
        static let GET_FABRIC_INQUIRY_IDS = "get-fabric-inquiry-ids"
        
        static let GET_INQUIRY_CURRENCY = "get-inquiry-currency"
        
        static let GET_CURRENCIES = "get-currencies"
        
        static let SAVE_FABRIC_INQUIRY = "save-fabric-inquiry"
        
        static let EDIT_FABRIC_INQUIRY = "edit-fabric-inquiry"
        
        static let GET_FABRIC_INQUIRY_LIST = "get-fabric-inquiry-list"
        
        static let FABRIC_INQUIRY_DETAILS = "fabric-inquiry-details"
        
        static let FABRIC_SUPPLIERS_LIST = "fabric-supplier-list"
        
        static let GET_FABRIC_CONTACT = "get-fabric-contact"
        
        static let INQUIRY_SUPPLIERS_LIST = "inquiry-supplier-list"
        
        static let SEND_FABRIC_INQUIRY = "send-fabric-inquiry"
        
        static let ADD_FABRIC_CONTACT = "add-fabric-contact"
        
        static let INQUIRY_SUPPLIER_RESPONSE = "inquiry-supplier-response"
        
        static let GET_SUPPLIER_LIST_RESPONSE = "get-supplier-list-response"
        
        static let SAVE_FABRIC_INQUIRY_SUPPLIER_RESPONSE = "save-fabric-inquiry-supplier-response"
        
        static let DELETE_FABRIC_INQUIRY = "delete-fabric-inquiry"

    }
    
    struct AppConstants {
                
        static let USER_EMAIL = "userEmail"
        
        static let USER_NAME = "userName"
        
        static let NAME = "name"
        
        static let USER_ID = "userId"
        
        static let SUSER_ID = "suserId"
                
        static let IMAGES_TYPES = ["png", "jpg", "jpeg", "heic"]
        
        static var singleFileStorage = "2000000"
               
    }
    
    struct ErrorCode {
        static let SUCCESS = 200
        static let NOT_FOUND = 400
        static let ALREADY_ACCOMPLISHED_UPDATED = 600
        static let DATE_EXCEEDED = 204
        static let UN_AUTHENTICATED = 2
        static let NO_ORDER = 0
        static let INVALID_USER_ID_PWD = 101
        static let INVALID_SESSION_TOKEN = 209
    }

    struct OrderStatus{
        static let completed = "Completed"
        static let inProgress = "In Progress"
        static let delayedCompletion = "Delayed Completion"
        static let delayed = "Delayed"
        static let yetToStart = "Yet To Start"
    }
    
    struct UpdateStatus{
        static let ADD = "Add"
        static let EDIT = "Edit"
    }
    
    struct Font {
        static let appFontRegular = "Poppins-Regular"
        static let appFontMedium = "Poppins-Medium"
        static let appFontSemiBold = "Poppins-SemiBold"
    }
    
    struct weekdays {
        static let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
    
    static let dashboardSettings: [DashBoardSettings] = [
        DashBoardSettings(id:3, name: "Top 5 Delayed Tasks"),
        DashBoardSettings(id:4, name: "Top 5 Delayed Production"),
        DashBoardSettings(id:5, name: "Notification"),
        DashBoardSettings(id:6, name: "Ongoing Order List"),
        DashBoardSettings(id:7, name: "Order Status")
   ]
   
    struct DashBoardSettings {
        var id: Int
        var name: String
    }
    
    static let AppLanguages : [Language] = [
        Language(id:1, code: "en", name: "English", flag: "ic_flag_england", jsonFile: "English"),
        Language(id:2, code: "jp", name: "Japanese", flag: "ic_flag_japan", jsonFile: "Japanese"),
        Language(id:3, code: "bd", name: "Bengali", flag: "ic_flag_bangladesh", jsonFile: "Bengali"),
        Language(id:4, code: "in", name: "Hindi", flag: "ic_flag_india", jsonFile: "Hindi")
    ]

    struct Language {
        var id: Int
        var code: String
        var name: String
        var flag: String
        var jsonFile: String
    }
  
    static let Status: [InquiryStatus] = [
        InquiryStatus(id:0, name: "Open"),
        InquiryStatus(id:1, name: "Close"),
        InquiryStatus(id:2, name: "Accepted"),
        InquiryStatus(id:3, name: "Rejected"),
   ]
   
    struct InquiryStatus {
        var id: Int
        var name: String
    }
    
    struct Text {
        static let signInAccessKey = "access_token"
        static let pushDeviceKey = "device_token"
        static let platform = "ios"
        static let preferredLanguageKey = "preferred_language"
        static let hasLaunchedKey = "hasLaunched"
        static let signedEmail = "signedEmail"
        static let dateFormat = "dd MMM yyyy"
        static let apiDateFormat = "yyyy-MM-dd hh:mm:ss"
        static let currentWorkspaceId = "currentWorkspaceID"
        static let filterOrder = "filterOrder"
        static let filterType = "filterType"

        static let buyer = "Buyer"
        static let factory = "Factory"
        static let pcu = "PCU"
        
        static let cut = "Cut"
        static let sew = "Sew"
        static let pack = "Pack"
  
        static let staff = "Staff"
        static let user = "User"
        
        static let startDate = "StartDate"
        static let endDate = "EndDate"
        static let pic = "PIC"
        static let reschedule = "Reschedule"
        static let reassign = "Reassign"
        
        public struct NewOrder{
            public  static let noOfDeliveries: [String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
        }
    }
  
    struct Images {

        static let shared = Images()

        func getImage(imageName:String) -> UIImage?{
            return UIImage(named: imageName)
                ?? nil
        }

        static let languageIcon = "ic_group"
        static let tickIcon = "ic_tick"
        static let refreshIcon = "ic_refresh"
        static let mailIconGray = "ic_mailGray"
        static let mailIconWhite = "ic_mailWhite"
        static let asteriskIcon = "ic_asterisk"
        static let profileIcon = "ic_profile"
        static let plusIcon = "ic_plus"
        static let addNewOrderIcon = "ic_addNewOrder"
        static let taskIcon = "ic_task"
        static let dataInputIcon = "ic_dataInput"
        static let orderStatusIcon = "ic_orderStatus"
        static let homeOrderStatusIcon = "ic_homeOrderStatus"
        static let userManagementIcon = "ic_userManagement"
        static let homeIcon = "ic_home"
     
        //Dashboard
        static let ongoingListDIcon = "ongoingList"
        static let orderStatusDIcon = "orderStatus"
        static let delayTaskDIcon = "delayTask"
        static let delayProdDIcon = "delayProd"
        
        static let menuTaskIcon = "ic_menu_task"
        static let menuDataInputIcon = "ic_menu_datainput"
        static let menuUserSettingsIcon = "ic_menu_setting"
        
        static let logisticsIcon = "ic_logistics"
        static let enquiryIcon = "ic_enquiry"
        static let transitDetailsIcon = "ic_transitDetails"
        static let documentsIcon = "ic_documents"
        static let trackingIcon = "ic_tracking"
        static let listOfForwarderIcon = "ic_listOfForwarders"

        static let seaIcon = "ic_sea"
        static let airIcon = "ic_air"
        static let roadIcon = "ic_road"
        static let seaBackgroundIcon = "ic_seaBackground"
        static let airBackgroundIcon = "ic_airBackground"
        static let roadBackgroundIcon = "ic_roadBackground"
        static let waterWayIcon = "ic_shipWay"
        static let roadWayIcon = "ic_truckWay"
        static let airWayIcon = "ic_truckWay"

        static let infoIcon = "ic_info"
        static let bellIcon = "ic_bell"
        static let avatarIcon = "ic_avatar"
        static let downArrowIcon = "ic_downArrow"
        static let sectionCollapseIcon = "ic_section_collapse"
        static let upArrowIcon = "ic_upArrow"
        static let rightArrowIcon = "ic_rightArrow"
        static let editInfoIcon = "ic_editInfo"
        static let buyerIcon = "ic_buyer"
        static let factoryIcon = "ic_factory"
        static let pcuIcon = "ic_pcu"
        static let addContactIcon = "ic_addContact"
        static let addTaskIcon = "ic_addTask"
        static let addProductionIcon = "ic_addProduction"
        static let deleteIcon = "ic_delete"
        static let linkIcon = "ic_link"
        static let calenderIcon = "ic_calendar"
        static let editIcon = "ic_edit"
        static let historyIcon = "ic_history"
        static let delayIcon = "ic_delay"
        static let warningIcon = "ic_warning"
        static let reminderIcon = "ic_reminder"
        static let leftArrowIcon = "ic_leftArrow"
        static let groupUsersIcon = "ic_groupUsers"
        static let filterIcon = "ic_filter"
        static let downArrowFillIcon = "ic_downArrowFill"
        static let backIcon = "ic_back"
        static let checkedIcon = "ic_checked"
        static let cancelIcon = "ic_cancel"
        static let closeIcon = "ic_round_close"
        static let roundTickIcon = "ic_round_tick"

        static let checkboxIcon = "checkbox"
        static let checkboxTickIcon = "checkbox_tick"
        static let inq_checkboxTickIcon = "ic_inquiry_checkbox_tick"
        
        static let playIcon = "ic_play"
        static let stopIcon = "ic_stop"

        static let cuttingIcon = "ic_cutting"
        static let sewingIcon = "ic_sewing"
        static let packingIcon = "ic_packing"
        static let previewIcon = "ic_preview"
        static let reOrderIcon = "ic_reOrder"
        static let placeholderIcon = "ic_placeholder"
        static let remindIcon = "ic_remind"
        static let attnIcon = "ic_attn"
        static let dangerIcon = "ic_danger"
        static let overdelayIcon = "ic_overdelay"
        static let rejectCloseOrderIcon =  "ic_reject_close_order"
        static let closeOrderIcon =  "ic_close_order"
        static let percentageIcon = "ic_percentage"
        static let quantityIcon = "ic_quantity"
        
        static let sortIcon = "ic_sort-down"

        static let tabBarIcons = ["ic_home","ic_orderList","ic_pendingTask","ic_orderStatus"]
        
        /// new
//        static let staffIcon_dash = "ic_staff"
//        static let orderIcon_dash =  "ic_orders"
//        static let facytoryIcon_dash =  "ic_factories"
//        static let pcuIcon_dash = "ic_pcus"
//        static let buyerIcon_dash = "ic_buyers"
        
        static let staffIcon_menu =  "ic_staff-menu"
        static let pendingTaskIcon_menu = "ic_pendingtask-icon"
        static let companyProfileIcon_menu = "ic_company_profile"
        static let menuIcon = "ic_menu"
        static let userIcon = "ic_user"
        static let languageIcon_menu = "ic_language"
        static let helpIcon_menu = "ic_help"
        static let reportUsIcon = "ic_reportUs"
        static let logoutIcon = "ic_logout"
        static let addNewTask = "ic_add_task"
        static let removeNewTask = "ic_remove_task"
        static let fileUploadIcon = "ic_upload"
        static let fileDownloadIcon = "ic_download"
        
        // Inquiry
        static let inquiryIcon = "ic_inquiry"
        static let viewInquiryIcon = "ic_view_inquiry"
        static let factoryResponseIcon = "ic_factory_response"
        static let inquiryStatusIcon = "ic_inquiry_status"
        static let sendQuoteIcon = "ic_send_quote"
        static let quotationIcon = "ic_quotation"
        static let eyeIcon = "ic_eye"
        
        static let viewPOIcon = "ic_view_po"
        static let generatePOIcon = "ic_generate_po"
        static let materialLabelsIcon = "ic_material_labels"
        
        // Fabric
        static let fabricIcon = "ic_fabric"
        static let fabricInquiryIcon = "ic_fabric_inquiry"
    }
 
    struct DocumentType {
        static let supportedDocsTypes = [  "public.jpeg",
                                           "public.jpeg-2000",
                                           "public.png",
                                           "com.adobe.pdf",
                                           "com.microsoft.word.doc",
                                           "org.openxmlformats.wordprocessingml.document",
                                           "public.text",
                                           "com.microsoft.excel.xls",
                                           "com.microsoft.powerpoint.​ppt" ]
    }
    
    struct UserDefinedKey {
        
        static let FLURRY_API_KEY = Config.infoForKey("Flurry API Key")
        
        static let GAD_UNIT_ID = Config.infoForKey("Google AD UnitID")
        
        static let GAD_APP_ID = Config.infoForKey("GADApplicationIdentifier")
    }
    
    struct backEndAlertMessage{
        static let otpSentMessage = "OTP sent to your email"
        static let contactAdminMessage = "Contact your DMS ADMIN for Login"
        static let userFoundOTPSentMessage = "User Found & OTP Mail Sent"
        static let userNotFound = "User Not Found"
        static let registerNotCompleted = "Please complete the registration process on the website and try again"
      
        static let planExpired = "Plan Expired! Contact Admin."
        
        static let inCorrectOtpMessage = "Incorrect OTP, Please Enter Correctly"
        static let otpVerifiedMessage = "OTP Verified Successfully"
        
        static let loggedOutSuccessMessage = "User Logged Out Successfully"
        
        static let dateRescheduleSuccessMessage = "Date Rescheduled Successfully"
        static let picChangeSuccessMessage = "PIC Changed Successfully"
        static let dateAccomplishedSuccessMessage = "Date Added Successfully"
        static let dateUpdatedSuccessMessage = "Updated Successfully"
        
        static let dataInputUpdatedSuccessMessage = "Data Updated Successfully"
        
        static let generalSettingSuccessMessage = "User Preference Updated Successfully"
        static let notifSettingSuccessMessage = "Notification Settings Updated Successfully"
        static let emailSettingSuccessMessage = "Email Schedule Settings Updated Successfully"
        static let dashboardSettingSuccessMessage = "Added Successfully"
        
        static let subTaskAddedSuccessMessage = "Sub Task Added Successfully"
        static let subTaskDeletedSuccessMessage = "Deleted Successfully"
        static let alreadyUpdatedMessage = "Already Updated."
        static let accomplishAllSubTask = "Please Accomplish All The Subtasks"
        static let enterDateCorrectlyMessage = "Please enter the date correctly."
        static let enterMainTaskMessage = "Please Enter Main Task Dates"
        static let startDateValidationMessage = "Start Date must be lesser than or equal to End Date"
        static let endDateValidationMessage = "End Date must be greater than or equal to Start Date"
        static let reschduleSubTaskDateMessage = "Reschedule Subtasks Date And Try Again"
        
        //Inquiry
        static let inquiryAddedSuccessMessage = "Inquiry Response Added Successfully"
        static let selectFactoryText = "Please Select atleast one Factory"
        static let inquirySentMessage = "Inquiry sent Successfully"
        static let poGeneratedMessage = "Purchase Order Generated Successfully"
        static let factoryAddedMessage = "Factory Added Successfully"
        static let dataAddedSuccessfullyText = "Data Added Successfully"
        static let dataUpdatedSuccessfullyText = "Data Updated Successfully"
        
        // dataAddedSuccessfullyText dataUpdatedSuccessfullyText
        //Fabric
        static let fabricContactAlreadyTakenMessage = "The contact number has already been taken."
        static let fabricEmailAlreadyTakenMessage = "The contact email has already been taken."
        
    }
  
}

