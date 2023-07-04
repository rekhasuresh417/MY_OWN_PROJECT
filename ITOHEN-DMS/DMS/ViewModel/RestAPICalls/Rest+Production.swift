//
//  Rest+Production.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/09/22.
//

import UIKit

@objc protocol RCProductionDelegate {

    /// Get calendar data  delegates
    @objc optional func didReceiveGetCalendarData(data: DMSGetCalendarData?)
    @objc optional func didFailedToReceiveGetCalendarData(errorMessage: String)
    
    /// Get sku data  delegates
    @objc optional func didReceiveGetSKUData(data: [SKUData]?)
    @objc optional func didFailedToReceiveGetSKUData(errorMessage: String)
    
    /// Add data  input delegates
    @objc optional func didReceiveAddInputData(message: String)
    @objc optional func didFailedToReceiveAddInputData(errorMessage: String)
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+Production"
    }
 
    func getCalendarData(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.productionDelegate?.didFailedToReceiveGetCalendarData?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_CALENDAR_DATA)")
        
        let resource = Resource<DMSGetCalendarResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_CALENDAR_DATA, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.productionDelegate?.didReceiveGetCalendarData?(data: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.productionDelegate?.didFailedToReceiveGetCalendarData?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getSKUData(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.productionDelegate?.didFailedToReceiveGetSKUData?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_SKU_DATA)")
        
        let resource = Resource<DMSGetSKUResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_SKU_DATA, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.productionDelegate?.didReceiveGetSKUData?(data: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.productionDelegate?.didFailedToReceiveGetSKUData?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func addInputData(params: [String: Any], isExcess: Bool = false) {
        if !Reachability.isConnectedToNetwork() {
            self.productionDelegate?.didFailedToReceiveAddInputData?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        let api: String = isExcess ? Config.API.ADD_INPUT_DATA_EXCESS : Config.API.ADD_INPUT_DATA
        print(api)
        
        ///add-data-input-excess
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(api)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: api, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.productionDelegate?.didReceiveAddInputData?(message: response.value?.message ?? "Data Updated Successfully")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else if response.value?.status_code == Config.ErrorCode.DATE_EXCEEDED{
                    self?.productionDelegate?.didReceiveAddInputData?(message: response.value?.message ?? "Failure")
                }else {
                    self?.productionDelegate?.didFailedToReceiveAddInputData?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
}

