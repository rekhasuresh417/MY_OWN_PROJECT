//
//  TaskUpdateFilterVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 09/10/21.
//

import UIKit
import MaterialComponents

protocol TaskUpdateFilterProtocol {
    func setResultOfOrderListSorting(orderType: String)
}

class TaskUpdateFilterVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var firstTextField:MDCOutlinedTextField!{
        didSet { firstTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet var applyButton:UIButton!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var clearAllButton: UIButton!
    
    var delegate:TaskUpdateFilterProtocol?
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    let taskFilter = LocalizationManager.shared.localizedStrings(key: "taskFilter")
    var selectedTaskType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    func setupUI() {
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
        sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "pendingTaskVCSortTitle")
        
        firstTextField.tag = 0
        [firstTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default

            self.setup(firstTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "orderTypePlaceHolderText"))
         
        }
        if self.selectedTaskType != ""{
            firstTextField.text = self.selectedTaskType
            self.clearAllButton.isHidden = false
        }else{
            self.clearAllButton.isHidden = true
        }
        
        if self.selectedTaskType == "All Tasks"{
            thePicker.selectRow(0, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Scheduled Tasks"{
            thePicker.selectRow(1, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Not Schedule Tasks"{
            thePicker.selectRow(2, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Accomplished Tasks"{
            thePicker.selectRow(3, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Not Accomplished Tasks"{
            thePicker.selectRow(4, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Re-Scheduled Tasks"{
            thePicker.selectRow(5, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Not Re-Scheduled Tasks"{
            thePicker.selectRow(6, inComponent: 0, animated: true)
        }
        
        self.setupPickerViewWithToolBar()
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white

        self.clearAllButton.setTitle(LocalizationManager.shared.localizedString(key: "clearButtonTitleText"), for: .normal)
        self.clearAllButton.setTitleColor(.primaryColor(), for: .normal)
        self.clearAllButton.titleLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        self.clearAllButton.addTarget(self, action: #selector(self.clearAllButtonTapped(_:)), for: .touchUpInside)
        
        self.applyButton.backgroundColor = .primaryColor()
        self.applyButton.layer.cornerRadius = self.applyButton.frame.height / 2.0
        self.applyButton.setTitle(LocalizationManager.shared.localizedString(key: "applyButtonText"), for: .normal)
        self.applyButton.setTitleColor(.white, for: .normal)
        self.applyButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.applyButton.addTarget(self, action: #selector(self.applyButtonTapped(_:)), for: .touchUpInside)
        
        self.cancelButton.backgroundColor = .white
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        self.cancelButton.setTitleColor(.primaryColor(), for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: .touchUpInside)
        
    }
  
    func setupPickerViewWithToolBar() {
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.firstTextField.inputView = thePicker
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .primaryColor()
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.doneButtonTapped(_:)))
        toolBar.setItems([spaceButton1, doneButton], animated: false)
        
        self.firstTextField.inputAccessoryView = toolBar
    }
    
    @objc func applyButtonTapped(_ sender: UIButton) {
        if firstTextField.text == "" {
            UIAlertController.showAlert(message: "Please enter required field for filter",
                                        target: self)
        }else{
            self.delegate?.setResultOfOrderListSorting(orderType: self.firstTextField.text ?? "")
            self.dismissViewController()
        }
    }
    
    @objc func clearAllButtonTapped(_ sender: UIButton) {
        self.firstTextField.text = ""
        self.delegate?.setResultOfOrderListSorting(orderType: "")
        self.dismissViewController()
  
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        self.dismissViewController()
    }
  
    override func doneButtonTapped(_ sender: AnyObject) {
        let row =  self.thePicker.selectedRow(inComponent: 0)
    
        if activeField == self.firstTextField{
            self.firstTextField.text = taskFilter[row]
        }
        self.contentView.endEditing(true)
        thePicker.endEditing(true)
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion:nil)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 20.0 // Padding between the bottom of the view and the top of the keyboard
        
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

extension TaskUpdateFilterVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.selectedTaskType == "All Tasks"{
            thePicker.selectRow(0, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Scheduled Tasks"{
            thePicker.selectRow(1, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Not Schedule Tasks"{
            thePicker.selectRow(2, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Accomplished Tasks"{
            thePicker.selectRow(3, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Not Accomplished Tasks"{
            thePicker.selectRow(4, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Re-Scheduled Tasks"{
            thePicker.selectRow(5, inComponent: 0, animated: true)
        }else if self.selectedTaskType == "Not Re-Scheduled Tasks"{
            thePicker.selectRow(6, inComponent: 0, animated: true)
        }
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension TaskUpdateFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskFilter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskFilter[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.firstTextField.text = taskFilter[row]
    }
}
