//
//  SignInVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

class SignInVC: UIViewController {
    
    @IBOutlet var topView:UIView!
    @IBOutlet var centerView:UIView!
    @IBOutlet var welcomeBackLabel:UILabel!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var haveAccountLabel:UILabel!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var textFieldRightIconImageView:UIImageView!
    @IBOutlet var getOtpButton:UIButton!
    @IBOutlet var signUpButton:UIButton!
    @IBOutlet var emailTextField:MDCOutlinedTextField!
    @IBOutlet var switchControl: UISwitch!
    @IBOutlet var userButton: UIButton!
    @IBOutlet var staffButton: UIButton!
    
    var loginType: String? = Config.Text.staff
    var loginParams: [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.userDelegate = self
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.userDelegate = self
        self.hideNavigationBar()
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
        
        self.iconImageView.image = Config.Images.shared.getImage(imageName: Config.Images.mailIconWhite)
        self.iconImageView.contentMode = .scaleAspectFit
        self.textFieldRightIconImageView.image = Config.Images.shared.getImage(imageName: Config.Images.mailIconGray)
        self.textFieldRightIconImageView.contentMode = .scaleAspectFit
        
        self.welcomeBackLabel.text = LocalizationManager.shared.localizedString(key: "welcomeText")
        self.welcomeBackLabel.numberOfLines = 1
        self.welcomeBackLabel.textColor = .white
        self.welcomeBackLabel.textAlignment = .center
        self.welcomeBackLabel.font = UIFont.appFont(ofSize: 25.0, weight: .bold)
        
        self.descriptionLabel.text = LocalizationManager.shared.localizedString(key: "emailIdDescriptionText")
        self.descriptionLabel.numberOfLines = 1
        self.descriptionLabel.textColor = .white
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        
        self.haveAccountLabel.text = LocalizationManager.shared.localizedString(key:"dontHaveAccountText")
        self.haveAccountLabel.numberOfLines = 1
        self.haveAccountLabel.textColor = .customBlackColor()
        self.haveAccountLabel.textAlignment = .right
        self.haveAccountLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        
        self.setup(self.emailTextField, placeholderLabel: LocalizationManager.shared.localizedString(key:"emailAddressPlaceHolderText"))
        self.emailTextField.textAlignment = .left
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.delegate = self
        
        self.getOtpButton.backgroundColor = .primaryColor()
        self.getOtpButton.layer.cornerRadius = self.getOtpButton.frame.height / 2.0
        self.getOtpButton.setTitle(LocalizationManager.shared.localizedString(key: "getOtpButtonText"), for: .normal)
        self.getOtpButton.setTitleColor(.white, for: .normal)
        self.getOtpButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.getOtpButton.addTarget(self, action: #selector(self.getOtpButtonTapped(_:)), for: .touchUpInside)
        
        self.signUpButton.backgroundColor = .clear
        self.signUpButton.setTitle(LocalizationManager.shared.localizedString(key: "singUpButtonText"), for: .normal)
        self.signUpButton.setTitleColor(UIColor.init(rgb: 0xE81D2D), for: .normal)
        self.signUpButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(_:)), for: .touchUpInside)

        self.haveAccountLabel.isHidden = true
        self.signUpButton.isHidden = true
        
        [self.userButton, self.staffButton].forEach { theButton in
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 14.0, weight: .regular)
        }
        
        if self.loginType == Config.Text.user {
            self.userButton.isUserInteractionEnabled = true
            self.userButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.staffButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
            self.switchControl.setOn(true, animated: false)
        }else {
            self.staffButton.isUserInteractionEnabled = true
            self.staffButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.userButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
            self.switchControl.setOn(false, animated: false)
        }
        self.switchControl.thumbTintColor = .primaryColor()
        self.switchControl.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
        
        self.userButton.setTitle("  \(LocalizationManager.shared.localizedString(key: "userText"))", for: .normal)
        self.staffButton.setTitle("  \(LocalizationManager.shared.localizedString(key: "staffText"))", for: .normal)
    }
  
    @IBAction func switchButtonTapped(_ sender: UISwitch){
        if (sender.isOn == true) {
            self.userButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.staffButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
        } else {
            self.staffButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.userButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
        }
    }
    
    @objc func getOtpButtonTapped(_ sender: UIButton){
   
        if (self.emailTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "err_email_req"), target: self)
            return
        }
        
        if !(self.emailTextField.text ?? "").isValidEmail(){
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "err_invalid_email"), target: self)
            return
        }
        
        if self.switchControl.isOn {
            loginType = Config.Text.user
        }else{
            loginType = Config.Text.staff
        }
     
        UIViewController.sharedWebClient.baseUrl = Config.baseURL
        loginParams = ["email": emailTextField.text ?? "",
                                      "type": loginType ?? Config.Text.staff,
                                      "deviceId": "\(UIDevice.current.identifierForVendor?.uuidString ?? "")" ]
        self.view.endEditing(true)
        self.showHud()
        print(loginParams)
        RestCloudService.shared.getLoginOTP(params: loginParams)

    }
    
    private func pushToVerifyOTPVC(){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .main, withIdentifier: .otpVerification) as? VerifyOTPSignInVC {
                vc.emailAddress = self.emailTextField.text ?? ""
                vc.loginType = self.loginType ?? Config.Text.staff
                vc.loginParams = self.loginParams
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func signUpButtonTapped(_ sender: UIButton){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .main, withIdentifier: .signUp) as? SignUpVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
  
}

extension SignInVC: UITextFieldDelegate{
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
        return count <= 80
        
    }
}

extension SignInVC: RCUserDelegate {
    
    /// OTP request delegates
    func didRequestOtpSuccess(message: String) {
        self.hideHud()
        
        print(message, String().getAlertSuccess(message: message))
        
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.pushToVerifyOTPVC()
            }
        })
    }
    
    func didFailedToRequestOtp(errorMessage: String) {
        self.hideHud()
        if errorMessage.lowercased() == Config.backEndAlertMessage.registerNotCompleted.lowercased(){
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "notCompleteRegisterTitle"),
                                        message: String().getAlertSuccess(message: errorMessage),
                                        target: self)
        }else{
            UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
        }
    }
    
}
