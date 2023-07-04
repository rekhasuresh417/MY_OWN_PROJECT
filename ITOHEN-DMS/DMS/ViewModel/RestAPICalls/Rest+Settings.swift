//
//  Rest+Settings.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 09/11/22.
//

import Foundation

@objc protocol RCSettingsDelegate {

    /// get settings details
    @objc optional func didReceiveSettingDetails(data: DMSSettingsData?)
    @objc optional func didFailedToReceiveSettingDetails(errorMessage: String)
    
    /// save general settings
    @objc optional func didReceiveSaveGeneralSettings(message: String)
    @objc optional func didFailedToReceiveSaveGeneralSettings(errorMessage: String)
    
    /// save notification settings
    @objc optional func didReceiveSaveNotificationSettings(message: String)
    @objc optional func didFailedToReceiveSaveNotificationSettings(errorMessage: String)
  
    /// save dashboard settings
    @objc optional func didReceiveSaveDashboardSettings(message: String)
    @objc optional func didFailedToReceiveSaveDashboardSettings(errorMessage: String)
    
    /// save email schedule settings
    @objc optional func didReceiveSaveEmailScheduleSettings(message: String)
    @objc optional func didFailedToReceiveSaveEmailScheduleSettings(errorMessage: String)
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+Settings"
    }
    
    func getSettingsDetails(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.settingsDelegate?.didFailedToReceiveSettingDetails?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api: String = ""
        if RMConfiguration.shared.loginType == Config.Text.staff{
            api = Config.API.GET_STAFF_SETTINGS
        }else{
            api = Config.API.GET_USER_SETTINGS
        }
        print(api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSettingsResponse, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.settingsDelegate?.didReceiveSettingDetails?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.settingsDelegate?.didFailedToReceiveSettingDetails?(errorMessage: response.value?.message ?? "Setting Details Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.settingsDelegate?.didFailedToReceiveSettingDetails?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveGeneralSettings(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.settingsDelegate?.didFailedToReceiveSettingDetails?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api: String = ""
        if RMConfiguration.shared.loginType == Config.Text.staff{
            api = Config.API.SAVE_STAFF_PREFERENCE
        }else{
            api = Config.API.SAVE_USER_PREFERENCE
        }
        print(api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.settingsDelegate?.didReceiveSaveGeneralSettings?(message: response.value?.message ?? "Saved Successfully")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.settingsDelegate?.didFailedToReceiveSettingDetails?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveNotificationSettings(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.settingsDelegate?.didFailedToReceiveSaveNotificationSettings?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api: String = ""
        if RMConfiguration.shared.loginType == Config.Text.staff{
            api = Config.API.SAVE_STAFF_NOTIFICATION_SETTING
        }else{
            api = Config.API.SAVE_USER_NOTIFICATION_SETTING
        }
        print(api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.settingsDelegate?.didReceiveSaveNotificationSettings?(message: response.value?.message ?? "Saved Successfully")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.settingsDelegate?.didFailedToReceiveSaveNotificationSettings?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveDashboardSettings(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.settingsDelegate?.didFailedToReceiveSaveDashboardSettings?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
    
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SAVE_DASHBOARD_SETTING)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SAVE_DASHBOARD_SETTING, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.settingsDelegate?.didReceiveSaveDashboardSettings?(message: response.value?.message ?? "Saved Successfully")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.settingsDelegate?.didFailedToReceiveSaveDashboardSettings?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveEmailSettings(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.settingsDelegate?.didFailedToReceiveSaveEmailScheduleSettings?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api: String = ""
        if RMConfiguration.shared.loginType == Config.Text.staff{
            api = Config.API.SAVE_STAFF_EMAIL_SETTING
        }else{
            api = Config.API.SAVE_USER_EMAIL_SETTING
        }
        print(api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.settingsDelegate?.didReceiveSaveEmailScheduleSettings?(message: response.value?.message ?? "Saved Successfully")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.settingsDelegate?.didFailedToReceiveSaveEmailScheduleSettings?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
}
