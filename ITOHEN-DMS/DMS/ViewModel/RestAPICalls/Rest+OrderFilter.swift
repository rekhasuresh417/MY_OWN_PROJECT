//
//  Rest+Task.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 23/08/22.
//

import UIKit

@objc protocol RCTaskDelegate {
   
    /// Get factory, buyer, pcu  list delegates
    @objc optional func didReceiveStylesFilter(data: DMSGetFilterTaskData?)
    @objc optional func didFailedToReceiveStylesFilter(errorMessage: String)
    
    /// Get style  list delegates
    @objc optional func didReceiveGetStyles(data: [DMSStyleData]?)
    @objc optional func didFailedToReceiveGetStyles(errorMessage: String)
 
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+Task"
    }

    func getStylesData(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskDelegate?.didFailedToReceiveGetStyles?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }

        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FILES)")

        let resource = Resource<DMSGetStylesResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FILES, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskDelegate?.didReceiveGetStyles?(data: response.value?.data)
                }else if let error = response.error as NSError? {
                    self?.handleRestError(error: error)
                }else {
                    self?.taskDelegate?.didFailedToReceiveGetStyles?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }

    func getTaskFilterData(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskDelegate?.didFailedToReceiveStylesFilter?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }

        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_TASK_FILTER)")

        let resource = Resource<DMSGetFilterTaskResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_TASK_FILTER, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskDelegate?.didReceiveStylesFilter?(data: response.value?.data)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    print(error, error.code)
                    self?.handleRestError(error: error)
                }else {
                    self?.taskDelegate?.didFailedToReceiveStylesFilter?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }

}
