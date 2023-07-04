//
//  SignUpVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

class SignUpVC: UIViewController {

    @IBOutlet var topView:UIView!
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var haveAccountLabel:UILabel!
    @IBOutlet var signInButton:UIButton!
    
    @IBOutlet var firstNameTextField:MDCOutlinedTextField!
    @IBOutlet var lastNameTextField:MDCOutlinedTextField!
    @IBOutlet var emailIdTextField:MDCOutlinedTextField!
    @IBOutlet var mobileNumberTextField:MDCOutlinedTextField!
    @IBOutlet var userTypeTextField:MDCOutlinedTextField!
    @IBOutlet var countryTextField: MDCOutlinedTextField!
    @IBOutlet var languageTextField: MDCOutlinedTextField!
    @IBOutlet var tickMarkButton:UIButton!
    @IBOutlet var termsAndConditionsButton:UIButton!
    @IBOutlet var submitButton:UIButton!
    @IBOutlet var mobileNumberOptionalLabel:UILabel!
    @IBOutlet var userTypeArrowButton:UIButton!
    @IBOutlet var countryArrowButton: UIButton!
    @IBOutlet var languageArrowButton: UIButton!
    
    weak var activeField: UITextField?
    let thePicker = UIPickerView()
    let userTypes = LocalizationManager.shared.localizedStrings(key: "userTypes")
    let termsAndConditionsText = LocalizationManager.shared.localizedStrings(key: "termsAndConditionsText")
    
    var languages: [Languages]? = []
    var countries: [Countries]? = []
    var textField: UITextField? = nil
    
    var selectedUserType: Int = 1
    var selectedCountry: Int = 1
    var selectedLanguage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.userDelegate = self
        self.getLanguages()
        self.getCountries()
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI(){
        self.topView.applyTopViewStyle(radius: 10.0)
        self.contentView.backgroundColor = .white
        self.contentView.roundCorners(corners: .allCorners, radius: 8.0)
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.contentView.layer.shadowRadius = 10.0
        self.contentView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.contentView.layer.masksToBounds = false
        
        self.titleLabel.text = LocalizationManager.shared.localizedString(key: "titleText")
        self.titleLabel.numberOfLines = 1
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = UIFont.appFont(ofSize: 20.0, weight: .bold)
        
        self.haveAccountLabel.text = LocalizationManager.shared.localizedString(key: "alreadyHaveAccountText")
        self.haveAccountLabel.numberOfLines = 1
        self.haveAccountLabel.textColor = .customBlackColor()
        self.haveAccountLabel.textAlignment = .right
        self.haveAccountLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        
        self.signInButton.backgroundColor = .clear
        self.signInButton.setTitle(LocalizationManager.shared.localizedString(key: "signInText"), for: .normal)
        self.signInButton.setTitleColor(UIColor.init(rgb: 0xE81D2D), for: .normal)
        self.signInButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.signInButton.addTarget(self, action: #selector(self.signInButtonTapped(_:)), for: .touchUpInside)
        
        self.submitButton.backgroundColor = .primaryColor()
        self.submitButton.layer.cornerRadius = self.submitButton.frame.height / 2.0
        self.submitButton.setTitle(LocalizationManager.shared.localizedString(key:"submitButtonText"), for: .normal)
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.submitButton.addTarget(self, action: #selector(self.submitButtonTapped(_:)), for: .touchUpInside)

        self.tickMarkButton.tag = 0 //uncheck state
        self.tickMarkButton.setImage(nil, for: .normal)
        self.tickMarkButton.layer.borderWidth = 1.0
        self.tickMarkButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.tickMarkButton.layer.cornerRadius = 5.0
        self.tickMarkButton.addTarget(self, action: #selector(self.tickMarkButtonTapped(_:)), for: .touchUpInside)
        
        let att = NSMutableAttributedString(string: "\(self.termsAndConditionsText[0])\(self.termsAndConditionsText[1])");
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.customBlackColor(), range: NSRange(location: 0, length: self.termsAndConditionsText[0].count))
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primaryColor(), range: NSRange(location: self.termsAndConditionsText[0].count, length: self.termsAndConditionsText[1].count))
        termsAndConditionsButton.setAttributedTitle(att, for: .normal)
        self.termsAndConditionsButton.titleLabel?.font = UIFont.appFont(ofSize: 14.0, weight: .regular)
        self.termsAndConditionsButton.addTarget(self, action: #selector(self.termsAndConditionsButtonTapped(_:)), for: .touchUpInside)

        self.mobileNumberOptionalLabel.text = LocalizationManager.shared.localizedString(key: "optionalText")
        self.mobileNumberOptionalLabel.numberOfLines = 1
        self.mobileNumberOptionalLabel.textColor = UIColor.init(rgb: 0x898A8F)
        self.mobileNumberOptionalLabel.textAlignment = .right
        self.mobileNumberOptionalLabel.font = UIFont.appFont(ofSize: 10.0, weight: .regular)
        
        self.userTypeArrowButton.addTarget(self, action: #selector(self.userTypeArrowButtonTapped(_:)), for: .touchUpInside)
        self.countryArrowButton.addTarget(self, action: #selector(self.countryArrowButtonTapped(_:)), for: .touchUpInside)
        self.languageArrowButton.addTarget(self, action: #selector(self.languageArrowButtonTapped(_:)), for: .touchUpInside)
        
        [self.userTypeArrowButton, self.countryArrowButton, self.languageArrowButton].forEach { (theButton) in
            theButton?.setImage(Config.Images.shared.getImage(imageName: Config.Images.downArrowIcon), for: .normal)
            theButton?.tintColor = UIColor.init(rgb: 0x9A9CB8)
        }
        
        [self.firstNameTextField, self.lastNameTextField, self.mobileNumberTextField, self.emailIdTextField, self.userTypeTextField, self.countryTextField, self.languageTextField].forEach { (textField) in
            textField?.textAlignment = .left
            textField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            textField?.textColor = .customBlackColor()
            textField?.delegate = self
            textField?.keyboardType = .default
            if textField == self.firstNameTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.firstNameTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "firstNamePlaceHolderText"))
            }else if textField == self.lastNameTextField{
                textField?.autocapitalizationType = .words
                self.setup(self.lastNameTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "lastNamePlaceHolderText"))
            }else if textField == self.mobileNumberTextField{
                textField?.keyboardType = .phonePad
                self.setup(self.mobileNumberTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "mobileNumberPlaceHolderText"))
            }else if textField == self.emailIdTextField{
                textField?.keyboardType = .emailAddress
                self.setup(self.emailIdTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "emailIdPlaceHolderText"))
            }else if textField == self.userTypeTextField{
                self.setup(self.userTypeTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "userTypePlaceHolderText"))
                self.setupPickerViewWithToolBar(textField: userTypeTextField, target: self, thePicker: thePicker)
            }else if textField == self.countryTextField{
                self.setupPickerViewWithToolBar(textField: countryTextField, target: self, thePicker: thePicker)
                textField?.autocapitalizationType = .words
                self.setup(self.countryTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "country_text"))
            }else if textField == self.languageTextField{
                self.setupPickerViewWithToolBar(textField: languageTextField, target: self, thePicker: thePicker)
                textField?.autocapitalizationType = .words
                self.setup(self.languageTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "language_text"))
            }
        }
    }
    
    private func getLanguages(){
        self.showHud()
        RestCloudService.shared.getLanguages(params: [:])
    }
    
    private func getCountries(){
        self.showHud()
        RestCloudService.shared.getCountries()
    }
    
    @objc func tickMarkButtonTapped(_ sender: UIButton){
        if sender.tag == 0{
            sender.tag = 1
            sender.backgroundColor = .primaryColor()
            sender.setImage(Config.Images.shared.getImage(imageName: Config.Images.tickIcon), for: .normal)
            sender.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }else{
            sender.tag = 0
            sender.backgroundColor = .clear
            sender.setImage(nil, for: .normal)
        }
    }
    
    @objc func termsAndConditionsButtonTapped(_ sender: UIButton){

    }
    
    @objc func submitButtonTapped(_ sender: UIButton){
        
        if self.inputFieldsValidation() == false{
            return
        }
   
        let params:[String:Any] = [
            "first_name" : self.firstNameTextField.text ?? "",
            "last_name" : self.lastNameTextField.text ?? "",
            "mobile_number" : self.mobileNumberTextField.text ?? "",
            "email" : self.emailIdTextField.text ?? "",
            "user_type" : self.userTypeTextField.text ?? "",
            "countryId" : self.selectedCountry,
            "language" : self.selectedLanguage,
            "ip_address" : UIDevice.current.getIP() ?? "",
            "uuid" : UIDevice.current.identifierForVendor!.uuidString
        ]
        print(params)
        self.showHud()
        RestCloudService.shared.signupUser(params: params)
    }
    
    private func inputFieldsValidation() -> Bool{
        var message:String?
        
        if (self.firstNameTextField.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "firstNamePlaceHolderText"))"
        }else if (self.lastNameTextField.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "lastNamePlaceHolderText"))"
        }else if (self.emailIdTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "emailIdPlaceHolderText"))"
        }else if (self.userTypeTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "userTypePlaceHolderText"))"
        }else if (self.countryTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "country_text"))"
        }else if (self.languageTextField.text ?? "").isEmptyOrWhitespace(){
            message = " \(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "language_text"))"
        }else if (self.emailIdTextField.text ?? "").isValidEmail() == false && message == nil{
            message = LocalizationManager.shared.localizedString(key: "validEmailText")
        }else if self.tickMarkButton.tag == 0{
            message = LocalizationManager.shared.localizedString(key: "termsErrorText")
        }
        
        if message != nil{
            UIAlertController.showAlert(message: message ?? "", target: self)
            return false
        }
        return true
    }
    
    @objc func signInButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func userTypeArrowButtonTapped(_ sender: UIButton){
        self.userTypeTextField.becomeFirstResponder()
    }
    
    @objc func countryArrowButtonTapped(_ sender: UIButton){
        self.countryTextField.becomeFirstResponder()
    }
    
    @objc func languageArrowButtonTapped(_ sender: UIButton){
        self.languageTextField.becomeFirstResponder()
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
    
    override func doneButtonTapped(_ sender:AnyObject){
        self.textField = nil
        self.userTypeTextField.resignFirstResponder()
        self.countryTextField.resignFirstResponder()
        self.languageTextField.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SignUpVC: UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.userTypeTextField && textField.text?.count == 0{
            textField.text = self.userTypes[0]
        }else if textField == self.countryTextField && textField.text?.count == 0{
            textField.text = self.countries?[0].name
        }else if textField == self.languageTextField && textField.text?.count == 0{
            textField.text = self.languages?[0].name
        }
        self.textField = textField
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        if textField == self.firstNameTextField{
            return newLength <= 50
        }else if textField == self.lastNameTextField{
            return newLength <= 50
        }else if textField == self.emailIdTextField{
            return newLength <= 80
        }else if textField == self.mobileNumberTextField{
            if String().checkCharactersSetNumbersOnly(string: string) == false{
                return false //failed in character validation
            }
            return newLength <= 15
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textField == self.userTypeTextField{
            return self.userTypes.count
        }else if self.textField == self.countryTextField{
            return self.countries?.count ?? 0
        }else if self.textField == self.languageTextField{
            return self.languages?.count ?? 0
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textField == self.userTypeTextField{
            return self.userTypes[row]
        }else if self.textField == self.countryTextField{
            return self.countries?[row].name
        }else if self.textField == self.languageTextField{
            return self.languages?[row].name
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.textField == self.userTypeTextField{
            self.userTypeTextField.text = self.userTypes[row]
            self.selectedUserType = row + 1
        }else if self.textField == self.countryTextField{
            self.countryTextField.text = self.countries?[row].name
            self.selectedCountry = self.countries?[row].id ?? 1
        }else if self.textField == self.languageTextField{
            self.languageTextField.text = self.languages?[row].name
            self.selectedLanguage = self.languages?[row].id ?? 1
        }
    }
    
}

extension SignUpVC: RCUserDelegate {
   @objc func didReceiveLanguages(language: [Languages]) {
        self.hideHud()
        languages = language
    }
    
    func didFailedToReceiveLanguages(errorMessage: String) {
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
   
    /// Get Countries delegate
    func didReceiveCountries(country: [Countries]) {
        self.hideHud()
        countries = country
    }
    
    func didFailedToReceiveCoutries(errorMessage: String) {
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
    
    func didRequestSignupSuccess(message: String) {
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func didFailedToRequestSignup(errorMessage: String) {
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
    
}

