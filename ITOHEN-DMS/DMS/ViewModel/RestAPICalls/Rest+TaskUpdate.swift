//
//  Rest+TaskUpdate.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 02/11/22.
//

import Foundation

@objc protocol RCTaskUpdateDelegate {
 
    /// Create task data delegates
    @objc optional func didReceiveGetTaskData(data: DMSGetTaskData?)
    @objc optional func didFailedToReceiveGetTaskData(errorMessage: String)
  
    /// Accomplished task
    @objc optional func didReceiveUpdateAccomplishedTask(statusCode: Int, message: String)
    @objc optional func didFailedToReceiveUpdateAccomplishedTask(errorMessage: String)
    
    /// Update  task
    @objc optional func didReceiveUpdateTask(message: String)
    @objc optional func didFailedToReceiveUpdateTask(errorMessage: String)
    
    /// Add sub  task
    @objc optional func didReceiveAddSubTask(message: String)
    @objc optional func didFailedToReceiveAddSubTask(errorMessage: String)
    
    /// Delete sub  task
    @objc optional func didReceiveDeleteSubTask(message: String)
    @objc optional func didFailedToReceiveDeleteSubTask(errorMessage: String)
 
    /// Update actual start date
    @objc optional func didReceiveUpdateActualStartDate(message: String)
    @objc optional func didFailedToReceiveUpdateActualStartDate(errorMessage: String)
    
    /// Reschedule  task
    @objc optional func didReceiveRescheduleTask(message: String)
    @objc optional func didFailedToReceiveRescheduleTask(errorMessage: String)
    
    /// Reschedule  history
    @objc optional func didReceiveRescheduleHistory(data: [DMSGetRescheduleHistoryData]?)
    @objc optional func didFailedToReceiveRescheduleHistory(errorMessage: String)
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+TaskUpdate"
    }
    
      func getTaskData(params: [String: Any]) {
          if !Reachability.isConnectedToNetwork() {
              self.taskUpdateDelegate?.didFailedToReceiveGetTaskData?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
              return
          }

          RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_TASK_DATA)")

          let resource = Resource<DMSGetTaskData, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_TASK_DATA, method: .post, params: params, headers: [:])
          UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
              DispatchQueue.main.async { [self] in
                  if response.value?.status_code == Config.ErrorCode.SUCCESS{
                      self?.taskUpdateDelegate?.didReceiveGetTaskData?(data: response.value)
                  }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED {
                      self?.handleRestError(error: error)
                  }else if let error = response.error as NSError?, error.code == Config.ErrorCode.NO_ORDER {
                      self?.taskUpdateDelegate?.didFailedToReceiveGetTaskData?(errorMessage: "No order exist for this Id")
                  }else {
                      self?.taskUpdateDelegate?.didFailedToReceiveGetTaskData?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                  }
              }
          }
      }
    
    func updateAccomplishedTask(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveUpdateAccomplishedTask?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.ACCOMPLISHED_TASK)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.ACCOMPLISHED_TASK, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveUpdateAccomplishedTask?(statusCode: Config.ErrorCode.SUCCESS, message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveUpdateAccomplishedTask?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
   
    func updateTask(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveUpdateTask?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.UPDATE_TASK)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.UPDATE_TASK, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveUpdateTask?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveUpdateTask?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func reScheduleTask(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveRescheduleTask?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.RESCHEDULE_TASK)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.RESCHEDULE_TASK, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveRescheduleTask?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveRescheduleTask?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func reScheduleHistory(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveRescheduleHistory?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.RESCHEDULE_HISTORY)")
        
        let resource = Resource<DMSGetRescheduleHistoryResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.RESCHEDULE_HISTORY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveRescheduleHistory?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.taskUpdateDelegate?.didFailedToReceiveRescheduleHistory?(errorMessage: response.value?.message ?? "Reschedule History Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveRescheduleHistory?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func addSubTask(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveAddSubTask?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.ADD_SUB_TASK)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.ADD_SUB_TASK, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveAddSubTask?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveAddSubTask?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func deleteSubTask(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveDeleteSubTask?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.DELETE_SUB_TASK)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.DELETE_SUB_TASK, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveDeleteSubTask?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveDeleteSubTask?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func updateActualStartDate(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.taskUpdateDelegate?.didFailedToReceiveUpdateActualStartDate?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.UPDATE_ACTUAL_START_DATE)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.UPDATE_ACTUAL_START_DATE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.taskUpdateDelegate?.didReceiveUpdateActualStartDate?(message: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.taskUpdateDelegate?.didFailedToReceiveUpdateActualStartDate?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
}
