//
//  Rest+FactoryContact.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 13/04/23.
//

import Foundation

@objc protocol RCFactoryContactDelegate {
    
    /// Get Inquiry Factory List
    @objc optional func didReceiveInquiryFactoryList(data: [InquiryFactoryListData]?)
    @objc optional func didFailedToReceiveInquiryFactoryList(errorMessage: String)
    
    /// Get Inquiry Factory
    @objc optional func didReceiveInquiryFactory(data: [InquiryFactoryListData]?)
    @objc optional func didFailedToReceiveInquiryFactory(errorMessage: String)
    
    // Send factory Inquiry
    @objc optional func didReceiveSendFactoryInquiry(message: String)
    @objc optional func didFailedToReceiveSendFactoryInquiry(errorMessage: String)
    
    /// Save Inquiry Factory
    @objc optional func didReceiveSaveInquiryFactory(message: String)
    @objc optional func didFailedToReceiveSaveInquiryFactory(errorMessage: String)
    
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+FactoryContact"
    }
    
    func addNewInquiryFactory(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.factoryContactDelegate?.didFailedToReceiveSaveInquiryFactory?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
   
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SAVE_INQUIRY_CONTACT)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SAVE_INQUIRY_CONTACT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.factoryContactDelegate?.didReceiveSaveInquiryFactory?(message: response.value?.message ?? "")
                }else if let error = response.value?.errors{
                    if let contactNumberError = error.contact_number{
                        self?.factoryContactDelegate?.didFailedToReceiveSaveInquiryFactory?(errorMessage: contactNumberError[0])
                    }else if let emailError = error.contact_email{
                        self?.factoryContactDelegate?.didFailedToReceiveSaveInquiryFactory?(errorMessage: emailError[0])
                    }
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.factoryContactDelegate?.didFailedToReceiveSaveInquiryFactory?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getInquiryFactoryList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.factoryContactDelegate?.didFailedToReceiveInquiryFactoryList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.INQUIRY_FACTORY_CONTACT)")
        
        let resource = Resource<InquiryFactoryList, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.INQUIRY_FACTORY_CONTACT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.factoryContactDelegate?.didReceiveInquiryFactoryList?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.factoryContactDelegate?.didFailedToReceiveInquiryFactoryList?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.factoryContactDelegate?.didFailedToReceiveInquiryFactoryList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getInquiryFactory(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.factoryContactDelegate?.didFailedToReceiveInquiryFactory?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_INQUIRY_FACTORY)")
        
        let resource = Resource<InquiryFactoryList, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_INQUIRY_FACTORY, method: .get, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.factoryContactDelegate?.didReceiveInquiryFactory?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.factoryContactDelegate?.didFailedToReceiveInquiryFactory?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.factoryContactDelegate?.didFailedToReceiveInquiryFactory?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func sendInquiryToFactory(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.factoryContactDelegate?.didFailedToReceiveSendFactoryInquiry?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SEND_INQUIRY)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SEND_INQUIRY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.factoryContactDelegate?.didReceiveSendFactoryInquiry?(message: response.value?.message ?? "Inquiry sent Successfully")
                }else if let error = response.value?.errors{
                    if let factoryId = error.factory_id{
                        self?.factoryContactDelegate?.didFailedToReceiveSendFactoryInquiry?(errorMessage: "Please Select atleast one Factory")
                    }
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.factoryContactDelegate?.didFailedToReceiveSendFactoryInquiry?(errorMessage: response.value?.message ?? "Inquiry Not Sent")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.factoryContactDelegate?.didFailedToReceiveSendFactoryInquiry?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
}
