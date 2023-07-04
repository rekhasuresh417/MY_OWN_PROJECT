//
//  InquiryFilterVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 23/02/23.
//

import UIKit
import MaterialComponents

class FabricInquiryFilterVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
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
    var filterFabricDelegate:FabricInquiryFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.bindData()
        self.setupUI()
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
      
        [startDateTextField, endDateTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .words
        }
     
        self.setup(startDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
        self.setup(endDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
       
        self.searchButton.backgroundColor = .fabricPrimaryColor()
        self.searchButton.layer.cornerRadius = self.searchButton.frame.height / 2.0
        self.searchButton.setTitleColor(.white, for: .normal)
        self.searchButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.searchButton.setTitle(LocalizationManager.shared.localizedString(key: "applyButtonText"), for: .normal)
        
        cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.fabricPrimaryColor().cgColor
        cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)

        clearAllButton.layer.cornerRadius = self.clearAllButton.frame.height / 2.0
        clearAllButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .semibold)
        
        [cancelButton, clearAllButton].forEach { (theButton) in
            theButton.backgroundColor = .fabricPrimaryColor(withAlpha: 0.2)
            theButton.setTitleColor(.fabricPrimaryColor(), for: .normal)
        }
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        self.clearAllButton.setTitle("   \(LocalizationManager.shared.localizedString(key: "clearButtonTitleText"))  ", for: .normal)
        
        self.searchButton.addTarget(self, action: #selector(self.searchButtonTapped(_:)), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: .touchUpInside)
        self.clearAllButton.addTarget(self, action: #selector(self.clearTextButtonTapped(_:)), for: .touchUpInside)
       
        // enable/disable search button
        self.updateSearcButton()
    }
 
    func bindData(){
        self.startDateTextField.text = self.filterStartDate
        self.endDateTextField.text = self.filterEndDate
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
        let clearButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "cancelButtonText"), style: .plain, target: self, action: #selector(doneDateButtonTapped(_:)))
        self.theToolbarForDatePicker.setItems([clearButton2,spaceButton2,doneButton2], animated: false)
    }
    
    @objc func doneDateButtonTapped(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.simpleDateFormat
        activeField?.text = formatter.string(from: theDatePicker.date)
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
        self.updateSearcButton()
    }
 
    func updateSearcButton(){
        if self.startDateTextField.text?.isEmptyOrWhitespace() == false && self.endDateTextField.text?.isEmptyOrWhitespace() == false{
            self.enableSearchButton()
        }else{
            self.disableSearchButton()
        }
    }
    
    func enableSearchButton(){
        self.searchButton.isEnabled = true
        self.searchButton.isUserInteractionEnabled = true
        self.searchButton.alpha = 1.0
    }
    
    func disableSearchButton(){
        self.searchButton.isEnabled = false
        self.searchButton.isUserInteractionEnabled = false
        self.searchButton.alpha = 0.5
    }
    
    @objc func searchButtonTapped(_ sender: UIButton){
        self.filterFabricDelegate?.filterFabricInquiryList(filterStartDate: self.startDateTextField.text ?? "",
                                                    filterEndDate: self.endDateTextField.text ?? "")
        self.dismissViewController()
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton){
        self.dismissViewController()
    }
    
    @objc func clearTextButtonTapped(_ sender: UIButton){
  
        self.enableSearchButton()
        
        self.startDateTextField.text = ""
        self.endDateTextField.text = ""
  
        filterStartDate = ""
        filterEndDate = ""
        
        activeField?.text = ""
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
}

extension FabricInquiryFilterVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
