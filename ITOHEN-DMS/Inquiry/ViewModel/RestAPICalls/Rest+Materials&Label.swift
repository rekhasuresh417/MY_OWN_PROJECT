//
//  Rest+Materials&Label.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 25/04/23.
//

import Foundation
import Foundation

@objc protocol RCMaterialsAndLabelDelegate {
    
    /// Get Label Inquiry Ids
    @objc optional func didReceiveGetLabelInquiryIds(data: [LabelInquiryIdsData]?)
    @objc optional func didFailedToReceiveGetLabelInquiryIds(errorMessage: String)
    
    /// Get Label Inquiry Ids
    @objc optional func didReceiveGetInquiryPOChat(data: InquiryPOChatResponse?)
    @objc optional func didFailedToReceiveGetInquiryPOChat(errorMessage: String)
    
    /// Get Label Content
    @objc optional func didReceiveGetLabelContent(data: InquiryFileUploadResponse?)
    @objc optional func didFailedToReceiveGetLabelContent(errorMessage: String)
    
    /// Add Label Content
    @objc optional func didReceiveAddLabelContent(message: String?)
    @objc optional func didFailedToReceiveAddLabelContent(errorMessage: String)
    
    /// Delete Label Content
    @objc optional func didReceiveDeleteLabelContent(message: String?)
    @objc optional func didFailedToReceiveDeleteLabelContent(errorMessage: String)
 
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+MaterialsAndLabel"
    }
    
    func getLabelInquiryIds(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.materialsAndLabelDelegate?.didFailedToReceiveGetLabelInquiryIds?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_LABEL_INQUIRY_IDS)")
        
        let resource = Resource<LabelInquiryIdsResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_LABEL_INQUIRY_IDS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.materialsAndLabelDelegate?.didReceiveGetLabelInquiryIds?(data: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.materialsAndLabelDelegate?.didFailedToReceiveGetLabelInquiryIds?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
   
    func getLabelContent(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.materialsAndLabelDelegate?.didFailedToReceiveGetLabelContent?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_LABEL_CONTENT)")
        
        let resource = Resource<InquiryFileUploadResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_LABEL_CONTENT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.materialsAndLabelDelegate?.didReceiveGetLabelContent?(data: response.value)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.materialsAndLabelDelegate?.didFailedToReceiveGetLabelContent?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
  
    func addLabelContent(params: [String: Any], isAdd: Bool) {
        if !Reachability.isConnectedToNetwork() {
            self.materialsAndLabelDelegate?.didFailedToReceiveAddLabelContent?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        let api = isAdd == true ? Config.API.ADD_LABEL_CONTENT : Config.API.EDIT_LABEL_CONTENT
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.materialsAndLabelDelegate?.didReceiveAddLabelContent?(message: response.value?.message)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.materialsAndLabelDelegate?.didFailedToReceiveAddLabelContent?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func deleteLabelContent(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.materialsAndLabelDelegate?.didFailedToReceiveDeleteLabelContent?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.DELETE_LABEL_CONTENT)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.DELETE_LABEL_CONTENT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.materialsAndLabelDelegate?.didReceiveDeleteLabelContent?(message: response.value?.message)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.materialsAndLabelDelegate?.didFailedToReceiveDeleteLabelContent?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getInquiryPOChat(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.materialsAndLabelDelegate?.didFailedToReceiveGetInquiryPOChat?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_INQUIRY_PO_CHAT)")
        
        let resource = Resource<InquiryPOChatResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_INQUIRY_PO_CHAT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.materialsAndLabelDelegate?.didReceiveGetInquiryPOChat?(data: response.value)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.materialsAndLabelDelegate?.didFailedToReceiveGetInquiryPOChat?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
}
