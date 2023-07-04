//
//  CreateNewSuppliersVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 28/03/23.
//

import UIKit
import MaterialComponents

class CreateNewSuppliersVC: UIViewController {

    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var suppliersTextField:MDCOutlinedTextField!
    @IBOutlet var contactPersonTextField:MDCOutlinedTextField!
    @IBOutlet var contactNumberTextField:MDCOutlinedTextField!
    @IBOutlet var emailTextField:MDCOutlinedTextField!
    @IBOutlet var addressTextField:MDCOutlinedTextField!
    @IBOutlet var cityTextField:MDCOutlinedTextField!
    @IBOutlet var saveButton:UIButton!
   
    weak var activeField: UITextField?
    var suppliersDelegate: AddFabricSuppliersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewSuppliersVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewSuppliersVC.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
        self.sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "createNewSuppliersText")
        
        [suppliersTextField, contactPersonTextField, contactNumberTextField, emailTextField, addressTextField, cityTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .words
        }
        
        self.setup(suppliersTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "suppliersText")) *")
        self.setup(contactPersonTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "contactPersonText")) *")
        self.setup(contactNumberTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "contactNumberText")) *")
        self.setup(emailTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "emailText")) *")
        self.setup(addressTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "addressText")) *")
        self.setup(cityTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "cityText")) *")
        
        self.saveButton.backgroundColor = .fabricPrimaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton){
        if self.inputFieldsValidation() == false{
            return
        }
   
        let params:[String:Any] = [
            "supplier" : self.suppliersTextField.text ?? "",
            "contact_person" : self.contactPersonTextField.text ?? "",
            "contact_number" : self.contactNumberTextField.text ?? "",
            "contact_email" : self.emailTextField.text ?? "",
            "address" : self.addressTextField.text ?? "",
            "city" : self.cityTextField.text ?? "" ]
        print(params)
        self.showHud()
        RestCloudService.shared.createNewSuppliers(params: params)
    }
    
    private func inputFieldsValidation() -> Bool{
        var message:String?
        
        if (self.suppliersTextField.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "suppliersText"))"
        }else if (self.contactPersonTextField.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "contactPersonText"))"
        }else if (self.contactNumberTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "contactNumberText"))"
        }else if (self.emailTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "emailText"))"
        }else if (self.addressTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "addressText"))"
        }else if (self.cityTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "cityText"))"
        }
        if message != nil{
            UIAlertController.showAlert(message: message ?? "", target: self)
            return false
        }
        return true
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

extension CreateNewSuppliersVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateNewSuppliersVC: RCFabricDelegate{
    
    // Create New suppliers
    func didReceiveCreateNewSuppliers(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.suppliersDelegate?.AddFabricSuppliersList()
                self.dismissViewController()
            }
        })
    }
    func didFailedToReceiveCreateNewSuppliers(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }

}
