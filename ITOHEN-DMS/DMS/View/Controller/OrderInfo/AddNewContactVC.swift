//
//  AddNewContactVC.swift
//  Itohen-dms
//
//  Created by Admin on 25/03/21.
//

import UIKit
import MaterialComponents

class AddNewContactVC: UIViewController {

    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var firstNameTextField:MDCOutlinedTextField!
    @IBOutlet var lastNameTextField:MDCOutlinedTextField!
    @IBOutlet var emailTextField:MDCOutlinedTextField!
    @IBOutlet var mobileNumberTextField:MDCOutlinedTextField!
    @IBOutlet var accessControlTextfield: MDCOutlinedTextField!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    
    @IBOutlet var guestSelectionButton: UIButton!
    @IBOutlet var staffSelectionButton: UIButton!
    
    @IBOutlet var positionTextfieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dropDownButton: UIButton!
 
    let thePicker = UIPickerView()
    var userRoles: [Roles] = []
    var workspaceType = [""]
    var workspaceId = [""]
    var basicInfoModel: BasicInfoModel?
    var activeField: UITextField?
    var ownLoginedUser: Bool = true
    var selectedRoleId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.orderContactDelegate = self
        self.getRoles()
        self.setupUI()
        self.setupPickerViewWithToolBar(textField: self.accessControlTextfield,
                                        target: self,
                                        thePicker: thePicker)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewContactVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewContactVC.keyboardWillBeHidden),
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
        sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "addNewUserTitle")
        
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        emailTextField.tag = 2
        mobileNumberTextField.tag = 3
        accessControlTextfield.tag = 4
        [firstNameTextField, lastNameTextField, emailTextField, mobileNumberTextField, accessControlTextfield].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            
            if theTextField == firstNameTextField{
                theTextField?.autocapitalizationType = .words
                self.setup(firstNameTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "firstNamePlaceHolderText"))
            }else if theTextField == lastNameTextField{
                theTextField?.autocapitalizationType = .words
                self.setup(lastNameTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "lastNamePlaceHolderText"))
            }else if theTextField == emailTextField{
                theTextField?.keyboardType = .emailAddress
                self.setup(emailTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "emailplaceHolderText"))
            }else if theTextField == mobileNumberTextField{
                self.setup(mobileNumberTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "mobileNumberPlaceHolderText"))
            }else if theTextField == accessControlTextfield{
                self.setup(accessControlTextfield, placeholderLabel: LocalizationManager.shared.localizedString(key: "positionplaceHolderText"))
            }
        }
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white
        
        self.saveButton.isUserInteractionEnabled = true
        self.saveButton.backgroundColor = .primaryColor()
        
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
 
        workspaceType.append(basicInfoModel?.data?.buyerName ?? "")
        workspaceId.append(basicInfoModel?.data?.buyerId ?? "")
        workspaceType.append(basicInfoModel?.data?.factoryName ?? "")
        workspaceId.append(basicInfoModel?.data?.factoryId ?? "")
        workspaceType.append(basicInfoModel?.data?.pcuName ?? "")
        workspaceId.append(basicInfoModel?.data?.pcuId ?? "")
        workspaceType = workspaceType.filter({ $0 != ""})
        workspaceId = workspaceId.filter({ $0 != ""})
    }
  
    func getRoles() {
        self.showHud()
        let params:[String:Any] = ["company_id": RMConfiguration.shared.companyId,
                                   "workspace_id": RMConfiguration.shared.workspaceId ]
        RestCloudService.shared.getContactRoles(params: params)
    }
    
    @objc override func doneButtonTapped(_ sender:AnyObject) {
      if activeField == self.accessControlTextfield {
            self.accessControlTextfield.resignFirstResponder()
        }
    }
    
    func updatesaveButtonStatus() {
        var status:Bool = true
        if (self.firstNameTextField.text ?? "").isEmptyOrWhitespace(){
            status = false
        }else if (self.emailTextField.text ?? "").isEmptyOrWhitespace(){
            status = false
        }else if (self.accessControlTextfield.text ?? "").isEmptyOrWhitespace(){
            status = false
        }else if self.emailTextField.text?.isValidEmail() == false && (self.firstNameTextField.text ?? "").isEmptyOrWhitespace() == false && (self.accessControlTextfield.text ?? "").isEmptyOrWhitespace() == false {
            status = false
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "validEmailText"), target: self)
        }
        
        if status{
            self.saveButton.isUserInteractionEnabled = true
            self.saveButton.backgroundColor = .primaryColor()
        }else{
            self.saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = .lightGray
        }
    }
   
    @objc func saveButtonTapped(_ sender: UIButton) {
        
        if self.inputFieldsValidation() == false{
            print("Failed on input validations..!")
            return
        }
        
        self.showHud()
   
        let params:[String:Any] = [
            "first_name" : self.firstNameTextField.text ?? "",
            "last_name" : self.lastNameTextField.text ?? "",
            "email" : self.emailTextField.text ?? "",
            "mobile" : self.mobileNumberTextField.text ?? "",
            "role_id" : selectedRoleId ?? "0",
            "order_id": RMConfiguration.shared.orderId,
            "user_id": RMConfiguration.shared.userId,
            "staff_id": RMConfiguration.shared.staffId,
            "company_id": RMConfiguration.shared.companyId,
            "workspace_id": RMConfiguration.shared.workspaceId
        ]
        print(params)
        RestCloudService.shared.AddContactStaff(params: params)
    }
  
    func inputFieldsValidation() -> Bool{
        var message:String?
       
        if (self.firstNameTextField.text ?? "").isEmptyOrWhitespace() {
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEntertext")) \(LocalizationManager.shared.localizedString(key: "firstNamePlaceHolderText"))"
        }else if (self.emailTextField.text ?? "").isEmptyOrWhitespace() {
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEntertext")) \(LocalizationManager.shared.localizedString(key: "emailplaceHolderText"))"
        }else if self.isValidEmail(email: self.emailTextField.text ?? "") == false && message == nil{
            message = LocalizationManager.shared.localizedString(key: "validEmailText")
        }else if !(self.mobileNumberTextField.text ?? "").isEmptyOrWhitespace() && self.isValidPhone(phone: self.mobileNumberTextField.text ?? "") == false && message == nil{
            message = LocalizationManager.shared.localizedString(key: "validMobileNumberText")
        }else if (self.accessControlTextfield.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEntertext")) \(LocalizationManager.shared.localizedString(key: "positionplaceHolderText"))"
        }
        
        if message != nil{
            UIAlertController.showAlert(message: message?.replacingOccurrences(of: "*", with: "") ?? "", target: self)
            return false
        }
        return true
    }
    
    @objc func dismissViewController(shouldReload:Bool = false) {
        self.dismiss(animated: true, completion: {
            if shouldReload{
                NotificationCenter.default.post(name: .reloadContactListVC, object: nil)
            }
        })
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion:nil)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 50.0 // Padding between the bottom of the view and the top of the keyboard
        
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

extension AddNewContactVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
       // self.updatesaveButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if textField == firstNameTextField{
            return count <= 50
        }else if textField == emailTextField{
            return count <= 80
        }
        return true
    }
    
}

extension AddNewContactVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.userRoles.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.userRoles[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.accessControlTextfield.text = self.userRoles[row].name
        self.selectedRoleId = "\(self.userRoles[row].id ?? 0)"
    }
}

extension AddNewContactVC: RCOrderContactDelegate {
   
    // Get roles delegate
    func didReceiveContactRoles(data: [Roles]?){
        self.hideHud()
        self.userRoles = data ?? []
    }
   
    func didFailedToReceiveContactRoles(errorMessage: String){
        self.hideHud()
    }
    
    // Add new staff
    func didReceiveNewStaff(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.dismissViewController(shouldReload: true)
            }
        })
    }
    
    func didFailedToReceiveNewStaff(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
}
