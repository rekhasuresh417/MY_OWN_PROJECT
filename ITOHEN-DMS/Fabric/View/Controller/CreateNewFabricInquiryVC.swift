//
//  CreateNewFabricInquiryVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 16/03/23.
//

import UIKit
import MaterialComponents

class CreateNewFabricInquiryVC: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var yarnCountTextField: MDCOutlinedTextField!{
        didSet { yarnCountTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var yarnQtyTextField: MDCOutlinedTextField!{
        didSet { yarnQtyTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var yarnQtlyTextField: MDCOutlinedTextField!{
        didSet { yarnQtlyTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var materialTextField: MDCOutlinedTextField!{
        didSet { materialTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var compositionTextField: MDCOutlinedTextField!{
        didSet { compositionTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var currencyTextField: MDCOutlinedTextField!{
        didSet { currencyTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var inquiryRefTextField: MDCOutlinedTextField!{
        didSet { inquiryRefTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var deliveryDateTextField: MDCOutlinedTextField!
    @IBOutlet var inHouseDateTextField: MDCOutlinedTextField!
    @IBOutlet var createFabricInquiryButton: UIButton!
 
    weak var activeField: UITextField? {
        didSet{
            if activeField == yarnQtlyTextField || activeField == materialTextField || activeField == compositionTextField || activeField == currencyTextField || activeField == inquiryRefTextField {
                if activeField == yarnQtlyTextField{
                    self.pickerTitleLabel.text = LocalizationManager.shared.localizedString(key: "yarnQualityText")
                }else if activeField == materialTextField{
                    self.pickerTitleLabel.text = LocalizationManager.shared.localizedString(key: "materialText")
                }else if activeField == compositionTextField{
                    self.pickerTitleLabel.text = LocalizationManager.shared.localizedString(key: "compositionText")
                }else if activeField == currencyTextField{
                    self.pickerTitleLabel.text = LocalizationManager.shared.localizedString(key: "currencyText")
                }else if activeField == inquiryRefTextField{
                    self.pickerTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryReferenceText")
                }
                self.thePicker.reloadAllComponents()
            }
        }
    }
  
    var yarnQualityData: [FabricMasterData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var materialData: [FabricMasterData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var currencyData: [FabricCurrencyData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var compositionData: [FabricMasterData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var inqRefData: [FabricInquiryIds] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var randomNumber: String = ""
    var fabricInquiryDelegate: FabricInquiryListDelegate?
    
    let thePicker = UIPickerView()
    let pickerTitleLabel = UILabel()
    let toolBar = UIToolbar()
    let refToolBar = UIToolbar()
    let theDatePicker = UIDatePicker()
    let theToolbarForDatePicker = UIToolbar()
 
    // External Data
    var isEdit: Bool = false
    var inquiryId: String?
    var fabricData: [FabricInquityDetailsData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
        self.generateRandomNumber()
        self.getFabricMasterData()
        self.getFabricInquiryId()
        self.getCurrencies()
        if isEdit == true{
            self.getFabricInquiryDetails()
        }
        self.setupPickerViewWithToolBar()
        self.setupDatePickerViewWithToolBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewFabricInquiryVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewFabricInquiryVC.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.fabricDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .fabric)
        
        self.title = isEdit == false ? LocalizationManager.shared.localizedString(key:"addNewFabricInquiryText") : LocalizationManager.shared.localizedString(key:"editFabricInquiryText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        
        [yarnCountTextField, yarnQtyTextField, yarnQtlyTextField, materialTextField, compositionTextField, currencyTextField, inquiryRefTextField, deliveryDateTextField, inHouseDateTextField].forEach { (theTextField) in
            
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .none
        }
        self.setup(self.yarnCountTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"yarnCountText")) *", color: .fabricPrimaryColor())
        self.setup(self.yarnQtyTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"yarnQuantityText")) *", color: .fabricPrimaryColor())
        self.setup(self.yarnQtlyTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"yarnQualityText")) *", color: .fabricPrimaryColor())
        self.setup(self.materialTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"materialText")) *", color: .fabricPrimaryColor())
        self.setup(self.compositionTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"compositionText")) *", color: .fabricPrimaryColor())
        self.setup(self.currencyTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"currencyText")) *", color: .fabricPrimaryColor())
        self.setup(self.inquiryRefTextField, placeholderLabel: LocalizationManager.shared.localizedString(key:"inquiryReferenceText"), color: .fabricPrimaryColor())
        self.setup(self.deliveryDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key:"deliveryDateText"), color: .fabricPrimaryColor())
        self.setup(self.inHouseDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key:"inhouseDateText"), color: .fabricPrimaryColor())
        
        self.createFabricInquiryButton.backgroundColor = .fabricPrimaryColor()
        self.createFabricInquiryButton.layer.cornerRadius = self.createFabricInquiryButton.frame.height / 2.0
        self.createFabricInquiryButton.setTitle(isEdit == false ? LocalizationManager.shared.localizedString(key: "createText") : LocalizationManager.shared.localizedString(key: "updateButtonText"), for: .normal)
        self.createFabricInquiryButton.addTarget(self, action: #selector(createFabricInquiryButtonTapped(_:)), for: .touchUpInside)
    }

    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.yarnQtlyTextField.inputView = thePicker
        self.materialTextField.inputView = thePicker
        self.compositionTextField.inputView = thePicker
        self.currencyTextField.inputView = thePicker
        self.inquiryRefTextField.inputView = thePicker
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .primaryColor()
        toolBar.sizeToFit()
  
        refToolBar.barStyle = .default
        refToolBar.isTranslucent = true
        refToolBar.tintColor = .primaryColor()
        refToolBar.sizeToFit()
        
        let addNewButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "addNewText"), style: .plain, target: self, action: #selector(self.addNewButtonTapped(_:)))
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let pickerTitle = UIBarButtonItem.init(customView: self.pickerTitleLabel)
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton1 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        let doneButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
     
        // For yarn quality, meterial and composition  - have add new button
        toolBar.setItems([addNewButton, spaceButton1, pickerTitle, spaceButton2, doneButton1], animated: false)
        self.yarnQtlyTextField.inputAccessoryView = toolBar
        self.materialTextField.inputAccessoryView = toolBar
        self.compositionTextField.inputAccessoryView = toolBar
        
          // For inquiry ref  - only done button
          refToolBar.setItems([spaceButton1, spaceButton2, doneButton2], animated: false)
          self.inquiryRefTextField.inputAccessoryView = refToolBar
            self.currencyTextField.inputAccessoryView = refToolBar
    }
  
    func setupDatePickerViewWithToolBar() {
        
        self.deliveryDateTextField.delegate = self
        self.deliveryDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.deliveryDateTextField.inputView = self.theDatePicker
        
        self.inHouseDateTextField.delegate = self
        self.inHouseDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.inHouseDateTextField.inputView = self.theDatePicker
        
        theDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            theDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.theToolbarForDatePicker.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style:.plain, target: self, action: #selector(doneDateButtonTapped(_:)))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "cancelButtonText"), style: .plain, target: self, action: #selector(clearButtonTapped(_:)))
        self.theToolbarForDatePicker.setItems([clearButton2,spaceButton2,doneButton2], animated: false)
     
    }
   
    func generateRandomNumber(){
        self.randomNumber = self.random9DigitString()
    }
    
    // API Call
    func getFabricMasterData(){
        self.showHud()
        let params:[String:Any] =  [ "referenceId": self.randomNumber]
        print(params)
        RestCloudService.shared.getFabricMasterData(params: params)
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
 
    func getCurrencies(){
        self.showHud()
        RestCloudService.shared.getCurrencies(params: [:])
    }
    
    func getInquiryCurrency(inquiryId: String = ""){
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId]
        print(params)
        RestCloudService.shared.getInquiryCurrency(params: params)
    }
    
    func addNewMasterData(isYarnQuality: Bool = false, isMaterial: Bool = false, isComposition: Bool = false, content: String){
        self.showHud()
        var params:[String:Any] =  [ "content": content,
                                     "referenceId": self.randomNumber ]
        
        if isYarnQuality{
            params["type"] = FabricMasterType.yarnQuality.rawValue
        }else if isMaterial{
            params["type"] = FabricMasterType.material.rawValue
        }else if isComposition{
            params["type"] = FabricMasterType.composition.rawValue
        }
        print(params)
        RestCloudService.shared.addFabricMasterData(params: params)
    }
    
    private func getFabricInquiryDetails(){
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": self.inquiryId ?? ""]
        print(params)
        RestCloudService.shared.getFabricInquiryDetails(params: params)
    }
    
    private func bindData(){
        self.yarnCountTextField.text = "\(self.fabricData?[0].yarn_count ?? "")"
        self.yarnQtyTextField.text = "\(self.fabricData?[0].yarn_quantity ?? "")"
        self.yarnQtlyTextField.text = "\(self.fabricData?[0].yarn_quality ?? "")"
        self.materialTextField.text = "\(self.fabricData?[0].meterial ?? "")"
        self.compositionTextField.text = "\(self.fabricData?[0].composition ?? "")"
        self.inquiryRefTextField.text = self.fabricData?[0].reference_inquiry == 0 ? "" : "\(self.fabricData?[0].reference_inquiry ?? 0)"
        self.currencyTextField.text = "\(self.fabricData?[0].currency ?? "")"
        self.deliveryDateTextField.text = "\(self.fabricData?[0].delivery_date ?? "")"
        self.inHouseDateTextField.text = "\(self.fabricData?[0].inhouse_date ?? "")"
    }
    
    @objc func addNewButtonTapped(_ sender: AnyObject){
        var title:String = ""
        if activeField ==  yarnQtlyTextField{
            title = LocalizationManager.shared.localizedString(key: "yarnQualityText")
        }else if activeField ==  materialTextField{
            title = LocalizationManager.shared.localizedString(key: "materialText")
        }else if activeField ==  compositionTextField{
            title = LocalizationManager.shared.localizedString(key: "compositionText")
        }
        self.showAlertWithTextField(title: title,
                                    textFieldText: "",
                                    placeHolderText: "",
                                    firstButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                    secondButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText")) { text, index in
            if text.count == 0 || text.isEmpty{
                return
            }
            
            if self.activeField ==  self.yarnQtlyTextField{
                self.addNewMasterData(isYarnQuality: true, content: text)
            }else if self.activeField ==  self.materialTextField{
                self.addNewMasterData(isMaterial: true, content: text)
            }else if self.activeField ==  self.compositionTextField{
                self.addNewMasterData(isComposition: true, content: text)
            }
        }
    }

    @objc func createFabricInquiryButtonTapped(_ sender: UIButton) {
        if (self.yarnCountTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "yarnCountText"))", target: self)
            return
        }
        
        if (self.yarnQtyTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "yarnQuantityText"))", target: self)
            return
        }
     
        if (self.yarnQtlyTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseSelectText")) \(LocalizationManager.shared.localizedString(key: "yarnQualityText"))", target: self)
            return
        }
        
        if (self.materialTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseSelectText")) \(LocalizationManager.shared.localizedString(key: "materialText"))", target: self)
            return
        }
        
        if (self.compositionTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseSelectText")) \(LocalizationManager.shared.localizedString(key: "compositionText"))", target: self)
            return
        }
        
        if (self.currencyTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseSelectText")) \(LocalizationManager.shared.localizedString(key: "currencyText"))", target: self)
            return
        }
       
        var params = ["company_id": RMConfiguration.shared.companyId,
                      "workspace_id": RMConfiguration.shared.workspaceId,
                      "user_id": RMConfiguration.shared.userId,
                      "staff_id": RMConfiguration.shared.staffId,
                      "yarn_count" : self.yarnCountTextField.text ?? "",
                      "yarn_quantity" : self.yarnQtyTextField.text ?? "",
                      "yarn_quality" : self.yarnQtlyTextField.text ?? "",
                      "meterial" : self.materialTextField.text ?? "",
                      "composition" : self.compositionTextField.text ?? "",
                      "currency" : self.currencyTextField.text ?? ""]
        
        if !(self.inquiryRefTextField.text ?? "").isEmptyOrWhitespace(){
            params["reference_inquiry"] = "\(self.inquiryRefTextField.tag)"
        }
        
        if !(self.deliveryDateTextField.text ?? "").isEmptyOrWhitespace(){
            params["delivery_date"] = self.deliveryDateTextField.text ?? ""
        }
        
        if !(self.inHouseDateTextField.text ?? "").isEmptyOrWhitespace(){
            params["inhouse_date"] = self.inHouseDateTextField.text ?? ""
        }
        print(params)
        self.showHud()
        if isEdit{ // Update Fabric Inquiry
            params["inquiry_id"] = self.inquiryId
            RestCloudService.shared.editFabricInquiry(params: params)
        }else{
            RestCloudService.shared.saveFabricInquiry(params: params)
        }

    }
 
    @objc override func doneButtonTapped(_ sender: AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            self.contentView.endEditing(true)
            thePicker.endEditing(true)
            return
        }
        self.contentView.endEditing(true)
        thePicker.endEditing(true)
    }
    
    @objc func doneDateButtonTapped(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.simpleDateFormat
        activeField?.text = formatter.string(from: theDatePicker.date)
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
   
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        activeField?.text = ""
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 30.0 // Padding between the bottom of the view and the top of the keyboard
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        guard let activeField = activeField, let keyboardHeight = keyboardSize?.height else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + verticalPadding, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        let activeRect = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CreateNewFabricInquiryVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        thePicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.yarnQtlyTextField && textField.text?.count == 0 && yarnQualityData.count > 0{
            textField.text = yarnQualityData[0].content
            textField.tag = yarnQualityData[0].id ?? 0
        }else if textField == self.materialTextField && textField.text?.count == 0 && materialData.count > 0{
            textField.text = materialData[0].content
            textField.tag = materialData[0].id ?? 0
        }else if textField == self.compositionTextField && textField.text?.count == 0 && compositionData.count > 0{
            textField.text = compositionData[0].content
            textField.tag = compositionData[0].id ?? 0
        }else if textField == self.currencyTextField && textField.text?.count == 0 && currencyData.count > 0{
            textField.text = "\(currencyData[0].symbol ?? "") \(currencyData[0].name ?? "")"
            textField.tag = currencyData[0].id ?? 0
        }else if textField == self.inquiryRefTextField && textField.text?.count == 0 && inqRefData.count > 0{
            textField.text = "IN-\(inqRefData[0].id ?? 0)"
            textField.tag = inqRefData[0].id ?? 0
            self.getInquiryCurrency(inquiryId: "\(inqRefData[0].id ?? 0)")
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension CreateNewFabricInquiryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == yarnQtlyTextField{
            return yarnQualityData.count
        }else if activeField == materialTextField{
            return materialData.count
        }else if activeField == compositionTextField{
            return compositionData.count
        }else if activeField == currencyTextField{
            return currencyData.count
        }else if activeField == inquiryRefTextField{
            return inqRefData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == yarnQtlyTextField{
            return yarnQualityData[row].content
        }else if activeField == materialTextField{
            return materialData[row].content
        }else if activeField == compositionTextField{
            return compositionData[row].content
        }else if activeField == currencyTextField{
            return "\(currencyData[row].symbol ?? "") \(currencyData[row].name ?? "")"
        }else if activeField == inquiryRefTextField{
            return "IN-\(inqRefData[row].id ?? 0)"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeField == yarnQtlyTextField && row < yarnQualityData.count{
            self.yarnQtlyTextField.text = yarnQualityData[row].content
            self.yarnQtlyTextField.tag = yarnQualityData[row].id ?? 0
        }else if activeField == materialTextField && row < materialData.count{
            self.materialTextField.text = materialData[row].content
            self.materialTextField.tag = materialData[row].id ?? 0
        }else if activeField == compositionTextField && row < compositionData.count{
            self.compositionTextField.text = compositionData[row].content
            self.compositionTextField.tag = compositionData[row].id ?? 0
        }else if activeField == currencyTextField && row < currencyData.count{
            self.currencyTextField.text = "\(currencyData[row].symbol ?? "") \(currencyData[row].name ?? "")"
            self.currencyTextField.tag = currencyData[row].id ?? 0
        }else if activeField == inquiryRefTextField && row < inqRefData.count{
            self.inquiryRefTextField.text = "IN-\(inqRefData[row].id ?? 0)"
            self.inquiryRefTextField.tag = inqRefData[row].id ?? 0
            self.getInquiryCurrency(inquiryId: "\(inqRefData[row].id ?? 0)")
        }
    }
}

extension CreateNewFabricInquiryVC: RCFabricDelegate{
    /// Get Fabric master data
    func didReceiveFabricMasterData(data: [FabricMasterData]?){
        self.hideHud()
        if let masterData = data{
            self.yarnQualityData = masterData.filter({$0.type ?? "" == FabricMasterType.yarnQuality.rawValue})
            self.materialData = masterData.filter({$0.type ?? "" == FabricMasterType.material.rawValue})
            self.compositionData = masterData.filter({$0.type ?? "" == FabricMasterType.composition.rawValue})
        }
    }
    func didFailedToReceiveFabricMasterData(errorMessage: String){
        self.hideHud()
    }
    
    /// Get Fabric inquiry Ids
    func didReceiveFabricInquiryId(data: [FabricInquiryIds]?){
        self.hideHud()
        if let inquiryIds = data{
            self.inqRefData = inquiryIds
        }
    }
    func didFailedToReceiveFabricInquiryId(errorMessage: String){
        self.hideHud()
    }
    
    /// Add Fabric Master Data
    func didReceiveAddFabricMasterData(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.getFabricMasterData()
            }
        })
    }
    func didFailedToReceiveAddFabricMasterData(errorMessage: String){
        self.hideHud()
    }
   
    // Get Fabric currencies
    func didReceiveCurrencies(data: [FabricCurrencyData]?){
        self.hideHud()
        if let currencyData = data{
            self.currencyData = currencyData
        }
    }
    func didFailedToReceiveCurrencies(errorMessage: String){
        self.hideHud()
    }
    
    // Get Fabric inquiry currency
    func didReceiveInquiryCurrency(data:String){
        self.hideHud()
        self.currencyTextField.text = data
    }
    func didFailedToReceiveInquiryCurrency(errorMessage: String){
        self.hideHud()
    }
    
    /// Save fabric inquiry
    func didReceiveSaveFabricInquiry(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.fabricInquiryDelegate?.fabricInquiryList()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    func didFailedToReceiveSaveFabricInquiry(errorMessage: String){
        self.hideHud()
    }
    
    /// Get fabric  inquiry details
    func didReceiveFabricInquiryDetails(data: [FabricInquityDetailsData]?) {
        self.hideHud()
        self.fabricData = data
        self.bindData()
    }
    func didFailedToReceiveFabricInquiryDetails(errorMessage: String){
        self.hideHud()
    }
}
