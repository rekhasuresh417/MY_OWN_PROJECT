//
//  Rest+Dashboard.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/08/22.
//

import UIKit

@objc protocol RCDashboardDelegate {
    
    /// Get dashboard widgets  delegates
    @objc optional func didReceiveDashboard(dashboardWidgets: DMSDashboardWidgetsData?)
    @objc optional func didFailedToReceiveDashboardWidgets(errorMessage: String)
    
    /// Get new dashboard widgets  delegates
    @objc optional func didReceiveNewDashboard(dashboardWidgets: DMSNewDashboardWidgetsData?)
    @objc optional func didFailedToReceiveNewDashboardWidgets(errorMessage: String)
    
    /// Get ongoing list  delegates
    @objc optional func didReceiveOngoingList(ongoingList: [DMSGetOrderListData])
    @objc optional func didFailedToReceiveOngoingList(errorMessage: String)
    
    /// Get Top delay list  delegates
    @objc optional func didReceiveTopDelayList(topDelayList: DMSGetTopDelayData?)
    @objc optional func didFailedToReceiveTopDelayList(errorMessage: String)
   
    /// Get notification list  delegates
    @objc optional func didReceiveNotificationList(data: [DMSNotificationData])
    @objc optional func didFailedToReceiveNotificationList(errorMessage: String)
    
    /// Read notification list  delegates
    @objc optional func didReceiveReadNotification(data: [DMSNotificationData])
    @objc optional func didFailedToReceiveReadNotification(errorMessage: String)
    
    /// Get permissions  delegates
    @objc optional func didReceiveGetStaffPermission(data: DMSWorkspaceList?)
    @objc optional func didFailedToReceiveStaffPermission(errorMessage: String)
    
    /// Get order status  delegates
    @objc optional func didReceiveGetOrderStatus(data: DMSOrderStatus?)
    @objc optional func didFailedToReceiveOrderStatus(errorMessage: String)
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+Dashboard"
    }
   
    func getDashboardWidget(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveDashboardWidgets?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_DASHBOARD_WIDGETS)")
        
        let resource = Resource<DMSDashboardWidgets, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_DASHBOARD_WIDGETS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.dashboardDelegate?.didReceiveDashboard?(dashboardWidgets: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveDashboardWidgets?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getNewDashboardWidget(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveDashboardWidgets?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_NEW_DASHBOARD_WIDGETS)")
        
        let resource = Resource<DMSNewDashboardWidgets, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_NEW_DASHBOARD_WIDGETS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.dashboardDelegate?.didReceiveNewDashboard?(dashboardWidgets: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveNewDashboardWidgets?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getOngoingList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveOngoingList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_ONGOING_LIST)")
        
        let resource = Resource<DMSGetOrderList, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_ONGOING_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.dashboardDelegate?.didReceiveOngoingList?(ongoingList:response.value?.data ?? [])
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    print(error.code)
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveOngoingList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }

    func getTopDelay(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveTopDelayList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_TOP_DELAY_LIST)")
        
        let resource = Resource<DMSGetTopDelay, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_TOP_DELAY_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.dashboardDelegate?.didReceiveTopDelayList?(topDelayList:response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveTopDelayList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getPermissions(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveOngoingList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_STAFF_PERMISSIONS)")
        
        let resource = Resource<DMSStaffPermissions, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_STAFF_PERMISSIONS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    if let data = response.value?.data as? DMSWorkspaceList{
                        self?.dashboardDelegate?.didReceiveGetStaffPermission?(data: data)
                        UserDefaults.standard.storeCodable(data, key: "currentWorkspace")
                        self?.appDelegate.getWorkspaceList() // for assign into workspaceList
                    }
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveOngoingList?(errorMessage: "something_went_wrong")
                }
            }
        }
    }

    func getNotificationList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveNotificationList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_NOTIFICATION_LIST)")
        
        let resource = Resource<DMSNotification, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_NOTIFICATION_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.dashboardDelegate?.didReceiveNotificationList?(data:response.value?.data ?? [])
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveNotificationList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
//    
//    func readNotificationList(params: [String: Any]) {
//        if !Reachability.isConnectedToNetwork() {
//            self.dashboardDelegate?.didFailedToReceiveNotificationList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
//            return
//        }
//        
//        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.READ_NOTIFICATION)")
//        
//        let resource = Resource<DMSNotification, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.READ_NOTIFICATION, method: .post, params: params, headers: [:])
//        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
//            DispatchQueue.main.async { [self] in
//                if response.value?.status_code == Config.ErrorCode.SUCCESS{
//                    self?.dashboardDelegate?.didReceiveNotificationList?(data:response.value?.data ?? [])
//                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{ 
//                    self?.handleRestError(error: error)
//                }else {
//                    self?.dashboardDelegate?.didFailedToReceiveNotificationList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
//                }
//            }
//        }
//    }
    
    func getOrderStatus(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.dashboardDelegate?.didFailedToReceiveOrderStatus?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_ORDER_STATUS)")
        
        let resource = Resource<DMSOrderStatus, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_ORDER_STATUS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    if let data = response.value{
                        self?.dashboardDelegate?.didReceiveGetOrderStatus?(data: data)
                    }
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.dashboardDelegate?.didFailedToReceiveOrderStatus?(errorMessage: "something_went_wrong")
                }
            }
        }
    }
}
