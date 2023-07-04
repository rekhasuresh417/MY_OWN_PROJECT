//
//  Rest+Fabric.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 15/03/23.
//

import Foundation

@objc protocol RCFabricDelegate{

    /// Get Fabric Inquiry List
    @objc optional func didReceiveFabricInquiryList(data: FabricInquiryListResponse?)
    @objc optional func didFailedToReceiveFabricInquiryList(errorMessage: String)
    
    /// Get Fabric master data
    @objc optional func didReceiveFabricMasterData(data: [FabricMasterData]?)
    @objc optional func didFailedToReceiveFabricMasterData(errorMessage: String)
    
    /// Add Fabric master data
    @objc optional func didReceiveAddFabricMasterData(message: String)
    @objc optional func didFailedToReceiveAddFabricMasterData(errorMessage: String)
    
    /// Get Fabric inquiry Ids
    @objc optional func didReceiveFabricInquiryId(data: [FabricInquiryIds]?)
    @objc optional func didFailedToReceiveFabricInquiryId(errorMessage: String)
  
    /// Get  currencies
    @objc optional func didReceiveCurrencies(data: [FabricCurrencyData]?)
    @objc optional func didFailedToReceiveCurrencies(errorMessage: String)
    
    /// Get  inquiry currency
    @objc optional func didReceiveInquiryCurrency(data: String)
    @objc optional func didFailedToReceiveInquiryCurrency(errorMessage: String)
    
    /// Save fabric inquiry
    @objc optional func didReceiveSaveFabricInquiry(message: String)
    @objc optional func didFailedToReceiveSaveFabricInquiry(errorMessage: String)
    
    /// Get fabric  inquiry details
    @objc optional func didReceiveFabricInquiryDetails(data: [FabricInquityDetailsData]?)
    @objc optional func didFailedToReceiveFabricInquiryDetails(errorMessage: String)
    
    /// Get fabric  contact
    @objc optional func didReceiveFabricContact(data: [FabricContactData]?)
    @objc optional func didFailedToReceiveFabricContact(errorMessage: String)

    // Get fabric  supliers list
    @objc optional func didReceiveFabricSuppliersList(data: [FabricContactData]?)
    @objc optional func didFailedToReceiveFabricSuppliersList(errorMessage: String)
    
    // Send Inquiry to suppliers
    @objc optional func didReceiveSendFabricInquiry(message: String)
    @objc optional func didFailedToReceiveSendFabricInquiry(errorMessage: String)
    
    // Create New suppliers
    @objc optional func didReceiveCreateNewSuppliers(message: String)
    @objc optional func didFailedToReceiveCreateNewSuppliers(errorMessage: String)
   
    // Get suppliers response
    @objc optional func didReceiveGetSuppliersResponse(data: [FabricSupplierData]?)
    @objc optional func didFailedToReceiveGetSuppliersResponse(errorMessage: String)
    
    // Get suppliers List response
    @objc optional func didReceiveGetSuppliersListResponse(data: [FabricSupplierListData]?, currency: String)
    @objc optional func didFailedToReceiveGetSuppliersListResponse(errorMessage: String)
    
    // Delete fabric inquiry
    @objc optional func didReceiveDeleteFabricInquiry(message: String)
    @objc optional func didFailedToReceiveDeleteFabricInquiry(errorMessage: String)
    
    // Save supplier response
    @objc optional func didReceiveSaveSupplierResponse(message: String)
    @objc optional func didFailedToReceiveSaveSupplierResponse(errorMessage: String)
    
    //Fabric Inquiry PDF Download
    @objc optional func didReceiveGetFabricInquiryPDF(message: String)
    @objc optional func didFailedToReceiveGetFabricInquiryPDF(errorMessage: String)
    
    //Supplier Response PDF Download
    @objc optional func didReceiveGetSupplierResponsePDF(message: String)
    @objc optional func didFailedToReceiveGetSupplierResponsePDF(errorMessage: String)
}

extension RestCloudService {
    
    fileprivate var logTag: String {
        return "Rest+Fabric"
    }
    
    func getFabricList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveFabricInquiryList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FABRIC_INQUIRY_LIST)")
        
        let resource = Resource<FabricInquiryListResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FABRIC_INQUIRY_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveFabricInquiryList?(data: response.value)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveFabricInquiryList?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveFabricInquiryList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFabricMasterData(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveFabricMasterData?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FABRIC_MASTER)")
        
        let resource = Resource<FabricMasterDataResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FABRIC_MASTER, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveFabricMasterData?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveFabricMasterData?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveFabricMasterData?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func addFabricMasterData(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveAddFabricMasterData?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.ADD_FABRIC_MASTER_DATA)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.ADD_FABRIC_MASTER_DATA, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveAddFabricMasterData?(message: response.value?.message ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveAddFabricMasterData?(errorMessage: response.value?.message ?? "d")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveAddFabricMasterData?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFabricInquiryIds(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveFabricInquiryId?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FABRIC_INQUIRY_IDS)")
        
        let resource = Resource<FabricInquiryIdResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FABRIC_INQUIRY_IDS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveFabricInquiryId?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveFabricInquiryId?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveFabricInquiryId?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getInquiryCurrency(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveInquiryCurrency?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_INQUIRY_CURRENCY)")
        
        let resource = Resource<FabricInquiryCurrencyResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_INQUIRY_CURRENCY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveInquiryCurrency?(data: response.value?.data ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveInquiryCurrency?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveInquiryCurrency?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getCurrencies(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveCurrencies?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_CURRENCIES)")
        
        let resource = Resource<FabricCurrencyResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_CURRENCIES, method: .get, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveCurrencies?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveCurrencies?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveCurrencies?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveFabricInquiry(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveSaveFabricInquiry?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SAVE_FABRIC_INQUIRY)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SAVE_FABRIC_INQUIRY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveSaveFabricInquiry?(message: response.value?.message ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveSaveFabricInquiry?(errorMessage: response.value?.message ?? "Fabric inquiry not saved")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveSaveFabricInquiry?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func editFabricInquiry(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveSaveFabricInquiry?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.EDIT_FABRIC_INQUIRY)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.EDIT_FABRIC_INQUIRY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveSaveFabricInquiry?(message: response.value?.message ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveSaveFabricInquiry?(errorMessage: response.value?.message ?? "Fabric inquiry not updated")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveSaveFabricInquiry?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFabricInquiryDetails(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveFabricInquiryDetails?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.FABRIC_INQUIRY_DETAILS)")
        
        let resource = Resource<FabricInquiryDetailsResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.FABRIC_INQUIRY_DETAILS, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveFabricInquiryDetails?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveFabricInquiryDetails?(errorMessage: response.value?.message ?? "Fabric Inquiry Details Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveFabricInquiryDetails?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFabricContact(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveFabricContact?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_FABRIC_CONTACT)")
        
        let resource = Resource<FabricContactResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_FABRIC_CONTACT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveFabricContact?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveFabricContact?(errorMessage: response.value?.message ?? "Fabric Contact Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveFabricContact?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getFabricSuppliersList(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveFabricSuppliersList?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.FABRIC_SUPPLIERS_LIST)")
        
        let resource = Resource<FabricContactResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.FABRIC_SUPPLIERS_LIST, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveFabricSuppliersList?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveFabricSuppliersList?(errorMessage: response.value?.message ?? "Fabric Suppliers List Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveFabricSuppliersList?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func sendInquiryToSuppliers(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveSendFabricInquiry?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SEND_FABRIC_INQUIRY)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SEND_FABRIC_INQUIRY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveSendFabricInquiry?(message: response.value?.message ?? "Inquiry sent Successfully")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveSendFabricInquiry?(errorMessage: response.value?.message ?? "Inquiry Not Sent")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveSendFabricInquiry?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func createNewSuppliers(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveCreateNewSuppliers?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.ADD_FABRIC_CONTACT)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.ADD_FABRIC_CONTACT, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveCreateNewSuppliers?(message: response.value?.message ?? "New Supplier Created Successfully")
                }else if let error = response.value?.errors{
                    if let contactNumberError = error.contact_number{
                        self?.fabricDelegate?.didFailedToReceiveCreateNewSuppliers?(errorMessage: contactNumberError[0])
                    }else if let emailError = error.contact_email{
                        self?.fabricDelegate?.didFailedToReceiveCreateNewSuppliers?(errorMessage: emailError[0])
                    }
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveCreateNewSuppliers?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveCreateNewSuppliers?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getSuppliersResponse(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveGetSuppliersResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.INQUIRY_SUPPLIER_RESPONSE)")
        
        let resource = Resource<FabricSupplierResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.INQUIRY_SUPPLIER_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveGetSuppliersResponse?(data: response.value?.data)
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveGetSuppliersResponse?(errorMessage: response.value?.message ?? "Supplier List Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveGetSuppliersResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func getSuppliersListResponse(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveGetSuppliersListResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.GET_SUPPLIER_LIST_RESPONSE)")
        
        let resource = Resource<FabricSupplierListResponse, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.GET_SUPPLIER_LIST_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveGetSuppliersListResponse?(data: response.value?.data,
                                                                              currency: response.value?.currency ?? "")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveGetSuppliersListResponse?(errorMessage: response.value?.message ?? "Supplier List Response Not Found")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveGetSuppliersListResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func saveFabricSuppliersResponse(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveSaveSupplierResponse?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.SAVE_FABRIC_INQUIRY_SUPPLIER_RESPONSE)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.SAVE_FABRIC_INQUIRY_SUPPLIER_RESPONSE, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveSaveSupplierResponse?(message: response.value?.message ?? "Supplier Response saved Successfully")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveSaveSupplierResponse?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveSaveSupplierResponse?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
    func deleteFabricInquiry(params: [String: Any]) {
        if !Reachability.isConnectedToNetwork() {
            self.fabricDelegate?.didFailedToReceiveDeleteFabricInquiry?(errorMessage: LocalizationManager.shared.localizedString(key: "no_internet_msg"))
            return
        }
        
        RMLogs.shared.log(type: .INFO, tag: self.logTag, message: "Call | API - \(Config.API.DELETE_FABRIC_INQUIRY)")
        
        let resource = Resource<DMSSuccess, DMSError>(jsonDecoder: JSONDecoder(), path: Config.API.DELETE_FABRIC_INQUIRY, method: .post, params: params, headers: [:])
        UIViewController.sharedWebClient.load(resource: resource) { [weak self] response in
            DispatchQueue.main.async { [self] in
                if response.value?.status_code == Config.ErrorCode.SUCCESS{
                    self?.fabricDelegate?.didReceiveDeleteFabricInquiry?(message: response.value?.message ?? "Fabric Inquiry Deleted Successfully")
                }else if response.value?.status_code == Config.ErrorCode.NOT_FOUND{
                    self?.fabricDelegate?.didFailedToReceiveDeleteFabricInquiry?(errorMessage: response.value?.message ?? "")
                }else if let error = response.error as NSError?, error.code == Config.ErrorCode.UN_AUTHENTICATED{
                    self?.handleRestError(error: error)
                }else {
                    self?.fabricDelegate?.didFailedToReceiveDeleteFabricInquiry?(errorMessage: response.value?.message as? String ?? LocalizationManager.shared.localizedString(key: "something_went_wrong"))
                }
            }
        }
    }
    
}

