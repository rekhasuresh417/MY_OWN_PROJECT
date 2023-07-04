//
//  Rest+User.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 22/07/22.
//

import UIKit
import RealmSwift

@objc protocol RCUserDelegate {
    
    /// Get languages  delegates
    @objc optional func didReceiveLanguages(language: [Languages])
    @objc optional func didFailedToReceiveLanguages(errorMessage: String)
    
    /// Update language  delegates
    @objc optional func didReceiveUpdateLanguage(message: String)
    @objc optional func didFailedToReceiveUpdateLanguage(errorMessage: String)
    
    /// Get languages  delegates
    @objc optional func didReceiveCountries(country: [Countries])
    @objc optional func didFailedToReceiveCoutries(errorMessage: String)
  
    /// Get login OTP  delegates
    @objc optional func didRequestOtpSuccess(message: String)
    @objc optional func didFailedToRequestOtp(errorMessage: String)
  
    /// Get logout  delegates
    @objc optional func didRequestLogoutSuccess(message: String)
    @objc optional func didFailedToRequestLogout(errorMessage: String)
    
    /// Get Signup  delegates
    @objc optional func didRequestSignupSuccess(message: String)
    @objc optional func didFailedToRequestSignup(errorMessage: String)
    
    /// Validate OTP  delegates
    @objc optional func didRequestValidateOTPSuccess(statusCode: Int, languageId: String, language: String, message: String)
    @objc optional func didFailedToRequestValidateOTP(errorMessage: String)
}


extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+User"
    }
    
    // Get OTP
    func getLoginOTP(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToRequestOtp?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        var api = ""
        if let loginType = params["type"] as? String, loginType == Config.Text.user{
            api = Config.API.GET_OTP
        }else{
            api = Config.API.GET_STAFF_OTP
        }
        print(api)
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.userDelegate?.didRequestOtpSuccess?(message: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "otp_sent_text"))
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND {
                    self?.userDelegate?.didFailedToRequestOtp?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "user_not_found"))
                }else {
                    self?.userDelegate?.didFailedToRequestOtp?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
  
    /// Get countries
    func getCountries() {
        
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToReceiveLanguages?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_COUNTRIES)")
        
        let resource = Resource<DMSCountriesResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_COUNTRIES, method: .get, params: [:], headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.userDelegate?.didReceiveCountries?(country: response.value?.data ?? [])
                }
            }
        }
    }
    
    func signupUser(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToRequestSignup?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SIGNUP_USER)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SIGNUP_USER, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in

                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.userDelegate?.didRequestSignupSuccess?(message: response.value?.message ?? "")
                }else {
                    if let error = response.value?.errors{
                        if let emailError = error.email{
                            self?.userDelegate?.didFailedToRequestSignup?(errorMessage: emailError[0])
                        }
                    }else{
                        self?.userDelegate?.didFailedToRequestSignup?(errorMessage: response.value?.message ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                    }
                }
            }
        }
    }
    
    // Validate OTP
    func validateOTP(params: [String: Any], loginType: String) {
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToRequestValidateOTP?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api = ""
        if loginType == Config.Text.user{
            api = Config.API.VERIFY_OTP
        }else{
            api = Config.API.VERIFY_STAFF_OTP
        }
        
        print("API", api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSValidateOTP, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in

                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    RMConfiguration.shared.accessToken = response.value?.token ?? ""
                    RMConfiguration.shared.userId = "\(response.value?.user_id ?? 0)"
                    RMConfiguration.shared.staffId = "\(response.value?.staff_id ?? 0)"
                    RMConfiguration.shared.loginType = response.value?.login_type ?? ""

                    AppDelegate().defaults.setValue("\(response.value?.user_id ?? 0)", forKey: "USER_ID")
                    AppDelegate().defaults.setValue("\(response.value?.staff_id ?? 0)", forKey: "STAFF_ID")
                    
                    RMConfiguration.shared.dateFormat = String().convertDMSDateFormat(dateFormat: DateFormat(rawValue: response.value?.dateformat ?? "") ?? .D_SP_M_SP_Y)
                    RMConfiguration.shared.email = response.value?.email ?? ""
                    RMConfiguration.shared.role = "\(response.value?.role ?? "")"
                    
                    RMConfiguration.shared.companyId = "\(response.value?.company_id ?? 0)"
                    RMConfiguration.shared.workspaceId = "\(response.value?.workspace_id ?? 0)"
                    RMConfiguration.shared.workspaceType = response.value?.workspaceType ?? ""
                    RMConfiguration.shared.workspaceName = response.value?.workspaceName ?? ""
                    RMConfiguration.shared.userName = response.value?.user_name ?? ""

                    //setting the object
                    UserDefaults.standard.storeCodable(response.value?.workspacesList ?? [], key: "workspace")
                    UserDefaults.standard.storeCodable(response.value?.workspacesList?[0], key: "currentWorkspace")
                    self?.appDelegate.getWorkspaceList() // for assign into workspaceList

                    UIViewController.sharedWebClient.baseUrl = RMConfiguration.shared.loginType == Config.Text.user ? Config.baseURL : "\(Config.baseURL)staff/"
                    UIViewController.sharedWebClient.bearerToken = response.value?.token ?? ""
                    
                    self?.userDelegate?.didRequestValidateOTPSuccess?(statusCode: Config.ErrorCode.SUCCESS,
                                                                      languageId: "\(response.value?.language_id ?? 0)",
                                                                      language: response.value?.language ?? "",
                                                                      message: response.value?.message ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.userDelegate?.didFailedToRequestValidateOTP?(errorMessage: response.value?.message ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }else {
                    self?.userDelegate?.didFailedToRequestValidateOTP?(errorMessage: response.value?.message ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
  
    // Logout User
    func logoutUser() {
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToRequestLogout?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var params: [String:String] = [:]
        if RMConfiguration.shared.loginType == Config.Text.staff{
            if let staffId = AppDelegate().defaults.value(forKey: "STAFF_ID") as? String{
                params["staff_id"] = staffId
            }
        }else{
            if let userId = AppDelegate().defaults.value(forKey: "USER_ID") as? String{
                params["user_id"] = userId
            }
        }
        print(params)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.LOGOUT)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.LOGOUT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.userDelegate?.didRequestLogoutSuccess?(message: response.value?.message ?? "")
                }else {
                    self?.userDelegate?.didFailedToRequestLogout?(errorMessage: response.value?.error ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    /// Get languages
    func getLanguages(params: [String: Any]) {
        
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToReceiveLanguages?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        var api = ""
        
        if RMConfiguration.shared.loginType == Config.Text.staff{
            api = Config.API.GET_STAFF_LANGUAGES
        }else{
            api = Config.API.GET_LANGUAGES
        }
        print(api, params)
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
       
        let resource = Resource<DMSLanguagesResponse, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .get, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.userDelegate?.didReceiveLanguages?(language: response.value?.data ?? [])
                }else if response.value?.status_code == Config.ErrorCode.UN_AUTHENTICATED {
                    self?.userDelegate?.didFailedToReceiveLanguages?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "un_authenticated"))
                }else {
                    self?.userDelegate?.didFailedToReceiveLanguages?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }

    /// Update languages
    func updateLanguage(params: [String: Any]) {
        
        if !Reachability.isConnectedToNetwork() {
            self.userDelegate?.didFailedToReceiveUpdateLanguage?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        var api = ""
        
        if RMConfiguration.shared.loginType == Config.Text.staff{
            api = Config.API.UPDATE_STAFF_LANGUAGE
        }else{
            api = Config.API.UPDATE_USER_LANGUAGE
        }
        print(api, params)
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
       
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.userDelegate?.didReceiveUpdateLanguage?(message: response.value?.message ?? "")
                }else if response.value?.status_code == Config.ErrorCode.UN_AUTHENTICATED {
                    self?.userDelegate?.didFailedToReceiveUpdateLanguage?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "un_authenticated"))
                }else {
                    self?.userDelegate?.didFailedToReceiveUpdateLanguage?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
}

