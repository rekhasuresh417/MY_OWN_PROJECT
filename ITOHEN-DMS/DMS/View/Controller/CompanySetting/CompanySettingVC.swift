//
//  CompanySettingVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 29/07/22.
//

import UIKit
import MaterialComponents

class CompanySettingVC: UIViewController {
    @IBOutlet var topView:UIView!
    @IBOutlet weak var companyLogoView: UIView!
    @IBOutlet weak var companyInfoView: UIView!
    @IBOutlet weak var addressInfoView: UIView!
    @IBOutlet weak var uploadLogoView: DashedView!
    @IBOutlet weak var companyNameTextField: MDCOutlinedTextField!{
        didSet { companyNameTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var contactPersonTextField: MDCOutlinedTextField!{
        didSet { contactPersonTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var contactNumberTextField: MDCOutlinedTextField!{
        didSet { contactNumberTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var addressLine1TextField: MDCOutlinedTextField!{
        didSet { addressLine1TextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var addressLine2TextField: MDCOutlinedTextField!{
        didSet { addressLine2TextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var cityTextField: MDCOutlinedTextField!{
        didSet { cityTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var stateTextField: MDCOutlinedTextField!{
        didSet { stateTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var zipCodeTextField: MDCOutlinedTextField!{
        didSet { zipCodeTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    func setupUI(){
        self.topView.applyTopViewStyle(radius: 10.0)
        
        [companyLogoView, companyInfoView, addressInfoView].forEach{ (theView) in
            theView?.backgroundColor = .white
            theView?.roundCorners(corners: .allCorners, radius: 8.0)
        }
        
        uploadLogoView.layer.cornerRadius = uploadLogoView.frame.size.width/2
   
        [companyNameTextField, contactNumberTextField, contactPersonTextField, addressLine1TextField, addressLine2TextField, cityTextField, stateTextField, zipCodeTextField].forEach { (textField) in
            textField?.textAlignment = .left
            textField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            textField?.textColor = .customBlackColor()
            textField?.delegate = self
            textField?.keyboardType = .default
            if textField == companyNameTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.companyNameTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "companyName_text"))
            }else if textField == self.contactPersonTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.contactPersonTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "contactName_text"))
            }else if textField == self.contactNumberTextField{
                textField?.keyboardType = .phonePad
                self.setup(self.contactNumberTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "contactNumber_text"))
            }else if textField == self.addressLine1TextField{
                textField?.keyboardType = .emailAddress
                self.setup(self.addressLine1TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "address1_text"))
            }else if textField == self.addressLine2TextField{
                self.setup(self.addressLine2TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "address2_text"))
            }else if textField == self.cityTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.cityTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "city_text"))
            }else if textField == self.stateTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.stateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "state_text"))
            }else if textField == self.zipCodeTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.zipCodeTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "zipcode_text"))
            }
        }
        
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
    }
    
}

extension CompanySettingVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
