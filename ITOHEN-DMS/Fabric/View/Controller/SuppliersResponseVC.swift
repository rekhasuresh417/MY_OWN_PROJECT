//
//  SuppliersResponseVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 03/04/23.
//

import UIKit
import MaterialComponents

class SuppliersResponseVC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var inquiryNoTextField: MDCOutlinedTextField!
    @IBOutlet var tableView: UITableView!
    
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    
    var inquiryListData: [InquiryListData]? = []
    var supplierData: [FabricSupplierData] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var fabricSupplierListData: [FabricSupplierListData] = []
    var inquiryId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
        self.getFabricInquiryId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.fabricDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .fabric)
        self.title = LocalizationManager.shared.localizedString(key:"selectSuppliersText")
    }
    
    func setupUI(){
        
        self.mainView.backgroundColor = UIColor(rgb: 0xF2F4F3)
        self.topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
       
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear

        self.setup(self.inquiryNoTextField,
                   placeholderLabel: LocalizationManager.shared.localizedString(key:"inquiryNoText"),
                   color: .inquiryPrimaryColor())
        self.inquiryNoTextField.textAlignment = .left
        self.inquiryNoTextField.keyboardType = .default
        self.inquiryNoTextField.delegate = self
        
    }
    
    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.inquiryNoTextField.inputView = thePicker
      
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .primaryColor()
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        toolBar.setItems([spaceButton1,doneButton], animated: false)
        
        self.inquiryNoTextField.inputAccessoryView = toolBar
    }
  
    func getFabricInquiryId(){
        self.showHud()
        let params:[String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                     "workspace_id": RMConfiguration.shared.workspaceId,
                                     "user_id": RMConfiguration.shared.userId,
                                     "user_type": RMConfiguration.shared.workspaceType,
                                     "login_type": RMConfiguration.shared.loginType]
        print(params)
        RestCloudService.shared.getFabricInquiryIds(params: params)
    }

    private func getSuppliersListResponse(){
        self.showHud()
        let params:[String:Any] =  ["inquiry_id": self.inquiryId]
        print(params)
        RestCloudService.shared.getSuppliersListResponse(params: params)
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
          
            self.inquiryId = "\(self.inquiryListData?[row].id ?? 0)"
            self.inquiryNoTextField.text = "IN-\(self.inquiryListData?[row].id ?? 0)"
            self.getSuppliersListResponse()
            self.inquiryNoTextField.resignFirstResponder()
        }
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }
}

extension SuppliersResponseVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.supplierData.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SupplierResponseTableViewCell
        cell.setContent(index: indexPath.row,
                        data: self.supplierData[indexPath.row],
                        target: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension SuppliersResponseVC: UITextFieldDelegate{
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

extension SuppliersResponseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension SuppliersResponseVC: RCFabricDelegate{
    
    // Get suppliers List response
    func didReceiveGetSuppliersListResponse(data: [FabricSupplierListData]?){
        self.hideHud()
        if let supplierListData = data{
            self.fabricSupplierListData = supplierListData
        }
    }
    func didFailedToReceiveGetSuppliersListResponse(errorMessage: String){
        self.hideHud()
    }
}

