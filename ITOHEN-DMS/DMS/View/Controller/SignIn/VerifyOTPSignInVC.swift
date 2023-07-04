//
//  VerifyOTPSignInVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class VerifyOTPSignInVC: UIViewController {
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var centerView:UIView!
    @IBOutlet var enterCodeLabel:UILabel!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var didntReceiveCodeLabel:UILabel!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var verifyButton:UIButton!
    @IBOutlet var resendCodeButton:UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var otpTextField1: UITextField!{
        didSet { otpTextField1?.addDoneCancelToolbar() }
    }
    @IBOutlet var otpTextField2: UITextField!{
        didSet { otpTextField2?.addDoneCancelToolbar() }
    }
    @IBOutlet var otpTextField3: UITextField!{
        didSet { otpTextField3?.addDoneCancelToolbar() }
    }
    @IBOutlet var otpTextField4: UITextField!{
        didSet { otpTextField4?.addDoneCancelToolbar() }
    }
    @IBOutlet var otpTextField5: UITextField!{
        didSet { otpTextField3?.addDoneCancelToolbar() }
    }
    @IBOutlet var otpTextField6: UITextField!{
        didSet { otpTextField4?.addDoneCancelToolbar() }
    }
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var tabBarVC: TabBarVC{
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
    }
    
    var emailAddress:String = ""
    var loginType: String = Config.Text.user
    var loginParams: [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.userDelegate = self
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startObservingKeyboardChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopObservingKeyboardChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupUI(){
        self.topView.applyTopViewStyle(radius: 10.0)
        self.centerView.backgroundColor = .white
        self.centerView.roundCorners(corners: .allCorners, radius: 8.0)
        self.centerView.layer.shadowOpacity = 0.5
        self.centerView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.centerView.layer.shadowRadius = 10.0
        self.centerView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.centerView.layer.masksToBounds = false
        
        self.backButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.backIcon), for: .normal)
        self.backButton.tintColor = .white
        self.backButton.setTitle("", for: .normal)
        
        self.iconImageView.image = Config.Images.shared.getImage(imageName: Config.Images.asteriskIcon)
        self.iconImageView.contentMode = .scaleAspectFit
        
        self.enterCodeLabel.text = LocalizationManager.shared.localizedString(key: "enterCodeText")
        self.enterCodeLabel.numberOfLines = 1
        self.enterCodeLabel.textColor = .white
        self.enterCodeLabel.textAlignment = .center
        self.enterCodeLabel.font = UIFont.appFont(ofSize: 20.0, weight: .bold)
        
        let attributedString = NSMutableAttributedString(string:LocalizationManager.shared.localizedString(key: "otp_descriptionText"), attributes:[NSAttributedString.Key.font : UIFont.appFont(ofSize: 12.0)])
        let boldString = NSMutableAttributedString(string: ": \(self.emailAddress)", attributes:[NSAttributedString.Key.font : UIFont.appFont(ofSize: 13.0, weight: .medium)])
        attributedString.append(boldString)
        self.descriptionLabel.attributedText = attributedString
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textColor = .white
        self.descriptionLabel.textAlignment = .center
        
        self.didntReceiveCodeLabel.text = LocalizationManager.shared.localizedString(key: "didntReceiveCodeText")
        self.didntReceiveCodeLabel.numberOfLines = 1
        self.didntReceiveCodeLabel.textColor = .customBlackColor()
        self.didntReceiveCodeLabel.textAlignment = .right
        self.didntReceiveCodeLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        
        self.otpTextField1.tag = 1
        self.otpTextField2.tag = 2
        self.otpTextField3.tag = 3
        self.otpTextField4.tag = 4
        self.otpTextField5.tag = 5
        self.otpTextField6.tag = 6
        [self.otpTextField1, self.otpTextField2, self.otpTextField3, self.otpTextField4, self.otpTextField5, self.otpTextField6].forEach { (textField) in
            textField?.borderStyle = .none
            textField?.textAlignment = .center
            textField?.keyboardType = .decimalPad
            textField?.font = UIFont.appFont(ofSize: 18.0, weight: .regular)
            textField?.textColor = .customBlackColor()
            textField?.delegate = self
            self.addBottomBorderWithColor(textField: textField!)
        }
        
        self.verifyButton.backgroundColor = .primaryColor()
        self.verifyButton.layer.cornerRadius = self.verifyButton.frame.height / 2.0
        self.verifyButton.setTitle(LocalizationManager.shared.localizedString(key: "verifyButtonText"), for: .normal)
        self.verifyButton.setTitleColor(.white, for: .normal)
        self.verifyButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.verifyButton.addTarget(self, action: #selector(self.verifyButtonTapped(_:)), for: .touchUpInside)
        
        self.resendCodeButton.backgroundColor = .clear
        self.resendCodeButton.setTitle(LocalizationManager.shared.localizedString(key: "resendOTPButtonText"), for: .normal)
        self.resendCodeButton.setTitleColor(.red, for: .normal)
        self.resendCodeButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.resendCodeButton.addTarget(self, action: #selector(self.resendCodeButtonTapped(_:)), for: .touchUpInside)
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
    }
    
    private func addBottomBorderWithColor(textField:UITextField) {
        let border = CALayer()
        border.backgroundColor = UIColor.init(rgb: 0xC9C9C9).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - 1.0,
                              width: textField.frame.size.width, height: 1.0)
        textField.layer.addSublayer(border)
    }
    
    @objc func verifyButtonTapped(_ sender: UIButton){
        self.verifyOTP()
    }
    
    private func verifyOTP(){
      
        if (self.otpTextField1.text ?? "").isEmptyOrWhitespace() || (self.otpTextField2.text ?? "").isEmptyOrWhitespace() || (self.otpTextField3.text ?? "").isEmptyOrWhitespace() || (self.otpTextField4.text ?? "").isEmptyOrWhitespace() || (self.otpTextField5.text ?? "").isEmptyOrWhitespace() || (self.otpTextField6.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "emptyOTPErrorMessage"), target: self)
            return
        }
        
        var otpCode:String = ""
        if let firstString = self.otpTextField1.text, let secondString = self.otpTextField2.text, let thirdString = self.otpTextField3.text, let fourthString = self.otpTextField4.text, let fifthString = self.otpTextField5.text, let sixthString = self.otpTextField6.text{
            otpCode = firstString + secondString + thirdString + fourthString + fifthString + sixthString
        }
        
        let params:[String:Any] = [
            "email" : self.emailAddress,
            "otp" :  otpCode
        ]
        print(params)
        self.view.endEditing(true)
        self.showHud()
        RestCloudService.shared.validateOTP(params: params,
                                            loginType: self.loginType)
    }
    
    private func updateLanguage(languageId: String = "1"){
        self.showHud()
        RestCloudService.shared.userDelegate = self
        let params: [String:String] = ["companyId": RMConfiguration.shared.companyId,
                                       "workspaceId": RMConfiguration.shared.workspaceId,
                                       "userId": RMConfiguration.shared.userId,
                                       "staffId": RMConfiguration.shared.staffId,
                                       "languageId": languageId
        ]
        print(params)
        RestCloudService.shared.updateLanguage(params: params)
    }
    
    @objc func resendCodeButtonTapped(_ sender: UIButton){
         print(loginParams)
        self.showHud()
        RestCloudService.shared.getLoginOTP(params: loginParams)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func startObservingKeyboardChanges() {
        
        // NotificationCenter observers
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        
        // Deal with rotations
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        
        // Deal with keyboard change (emoji, numerical, etc.)
        NotificationCenter.default.addObserver(forName: UITextInputMode.currentInputModeDidChangeNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        let verticalPadding: CGFloat = 0.0 // Padding between the bottom of the view and the top of the keyboard
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = -(keyboardHeight + verticalPadding)
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    private func stopObservingKeyboardChanges() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension VerifyOTPSignInVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // On inputing value to textfield
        if (textField.text?.count ?? 0 < 1  && string.count > 0){
            let nextTag = textField.tag + 1;

            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag);

            if (nextResponder == nil){
                nextResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = string;
            if textField == self.otpTextField6{
                textField.resignFirstResponder();
               self.verifyOTP()
            }else{
                nextResponder?.becomeFirstResponder();
            }
            return false;
        }else if (textField.text?.count ?? 0 > 0  && string.count > 0){
            // On inputing value to textfield
            let nextTag = textField.tag + 1;

            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag);

            if (nextResponder == nil){
                nextResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = string;
            if textField == self.otpTextField6{
                textField.resignFirstResponder();
               self.verifyOTP()
            }else{
                nextResponder?.becomeFirstResponder();
            }
            return false;
        }
        else if (textField.text?.count ?? 0 >= 1  && string.count == 0){
            // on deleting value from Textfield
            let previousTag = textField.tag - 1;

            // get previous responder
            var previousResponder = textField.superview?.viewWithTag(previousTag);

            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = "";
            previousResponder?.becomeFirstResponder();
            return false;
        }
        return true;
    }
}

extension VerifyOTPSignInVC: RCUserDelegate {
   
    /// OTP request delegates
    func didRequestOtpSuccess(message: String) {
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
              
            }
        })
    }
    
    func didFailedToRequestOtp(errorMessage: String) {
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
    
    /// Validate OTP delegate
    func didRequestValidateOTPSuccess(statusCode: Int, languageId: String, language: String, message: String){
        self.hideHud()
     
        if statusCode == Config.ErrorCode.SUCCESS{
           
            UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
                DispatchQueue.main.async {
                
                    if language != RMConfiguration.shared.language{
                      
                        /// We are selected language while First time luanching app
                        if let langId = self.appDelegate().selectedLanguageId, langId.isEmptyOrWhitespace() == false{
                            self.updateLanguage(languageId: langId)
                        }else{
                            if languageId == "0"{
                                self.updateLanguage(languageId: RMConfiguration.shared.languageId)
                            }else{
                                RMConfiguration.shared.language = language
                                RMConfiguration.shared.languageId = languageId
                            }
                        }
                        
                        NotificationCenter.default.post(name: .reloadHomeItemsVC, object: nil)
                        NotificationCenter.default.post(name: .reloadTabBarVC, object: nil)
                        NotificationCenter.default.post(name: .reloadUserSettingsVC, object: nil)
                        NotificationCenter.default.post(name: .reloadOrderFilterVC, object: nil)
                    }
                    self.hideNavigationBar() // hide Main storyboard navigation bar
                    self.appDelegate().setRootViewController()
                    self.navigationController?.pushViewController(self.tabBarVC, animated: true)
                }
            })
        }else if statusCode == Config.ErrorCode.NOT_FOUND{
            UIAlertController.showAlert(message: String().getAlertSuccess(message: message), target: self)
        }
    }
    
    func didFailedToRequestValidateOTP(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
    
    /// Update language  delegates
    func didReceiveUpdateLanguage(message: String){
        self.hideHud()
        self.appDelegate().selectedLanguage = ""
        self.appDelegate().selectedLanguageId = ""
    }
    
    func didFailedToReceiveUpdateLanguage(errorMessage: String){
        self.hideHud()
    }
}
