//
//  SendQuotationVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 28/01/23.
//

import UIKit
import MaterialComponents

protocol inquiryStatusProtocol{
    func callInquiryStatusList()
}

class SendQuotationVC: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var inquiryDateTitleLabel: UILabel!
    @IBOutlet var inquiryDateLabel: UILabel!
    @IBOutlet var styleNoTitleLabel: UILabel!
    @IBOutlet var styleNoLabel: UILabel!
    @IBOutlet var itemNameTitleLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var topViewDividerLabel: UILabel!
    @IBOutlet var priceTextField: MDCOutlinedTextField!
    @IBOutlet var commandTextView: UITextView!{
        didSet { commandTextView?.addDoneCancelToolbar() }
    }
    @IBOutlet var viewQuoteButton: UIButton!
    @IBOutlet var sendQuoteButton: UIButton!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var inquiryTitleLabel: UILabel!
    @IBOutlet var inquiryNoTextField: MDCOutlinedTextField!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    
    var delegate: inquiryStatusProtocol?
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var isFromDashboard: Bool = false
    var inquiryId: String = ""
    var factoryInquiryData: FactoryInquiryResponseData?
    var pdfURL: String = ""
    var factoryResponse: [Int] = []
    var inquiryListData: [FactoryInquiryResponseData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.inquiryDelegate = self
        self.setupUI()
        self.setupPickerViewWithToolBar()
        self.getFactoryInquiryList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SendQuotationVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SendQuotationVC.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       RestCloudService.shared.inquiryDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key: "sendQuoteText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        self.scrollView.backgroundColor = .white
        self.contentView.backgroundColor = .clear
       // self.scrollView.layer.borderWidth = 1.0
        //self.scrollView.layer.borderColor = UIColor(rgb: 0xF1F1F1).cgColor
        self.scrollView.layer.cornerRadius = 8
        self.scrollView.clipsToBounds = true
        self.scrollView.applyLightShadow()

        self.inquiryDateTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryDateText")
        self.styleNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "styleNoText")
        self.itemNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "itemNameText")
        
        [inquiryDateTitleLabel, styleNoTitleLabel, itemNameTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [inquiryDateLabel, styleNoLabel, itemNameLabel].forEach{ (theLabel) in
            theLabel?.text = "-"
            theLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
            theLabel?.textColor = .gray
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
        
        self.inquiryTitleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.inquiryTitleLabel.textColor = .customBlackColor()
        
        self.setup(self.inquiryNoTextField,
                   placeholderLabel: LocalizationManager.shared.localizedString(key:"inquiryNoText"),
                   color: .inquiryPrimaryColor())
        self.setup(self.priceTextField,
                   placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"priceText")) (in \(self.factoryInquiryData?.currency ?? "₹")) *",
    color: .inquiryPrimaryColor())
     
        [inquiryNoTextField, priceTextField].forEach { (theTextField) in
            theTextField?.textAlignment = .left
            theTextField?.keyboardType = theTextField == priceTextField ? .numberPad : .default
            theTextField?.delegate = self
        }
        self.addDoneButtonOnKeyboard(textField: priceTextField)
       // self.addDoneButtonOnKeyboard(textField: commandTextView)
        
        self.viewQuoteButton.backgroundColor = .inquiryPrimaryColor()
        self.viewQuoteButton.layer.cornerRadius = self.viewQuoteButton.frame.height / 2.0
        self.viewQuoteButton.setTitle("\(LocalizationManager.shared.localizedString(key: "viewQuoteText"))", for: .normal)
        self.viewQuoteButton.setTitleColor(.white, for: .normal)
        self.viewQuoteButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.viewQuoteButton.addTarget(self, action: #selector(self.viewQuoteButtonTapped(_:)), for: .touchUpInside)
        
        self.sendQuoteButton.backgroundColor = .inquiryPrimaryColor()
        self.sendQuoteButton.layer.cornerRadius = self.viewQuoteButton.frame.height / 2.0
        self.sendQuoteButton.setTitle("\(LocalizationManager.shared.localizedString(key: "sendQuoteText"))", for: .normal)
        self.sendQuoteButton.setTitleColor(.white, for: .normal)
        self.sendQuoteButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.sendQuoteButton.addTarget(self, action: #selector(self.sendQuoteButtonTapped(_:)), for: .touchUpInside)
                
        self.commandTextView.layer.borderColor = UIColor.gray.cgColor
        self.commandTextView.layer.borderWidth = 1.0
        self.commandTextView.layer.cornerRadius = 8
        
        self.commandTextView.text = "\(LocalizationManager.shared.localizedString(key: "commantsText")) *"
        self.commandTextView.textColor = UIColor.gray
        
        self.commandTextView.delegate = self
        self.topViewHConstraint.constant = 60
        
        if isFromDashboard {
            self.inquiryTitleLabel.isHidden = true
            self.topViewDividerLabel.isHidden = true
            self.bottomView.isHidden = true
        }else{
            self.inquiryTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "inquiryNoText")): IN-\(inquiryId)"
            self.inquiryNoTextField.isHidden = true
            self.arrowImageView.isHidden = true
            self.bottomView.isHidden = false
            self.topViewDividerLabel.isHidden = false
            
            self.styleNoLabel.text = self.factoryInquiryData?.style_no
            self.inquiryDateLabel.text = DateTime.convertDateFormater(self.factoryInquiryData?.created_date ?? "",
                                                                      currentFormat: Date.simpleDateFormat,
                                                                      newFormat: RMConfiguration.shared.dateFormat)
            self.itemNameLabel.text = self.factoryInquiryData?.name
        }
        
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
    
    func getFactoryInquiryList() {
        self.showHud()
        let params:[String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                     "workspace_id": RMConfiguration.shared.workspaceId,
                                     "factory_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.getFactoryInquiryList(params: params)
    }
    
    func saveFactoryInquiry() {
        self.showHud()
   
       /* Facyory ID = ADMIN ID
        //For Admin/User Login
        factoryId - user_id
        userId - user_id
        
        // For Staff Login
        factoryId - user_id
        userId - staff_id
        */
    
        var userId: String = ""
        if RMConfiguration.shared.loginType == Config.Text.user{
            userId = RMConfiguration.shared.userId
        }else{
            userId = RMConfiguration.shared.staffId
        }
        
        let params:[String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                     "workspace_id": RMConfiguration.shared.workspaceId,
                                     "factory_id": RMConfiguration.shared.userId,
                                     "user_id": userId,
                                     "user_type": RMConfiguration.shared.loginType,
                                     "inquiry_id": self.inquiryId,
                                     "price": self.priceTextField.text ?? "",
                                     "comments": self.commandTextView.text ?? ""]
        print(params)
        RestCloudService.shared.saveFactoryInquiryResponse(params: params)
    }
    
    func getFactoryResponse( inquiryId: String ) {
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId ]
        print(params)
        RestCloudService.shared.getFactoryResponse(params: params)
    }
   
    func readInquiryNotification( inquiryId: String ) {
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId,
                                     "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.readInquiryNotification(params: params)
    }
     
    @objc func viewQuoteButtonTapped(_ sender: UIButton){
        self.pdfURL.append("\(self.inquiryId).pdf")
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .pdfView) as? PDFViewVC {
                vc.pdfURL = self.pdfURL
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func sendQuoteButtonTapped(_ sender: UIButton){
        if isFromDashboard  && self.inquiryId.isEmpty{
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "chooseText")) \(LocalizationManager.shared.localizedString(key: "inquiryNoText"))", target: self)
            return
        }else if (self.priceTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "priceText"))", target: self)
            return
        }else if (self.commandTextView.text ?? "").isEmptyOrWhitespace() || self.commandTextView.text == "\(LocalizationManager.shared.localizedString(key: "commantsText")) *"{
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText"))\(LocalizationManager.shared.localizedString(key: "commantsText"))", target: self)
            return
        }else{
            self.saveFactoryInquiry()
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 30.0 // Padding between the bottom of the view and the top of the keyboard
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        guard let activeField = commandTextView, let keyboardHeight = keyboardSize?.height else { return }
        
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
            self.styleNoLabel.text = "\(self.inquiryListData?[row].style_no ?? "")"
            self.inquiryDateLabel.text = DateTime.convertDateFormater("\(self.inquiryListData?[row].created_date ?? "")",
                                                                      currentFormat: Date.simpleDateFormat,
                                                                      newFormat: RMConfiguration.shared.dateFormat)
            self.itemNameLabel.text = "\(self.inquiryListData?[row].name ?? "")"
            self.inquiryId = "\(self.inquiryListData?[row].id ?? 0)"
            self.readInquiryNotification(inquiryId: "\(self.inquiryListData?[row].id ?? 0)")
        }
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }
}

extension SendQuotationVC: UITextFieldDelegate{
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
        if textField == inquiryNoTextField{
            self.bottomView.isHidden = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == inquiryNoTextField{
            self.bottomView.isHidden = false
        }
    }
}

extension SendQuotationVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmptyOrWhitespace() {
            textView.text = "\(LocalizationManager.shared.localizedString(key: "commantsText")) *"
            textView.textColor = UIColor.gray
            textView.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

extension SendQuotationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension SendQuotationVC: RCInquiryDelegate{
   
    /// Get Factory InquiryList
    func didReceiveFactoryInquiryList(data: FactoryInquiryResponse?, response: [Int]?){
        self.hideHud()
        self.pdfURL = data?.pdfPath ?? ""

        self.inquiryListData = data?.data?.data?.filter {
            !(response?.contains($0.id ?? 0) ?? false)
        }
    }
    
    func didFailedToReceiveFactoryInquiryList(errorMessage: String){
        self.hideHud()
    }
    
    /// Save  Factory Inquiry Response
    func didReceiveSaveFactoryResponse(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.delegate?.callInquiryStatusList()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func didFailedToReceiveSaveFactoryResponse(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
    
    /// Read Inquiry Notification Response
    func didReceiveReadInquiryNotificationResponse(message: String){
        self.hideHud()
    }
    func didFailedToReadInquiryNotificationResponse(errorMessage: String){
        self.hideHud()
    }
}
