//
//  AddFactoryResponseVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 16/02/23.
//

import UIKit
import MaterialComponents

class AddFactoryResponseVC: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var inquiryIdLabel: UILabel!
    @IBOutlet var factoryIdTextField: MDCOutlinedTextField!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var priceTextField: MDCOutlinedTextField!
    @IBOutlet var commentTextView: UITextView!{
        didSet { commentTextView?.addDoneCancelToolbar() }
    }
    @IBOutlet var sendQuoteButton: UIButton!
    
    weak var activeField: UITextField?
    let thePicker = UIPickerView()
    var delegate: FactoryResponseProtocol?
    
    var factoryInquiryListResponse: FactoryInquiryListResponse?
    var inquiryId: String = ""
    var factoryId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RestCloudService.shared.inquiryDelegate = self
        self.setupUI()
        //self.getFactoryInquiryList()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(AddFactoryResponseVC.keyboardDidShow),
//                                               name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(AddFactoryResponseVC.keyboardWillBeHidden),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.inquiryDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key: "addFactoryResponse")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        self.scrollView.backgroundColor = .white
        self.contentView.backgroundColor = .clear
   
        self.scrollView.layer.cornerRadius = 8
        self.scrollView.clipsToBounds = true
        self.scrollView.applyLightShadow()
        
        self.setup(self.factoryIdTextField,
                   placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"factoryText")) *",
                   color: .inquiryPrimaryColor())
        self.setup(self.priceTextField,
                   placeholderLabel: "\(LocalizationManager.shared.localizedString(key:"priceText")) (in \(self.factoryInquiryListResponse?.currency ?? "₹")) *",
                   color: .inquiryPrimaryColor())
        
        self.topView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        self.topView.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.1)
        self.inquiryIdLabel.text = "\(LocalizationManager.shared.localizedString(key:"inquiryNoText")): IN-\(inquiryId)"
        
        [factoryIdTextField, priceTextField].forEach { (theTextField) in
            theTextField?.textAlignment = .left
            theTextField?.keyboardType = theTextField == priceTextField ? .numberPad : .default
            if theTextField == self.factoryIdTextField{
                self.setupPickerViewWithToolBar(textField: factoryIdTextField, target: self, thePicker: thePicker, isFromInquiry: true)
            }
            theTextField?.delegate = self
        }
        self.addDoneButtonOnKeyboard(textField: priceTextField)
      
        self.sendQuoteButton.backgroundColor = .inquiryPrimaryColor()
        self.sendQuoteButton.layer.cornerRadius = self.sendQuoteButton.frame.height / 2.0
        self.sendQuoteButton.setTitle("\(LocalizationManager.shared.localizedString(key: "saveButtonText"))", for: .normal)
        self.sendQuoteButton.setTitleColor(.white, for: .normal)
        self.sendQuoteButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.sendQuoteButton.addTarget(self, action: #selector(self.sendQuoteButtonTapped(_:)), for: .touchUpInside)
        
        self.commentTextView.layer.borderColor = UIColor.gray.cgColor
        self.commentTextView.layer.borderWidth = 1.0
        self.commentTextView.layer.cornerRadius = 8
        
        self.commentTextView.text = LocalizationManager.shared.localizedString(key: "commantsText")
        self.commentTextView.textColor = UIColor.gray
        
        self.commentTextView.delegate = self
        
    }
  
    func saveBuyerInquiry() {
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
        
        let params:[String:Any] =  [ "factory_id": self.factoryId,
                                     "user_id": userId,
                                     "user_type": RMConfiguration.shared.loginType,
                                     "inquiry_id": self.inquiryId,
                                     "price": self.priceTextField.text ?? "",
                                     "comments": self.commentTextView.text ?? "" ]
        print(params)
        RestCloudService.shared.saveBuyerInquiryResponse(params: params)
    }
    
    @objc func sendQuoteButtonTapped(_ sender: UIButton){
        if self.factoryId.isEmpty{
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "chooseText")) \(LocalizationManager.shared.localizedString(key: "factoryText"))", target: self)
            return
        }else if (self.priceTextField.text ?? "").isEmptyOrWhitespace(){
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "priceText"))", target: self)
            return
        }else{
            self.saveBuyerInquiry()
        }
    }
    
    override func doneButtonTapped(_ sender:AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            self.contentView.endEditing(true)
            thePicker.endEditing(true)
            return
        }
        
        factoryIdTextField.text = self.factoryInquiryListResponse?.data?[row].factory
        self.factoryId = "\(self.factoryInquiryListResponse?.data?[row].id ?? 0)"
    
        thePicker.endEditing(true)
        self.view.endEditing(true)
    }
}

extension AddFactoryResponseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.factoryInquiryListResponse?.data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return self.factoryInquiryListResponse?.data?[row].factory
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.factoryIdTextField.text = self.factoryInquiryListResponse?.data?[row].factory
        self.factoryId = "\(self.factoryInquiryListResponse?.data?[row].id ?? 0)"
    }
    
}

extension AddFactoryResponseVC: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
}

extension AddFactoryResponseVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmptyOrWhitespace() {
            textView.text = LocalizationManager.shared.localizedString(key: "commantsText")
            textView.textColor = UIColor.gray
            textView.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

extension AddFactoryResponseVC: RCInquiryDelegate{
    func didReceiveSaveBuyerQuoteResponse(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.delegate?.getBuyerInquiryList()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func didFailedToReceiveSaveBuyerQuoteResponse(errorMessage: String){
        self.hideHud()
    }
    
}
