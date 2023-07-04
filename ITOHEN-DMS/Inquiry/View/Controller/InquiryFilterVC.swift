//
//  InquiryFilterVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 23/02/23.
//

import UIKit
import MaterialComponents

class InquiryFilterVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var field1TextField:MDCOutlinedTextField!
    @IBOutlet var field2TextField:MDCOutlinedTextField!
    @IBOutlet var startDateTextField:MDCOutlinedTextField!
    @IBOutlet var endDateTextField:MDCOutlinedTextField!
    @IBOutlet var searchButton:UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var clearAllButton: UIButton!
    
    var target: UIViewController?
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    let theDatePicker = UIDatePicker()
    let theToolbarForDatePicker = UIToolbar()
    
    var factoryListData: [InquiryFactoryData]? = []
    var userListData: [InquiryArticlesData]? = []
    var articleListData: [InquiryArticlesData]? = []
  
    var filterFactoryId, filterArticleId, filterStartDate, filterEndDate: String?
    var filterBuyerDelegate:InquiryBuyerFilterDelegate?
    var filterFactoryDelegate:InquiryFactoryFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.bindData()
        self.setupUI()
        self.setupPickerViewWithToolBar()
        self.setupDatePickerViewWithToolBar()
    }
    
    func setupUI(){
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.topView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.topView.addGestureRecognizer(tap)
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        sectionTitleLabel.textColor = .customBlackColor()
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
      
        [field1TextField, field2TextField, startDateTextField, endDateTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .words
        }
        
        if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
            self.setup(field1TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "factoryText"), color: .inquiryPrimaryColor())
        }else{
            self.setup(field1TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "buyer/pcuText"), color: .inquiryPrimaryColor())
        }
        self.setup(field2TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "itemNameText"), color: .inquiryPrimaryColor())
        self.setup(startDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"), color: .inquiryPrimaryColor())
        self.setup(endDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"), color: .inquiryPrimaryColor())
       
        self.searchButton.backgroundColor = .inquiryPrimaryColor()
        self.searchButton.layer.cornerRadius = self.searchButton.frame.height / 2.0
        self.searchButton.setTitleColor(.white, for: .normal)
        self.searchButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.searchButton.setTitle(LocalizationManager.shared.localizedString(key: "applyButtonText"), for: .normal)
        
        cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)

        clearAllButton.layer.cornerRadius = self.clearAllButton.frame.height / 2.0
        clearAllButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .semibold)
        
        [cancelButton, clearAllButton].forEach { (theButton) in
            theButton.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.2)
            theButton.setTitleColor(.inquiryPrimaryColor(), for: .normal)
        }
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        self.clearAllButton.setTitle("   \(LocalizationManager.shared.localizedString(key: "clearButtonTitleText"))  ", for: .normal)
        
        self.searchButton.addTarget(self, action: #selector(self.searchButtonTapped(_:)), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: .touchUpInside)
        self.clearAllButton.addTarget(self, action: #selector(self.clearTextButtonTapped(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "filterTitle")
    }
   
    func bindData(){
        if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if let factory = factoryListData?.first(where: {$0.id == Int(filterFactoryId ?? "")}) {
                self.field1TextField.text = factory.factory
                self.field1TextField.tag = Int(filterFactoryId ?? "") ?? 0
            }
        }else{
            if let factory = userListData?.first(where: {$0.id == Int(filterFactoryId ?? "")}) {
                self.field1TextField.text = factory.name
                self.field1TextField.tag = Int(filterFactoryId ?? "") ?? 0
            }
        }
        
        if let article = articleListData?.first(where: {$0.id == Int(filterArticleId ?? "")}) {
            self.field2TextField.text = article.name
            self.field2TextField.tag = Int(filterArticleId ?? "") ?? 0
        }
        
        self.startDateTextField.text = self.filterStartDate
        self.endDateTextField.text = self.filterEndDate
    }
    
    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.field1TextField.inputView = thePicker
        self.field2TextField.inputView = thePicker
//        self.startDateTextField.inputView = thePicker
//        self.endDateTextField.inputView = thePicker
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .inquiryPrimaryColor()
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        toolBar.setItems([spaceButton1,doneButton], animated: false)
        
        self.field1TextField.inputAccessoryView = toolBar
        self.field2TextField.inputAccessoryView = toolBar
//        self.startDateTextField.inputAccessoryView = toolBar
//        self.endDateTextField.inputAccessoryView = toolBar
   
    }
   
    func setupDatePickerViewWithToolBar() {
        
        self.startDateTextField.delegate = self
        self.startDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.startDateTextField.inputView = self.theDatePicker
        
        self.endDateTextField.delegate = self
        self.endDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.endDateTextField.inputView = self.theDatePicker
        
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
    
    @objc override func doneButtonTapped(_ sender: AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            self.contentView.endEditing(true)
            thePicker.endEditing(true)
            return
        }
        
        if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if activeField == field1TextField && row < factoryListData?.count ?? 0{
                field1TextField?.text = factoryListData?[row].factory
                field1TextField?.tag = factoryListData?[row].id ?? 0
            }else if activeField == field2TextField && row < articleListData?.count ?? 0{
                field2TextField?.text = articleListData?[row].name
                field2TextField?.tag = articleListData?[row].id ?? 0
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if activeField == field1TextField && row < userListData?.count ?? 0{
                field1TextField?.text = userListData?[row].name
                field1TextField?.tag = userListData?[row].id ?? 0
            }else if activeField == field2TextField && row < articleListData?.count ?? 0{
                field2TextField?.text = articleListData?[row].name
                field2TextField?.tag = articleListData?[row].id ?? 0
            }
        }
        
        self.contentView.endEditing(true)
        thePicker.endEditing(true)
    }
    
    @objc func searchButtonTapped(_ sender: UIButton){
        if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
            self.filterBuyerDelegate?.filterBuyerInquiryList(filterFactoryId: "\(self.field1TextField.tag)",
                                                        filterArticleId: "\(self.field2TextField.tag)",
                                                        filterStartDate: self.startDateTextField.text ?? "",
                                                        filterEndDate: self.endDateTextField.text ?? "")
        }else{
            self.filterFactoryDelegate?.filterFactoryInquiryList(filterUserId: "\(self.field1TextField.tag)",
                                                        filterArticleId: "\(self.field2TextField.tag)",
                                                        filterStartDate: self.startDateTextField.text ?? "",
                                                        filterEndDate: self.endDateTextField.text ?? "")
        }
      
        self.dismissViewController()
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton){
        self.dismissViewController()
    }
    
    @objc func clearTextButtonTapped(_ sender: UIButton){
        self.field1TextField.text = ""
        self.field2TextField.text = ""
        self.startDateTextField.text = ""
        self.endDateTextField.text = ""
        
        self.field1TextField.tag = 0
        self.field2TextField.tag = 0

        filterFactoryId = ""
        filterArticleId = ""
        filterStartDate = ""
        filterEndDate = ""
        
        activeField?.text = ""
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
}

extension InquiryFilterVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if textField == field1TextField && factoryListData?.count ?? 0 > 0 && textField.text?.count == 0{
                field1TextField.text = factoryListData?[0].factory
                field1TextField.tag = factoryListData?[0].id ?? 0
            }else if textField == field2TextField && articleListData?.count ?? 0 > 0 && textField.text?.count == 0{
                field2TextField.text = articleListData?[0].name
                field2TextField.tag = articleListData?[0].id ?? 0
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if textField == field1TextField && userListData?.count ?? 0 > 0 && textField.text?.count == 0{
                field1TextField.text = userListData?[0].name
                field1TextField.tag = userListData?[0].id ?? 0
            }else if textField == field2TextField && articleListData?.count ?? 0 > 0 && textField.text?.count == 0{
                field2TextField.text = articleListData?[0].name
                field2TextField.tag = articleListData?[0].id ?? 0
            }
        }
    
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if textField == self.startDateTextField{
            let maxDate = DateTime.stringToDatetaskUpdate(dateString: self.endDateTextField.text ?? "", dateFormat: Date.simpleDateFormat)
            theDatePicker.minimumDate = nil
            theDatePicker.maximumDate = maxDate
        }else if textField == self.endDateTextField{
            let minDate = DateTime.stringToDatetaskUpdate(dateString: self.startDateTextField.text ?? "", dateFormat: Date.simpleDateFormat)
            theDatePicker.minimumDate = minDate
            theDatePicker.maximumDate = nil
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InquiryFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if activeField == field1TextField{
                return self.factoryListData?.count ?? 0
            }else if activeField == field2TextField{
                return self.articleListData?.count ?? 0
            }
        }else{
            if activeField == field1TextField{
                return self.userListData?.count ?? 0
            }else if activeField == field2TextField{
                return self.articleListData?.count ?? 0
            }
        }
   
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if RMConfiguration.shared.workspaceType == Config.Text.buyer || RMConfiguration.shared.workspaceType == Config.Text.pcu{
             if activeField == field1TextField && row < self.factoryListData?.count ?? 0{
                return factoryListData?[row].factory
             }else if activeField == field2TextField && row < self.articleListData?.count ?? 0{
                return articleListData?[row].name
            }
         }else{
             if activeField == field1TextField && row < self.userListData?.count ?? 0{
                return userListData?[row].name
             }else if activeField == field2TextField && row < self.articleListData?.count ?? 0{
                return articleListData?[row].name
            }
         }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
}

extension Array {
    func unique(selector:(Element,Element)->Bool) -> Array<Element> {
        return reduce(Array<Element>()){
            if let last = $0.last {
                return selector(last,$1) ? $0 : $0 + [$1]
            } else {
                return [$1]
            }
        }
    }
}
