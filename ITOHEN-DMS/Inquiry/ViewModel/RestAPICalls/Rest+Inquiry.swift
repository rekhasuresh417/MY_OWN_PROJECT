//
//  Rest+Inquiry.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 25/01/23.
//

import Foundation

@objc protocol RCInquiryDelegate {

    /// Get InquiryList
    @objc optional func didReceiveInquiryList(data: InquiryListResponse?)
    @objc optional func didFailedToReceiveInquiryList(errorMessage: String)
    
    /// Get FactoryResponse
    @objc optional func didReceiveFactoryResponse(data: [FactoryResponseData]?)
    @objc optional func didFailedToReceiveFactoryResponse(errorMessage: String)
    
    /// Get Factory InquiryList
    @objc optional func didReceiveFactoryInquiryList(data: FactoryInquiryResponse?, response: [Int]?)
    @objc optional func didFailedToReceiveFactoryInquiryList(errorMessage: String)
    
    /// Save  Factory Inquiry Response
    @objc optional func didReceiveSaveFactoryResponse(message: String)
    @objc optional func didFailedToReceiveSaveFactoryResponse(errorMessage: String)
    
    /// SaveBuyerQuoteResponse
    @objc optional func didReceiveSaveBuyerQuoteResponse(message: String)
    @objc optional func didFailedToReceiveSaveBuyerQuoteResponse(errorMessage: String)
   
    /// Get  Factory Inquiry  list Response
    @objc optional func didReceiveGetFactoryListResponse(response: FactoryInquiryListResponse?)
    @objc optional func didFailedToReceiveGetFactoryListResponse(errorMessage: String)
    
    /// Get Inquiry Notification Response
    @objc optional func didReceiveInquiryNotificationResponse(message: String)
    @objc optional func didFailedToInquiryNotificationResponse(errorMessage: String)
    
    /// Read Inquiry Notification Response
    @objc optional func didReceiveReadInquiryNotificationResponse(message: String)
    @objc optional func didFailedToReadInquiryNotificationResponse(errorMessage: String)

    // Delete inquiry
    @objc optional func didReceiveDeleteInquiry(message: String)
    @objc optional func didFailedToReceiveDeleteInquiry(errorMessage: String)
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+Inquiry"
    }
    
    func checkInquiryNotification(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToInquiryNotificationResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api: String = ""
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            api = Config.API.CHECK_BUYER_NOTIFICATION
        }else{
            api = Config.API.CHECK_FACTORY_NOTIFICATION
        }
        print(api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<InquiryNotificationResponse, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveInquiryNotificationResponse?(message: "\(response.value?.notifications ?? 0)")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToInquiryNotificationResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func readInquiryNotification(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReadInquiryNotificationResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        var api: String = ""
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            api = Config.API.READ_BUYER_NOTIFICATION
        }else{
            api = Config.API.READ_FACTORY_NOTIFICATION
        }
        print(api)
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<InquiryNotificationResponse, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveReadInquiryNotificationResponse?(message: "\(response.value?.notifications ?? 0)")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReadInquiryNotificationResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getInquiryList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveInquiryList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_INQUIRY_LIST)")
        
        let resource = Resource<InquiryListResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_INQUIRY_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                     self?.inquiryDelegate?.didReceiveInquiryList?(data: response.value)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.inquiryDelegate?.didFailedToReceiveInquiryList?(errorMessage: response.value?.message ?? "Inquiry List Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveInquiryList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFactoryResponse(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveFactoryResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
   
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_INQUIRY_FACTORY_RESPONSE)")
        
        let resource = Resource<FactoryResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_INQUIRY_FACTORY_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveFactoryResponse?(data: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveFactoryResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFactoryInquiryList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveFactoryInquiryList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FACTORY_INQUIRY_LIST)")
        
        let resource = Resource<FactoryInquiryResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FACTORY_INQUIRY_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveFactoryInquiryList?(data: response.value, response: response.value?.response)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.inquiryDelegate?.didFailedToReceiveFactoryInquiryList?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveFactoryInquiryList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getNonDMSFactoryList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveGetFactoryListResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FACTORY_LIST_RESPONSE)")
        
        let resource = Resource<FactoryInquiryListResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FACTORY_LIST_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveGetFactoryListResponse?(response: response.value)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.inquiryDelegate?.didFailedToReceiveGetFactoryListResponse?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveGetFactoryListResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveFactoryInquiryResponse(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveSaveFactoryResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
   
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SAVE_INQUIRY_FACTORY_RESPONSE)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SAVE_INQUIRY_FACTORY_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveSaveFactoryResponse?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveSaveFactoryResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
   
    func saveBuyerInquiryResponse(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveSaveBuyerQuoteResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
   
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SAVE_BUYER_INQUIRY_FACTORY_RESPONSE)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SAVE_BUYER_INQUIRY_FACTORY_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveSaveBuyerQuoteResponse?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveSaveBuyerQuoteResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    
    func deleteInquiry(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.inquiryDelegate?.didFailedToReceiveDeleteInquiry?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.DELETE_INQUIRY)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.DELETE_INQUIRY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.inquiryDelegate?.didReceiveDeleteInquiry?(message: response.value?.message ?? "Inquiry Deleted Successfully")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.inquiryDelegate?.didFailedToReceiveDeleteInquiry?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.inquiryDelegate?.didFailedToReceiveDeleteInquiry?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
}

