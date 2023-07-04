//
//  Rest+PurchaseOrder.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 13/04/23.
//

import Foundation

@objc protocol RCPurchaseOrderDelegate {
    
    /// Get Purchase Order List
    @objc optional func didReceivePurchaseOrderList(data: PurchaseOrderList?)
    @objc optional func didFailedToReceivePurchaseOrderList(errorMessage: String)
    
    /// Cancel Purchase Order
    @objc optional func didReceiveCancelPurchaseOrder(message: String)
    @objc optional func didFailedToReceiveCancelPurchaseOrder(errorMessage: String)
    
    /// Generate PO
    @objc optional func didReceiveGeneratePurchaseOrder(message: String)
    @objc optional func didFailedToReceiveGeneratePurchaseOrder(errorMessage: String)
    
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+FactoryContact"
    }
    
    func getPurchaseOrderList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.purchaseOrderDelegate?.didFailedToReceivePurchaseOrderList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
   
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.VIEW_PO)")
        
        let resource = Resource<PurchaseOrderList, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.VIEW_PO, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.purchaseOrderDelegate?.didReceivePurchaseOrderList?(data: response.value)
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.purchaseOrderDelegate?.didFailedToReceivePurchaseOrderList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func cancelPurchaseOrder(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.purchaseOrderDelegate?.didFailedToReceiveCancelPurchaseOrder?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.CANCEL_PO)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.CANCEL_PO, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.purchaseOrderDelegate?.didReceiveCancelPurchaseOrder?(message: response.value?.message ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.purchaseOrderDelegate?.didFailedToReceiveCancelPurchaseOrder?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.purchaseOrderDelegate?.didFailedToReceiveCancelPurchaseOrder?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func generatePO(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.purchaseOrderDelegate?.didFailedToReceiveGeneratePurchaseOrder?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GENERATE_PO)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GENERATE_PO, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.purchaseOrderDelegate?.didReceiveGeneratePurchaseOrder?(message: response.value?.message ?? "Purchase Order Generated Successfully")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.purchaseOrderDelegate?.didFailedToReceiveGeneratePurchaseOrder?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.purchaseOrderDelegate?.didFailedToReceiveGeneratePurchaseOrder?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
}
