//
//  FactoryResponseVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 24/01/23.
//

import UIKit
import MaterialComponents

protocol FactoryResponseProtocol{
    func getBuyerInquiryList()
}

class FactoryResponseVC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var inquiryTitleLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var inquiryNoTextField: MDCOutlinedTextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    @IBOutlet var addFactoryResponseButton: UIButton!
    @IBOutlet var addfactoryResponseButtonHConstraint: NSLayoutConstraint!
    
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    
    var isFromDashboard: Bool = false
    var inquiryId: String = ""
    var factoryInquiryListResponse: FactoryInquiryListResponse?
    var inquiryListData: [InquiryListData]? = []
    var factoryResponseData: [FactoryResponseData]? = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.inquiryDelegate = self
        self.setupUI()
        self.setupPickerViewWithToolBar()
        self.getInquiryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.inquiryDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key: "factoyResponseText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        
        self.mainView.applyLightShadow()
        self.mainView.layer.borderWidth = 0.5
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainView.layer.cornerRadius = 10
        self.mainView.clipsToBounds = true
    
        self.setup(self.inquiryNoTextField,
                   placeholderLabel: LocalizationManager.shared.localizedString(key:"inquiryNoText"),
                   color: .inquiryPrimaryColor())
        self.inquiryNoTextField.textAlignment = .left
        self.inquiryNoTextField.keyboardType = .default
        self.inquiryNoTextField.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .none
     
        self.topViewHConstraint.constant = 60
        
        self.addFactoryResponseButton.isHidden = true
        self.addfactoryResponseButtonHConstraint.constant = 0
        
        if isFromDashboard {
            self.inquiryTitleLabel.isHidden = true
            self.topView.backgroundColor = .white
        }else{
            self.topView.backgroundColor = .appLightColor()
            self.inquiryTitleLabel.text = "\(LocalizationManager.shared.localizedString(key:"inquiryNoText")): IN-\(inquiryId)"
            self.inquiryNoTextField.isHidden = true
            self.arrowImageView.isHidden = true
            self.getFactoryResponse( inquiryId: self.inquiryId )
            self.getFactoryListResponse( inquiryId: self.inquiryId )

        }
        
        [addFactoryResponseButton].forEach { (theButton) in
            theButton?.backgroundColor = .inquiryPrimaryColor()
            theButton?.setTitleColor(.white, for: .normal)
            theButton?.layer.borderWidth  = 1.0
            theButton?.layer.cornerRadius = addFactoryResponseButton.frame.height / 2.0
            theButton?.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        }
        
        self.addFactoryResponseButton.setTitle("   \(LocalizationManager.shared.localizedString(key:"addFactoryResponseText"))   ", for: .normal)
        self.addFactoryResponseButton.addTarget(self, action: #selector(self.sendQuoteButtonTapped(_:)), for: .touchUpInside)
    }

    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.inquiryNoTextField.inputView = thePicker
      
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .inquiryPrimaryColor()
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        toolBar.setItems([spaceButton1,doneButton], animated: false)
        
        self.inquiryNoTextField.inputAccessoryView = toolBar
    }
    
    func getInquiryList() {
        self.showHud()
        let params:[String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                     "workspace_id": RMConfiguration.shared.workspaceId,
                                     "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.getInquiryList(params: params)
    }
    
    func getFactoryResponse(inquiryId: String) {
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId,
                                     "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.getFactoryResponse(params: params)
    }
    
    func getFactoryListResponse(inquiryId: String) {
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId,
                                     "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.getNonDMSFactoryList(params: params)
    }
    
    
    @objc func sendQuoteButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .addFactoryResponse) as? AddFactoryResponseVC {
            vc.factoryInquiryListResponse = self.factoryInquiryListResponse
            vc.delegate = self
            vc.inquiryId = self.inquiryId
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
  
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        activeField?.text = ""
        self.view.endEditing(true)
    }
    
    @objc override func doneButtonTapped(_ sender: AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            self.view.endEditing(true)
            thePicker.endEditing(true)
            return
        }
      
        if activeField == inquiryNoTextField && row < inquiryListData?.count ?? 0{
          
            self.inquiryNoTextField.text = "IN-\(self.inquiryListData?[row].id ?? 0)"
            self.getFactoryResponse(inquiryId: "\(self.inquiryListData?[row].id ?? 0)")
            self.getFactoryListResponse(inquiryId: "\(self.inquiryListData?[row].id ?? 0)")
            self.inquiryId = "\(self.inquiryListData?[row].id ?? 0)"
            self.inquiryNoTextField.resignFirstResponder()
        }
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }

    @objc func generatePOButtonTapped(_ sender: UIButton) {
            
        print("generate button clicked")
            DispatchQueue.main.async {
                if let bottomView = sender.superview?.superview{
                    if let mainView = bottomView.superview{
                        if let hasCell = mainView.superview as? FactoryResponseTableViewCell{
                            
                            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "confirmGeneratePOText"),
                                                        message: "",
                                                        firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                                        secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                                        target: self) { (status) in
                                if status == false{
                                    
                                    self.showHud()
                                    let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                                                  "workspace_id": RMConfiguration.shared.workspaceId,
                                                                  "inquiry_id": hasCell.data?.inquiry_id ?? "",
                                                                  "factory_id": hasCell.data?.factory_contact_id ?? ""]
                                    print(params)
                                    RestCloudService.shared.purchaseOrderDelegate = self
                                    RestCloudService.shared.generatePO(params: params)
                                }
                                
                            }
                        }
                    }
                }
            }
   
    }
}

extension FactoryResponseVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.factoryResponseData?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FactoryResponseTableViewCell
            if let data = self.factoryResponseData?[indexPath.row]{
                cell.setContent(data: data, isFrom: isFromDashboard, target: self)
            }
      
        let generatedData = self.factoryResponseData?.filter({$0.is_po_generated == 1})// Generated
        if generatedData?.count ?? 0 > 0{
            cell.generatePOButton.isUserInteractionEnabled = false
            cell.generatePOButton.tintColor = self.factoryResponseData?[indexPath.row].is_po_generated == 1 ? .inquiryPrimaryColor() : .customBlackColor()
        }else{ // Cancelled-2 or default-0
            cell.generatePOButton.isUserInteractionEnabled = true
            cell.generatePOButton.tintColor = .customBlackColor()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}

extension FactoryResponseVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == inquiryNoTextField && inquiryListData?.count ?? 0 > 0 && textField.text?.count == 0{
            inquiryNoTextField.text = "IN-\(self.inquiryListData?[0].id ?? 0)"
            inquiryNoTextField.tag = inquiryListData?[0].id ?? 0
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
}

extension FactoryResponseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == inquiryNoTextField{
            return self.inquiryListData?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == inquiryNoTextField{
            return "IN-\(self.inquiryListData?[row].id ?? 0)"
        }
        return ""
    }

}


extension FactoryResponseVC: RCInquiryDelegate{
   
    /// Get InquiryList
    func didReceiveInquiryList(data: InquiryListResponse?){
        self.hideHud()
        self.inquiryListData = data?.data?.data
    }
    
    func didFailedToReceiveInquiryList(errorMessage: String){
        self.hideHud()
    }
    
    /// Get  Factory Inquiry  list Response
    func didReceiveGetFactoryListResponse(response: FactoryInquiryListResponse?){
        self.hideHud()
        self.factoryInquiryListResponse = response
        self.addFactoryResponseButton.isHidden = self.factoryInquiryListResponse?.data?.count == 0 ? true : false
        self.addfactoryResponseButtonHConstraint.constant = self.factoryInquiryListResponse?.data?.count == 0 ? 0 : 35
    }
    
    func didFailedToReceiveGetFactoryListResponse(errorMessage: String){
        self.hideHud()
    }
    
    /// Get FactoryResponse
    func didReceiveFactoryResponse(data: [FactoryResponseData]?){
        self.hideHud()
        self.factoryResponseData = data
    }
    
    func didFailedToReceiveFactoryResponse(errorMessage: String){
        self.hideHud()
    }
}

extension FactoryResponseVC: RCPurchaseOrderDelegate{
    
    /// Generate PO
    func didReceiveGeneratePurchaseOrder(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.getFactoryResponse(inquiryId: self.inquiryId)
            }
        })
    }
    func didFailedToReceiveGeneratePurchaseOrder(errorMessage: String){
        self.hideHud()
    }
 
}
extension FactoryResponseVC: FactoryResponseProtocol {
    func getBuyerInquiryList() {
        self.getFactoryResponse(inquiryId: self.inquiryId)
        self.getFactoryListResponse(inquiryId: self.inquiryId)
    }
}
