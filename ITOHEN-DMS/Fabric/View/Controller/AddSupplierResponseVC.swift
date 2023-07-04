//
//  AddSupplierResponse.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 29/03/23.
//

import UIKit
import MaterialComponents

class AddSupplierResponseVC: UIViewController {
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var subTitleLabel:UILabel!
    @IBOutlet var supplierTextField:MDCOutlinedTextField!
    @IBOutlet var priceTextField:MDCOutlinedTextField!
    @IBOutlet var commentTextView: UITextView!{
        didSet { commentTextView?.addDoneCancelToolbar() }
    }
    @IBOutlet var saveButton:UIButton!
    var supplierResponseDelegate: ViewFabricSuppliersDelegate?
    var inquiryId: String?
    var currency: String = ""
    var fabricSupplierListData: [FabricSupplierListData] = []
    
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    weak var activeField: UITextField?
    weak var activeTextViewField: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(AddSupplierResponseVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddSupplierResponseVC.textViewKeyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddSupplierResponseVC.keyboardWillBeHidden),
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
        self.sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "addSupplierResponseText")
        
        subTitleLabel.textColor = .customBlackColor()
        subTitleLabel.textAlignment = .left
        subTitleLabel.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        self.subTitleLabel.text = LocalizationManager.shared.localizedString(key: "supplierWarningText")
        
        self.setup(supplierTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "supplierText")) *")
        self.setup(priceTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "priceText")) (in \(currency)) *")
        
        [supplierTextField, priceTextField].forEach { (theTextField) in
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = theTextField == priceTextField ? .numberPad : .default
            if theTextField == self.supplierTextField{
                self.setupPickerViewWithToolBar(textField: supplierTextField, target: self, thePicker: thePicker)
            }
            theTextField?.delegate = self
        }
        self.addDoneButtonOnKeyboard(textField: priceTextField)
        
        self.commentTextView.layer.borderColor = UIColor.gray.cgColor
        self.commentTextView.layer.borderWidth = 1.0
        self.commentTextView.layer.cornerRadius = 8
        self.commentTextView.text = "\(LocalizationManager.shared.localizedString(key: "commantsText"))"
        self.commentTextView.textColor = UIColor.gray
        self.commentTextView.delegate = self
    
        self.saveButton.backgroundColor = .fabricPrimaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    }
 
    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.supplierTextField.inputView = thePicker
      
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .primaryColor()
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        toolBar.setItems([spaceButton1,doneButton], animated: false)
        
        self.supplierTextField.inputAccessoryView = toolBar
    }
    
    @objc func saveButtonTapped(_ sender: UIButton){
        
        if self.inputFieldsValidation() == false{
            return
        }
   
        let params:[String:Any] = [
            "supplier_id" : self.supplierTextField.tag,
            "inquiry_id" : self.inquiryId ?? "",
            "user_id" : RMConfiguration.shared.userId,
            "user_type" : RMConfiguration.shared.loginType,
            "price" : self.priceTextField.text ?? "",
            "comments" : self.commentTextView.text ?? "" ]
        print(params)
        self.showHud()
        RestCloudService.shared.saveFabricSuppliersResponse(params: params)
    }
    
    private func inputFieldsValidation() -> Bool{
        var message:String?
      
        if (self.supplierTextField.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "chooseText")) \(LocalizationManager.shared.localizedString(key: "supplierText"))"
        }else if (self.priceTextField.text ?? "").isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEnterText")) \(LocalizationManager.shared.localizedString(key: "priceText"))"
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
    
    @objc func textViewKeyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 30.0 // Padding between the bottom of the view and the top of the keyboard
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        guard let activeField = activeTextViewField, let keyboardHeight = keyboardSize?.height else { return }
         
        
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
 
    override func doneButtonTapped(_ sender:AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            self.contentView.endEditing(true)
            thePicker.endEditing(true)
            return
        }
        if activeField == supplierTextField && row < fabricSupplierListData.count {
            self.supplierTextField.text = self.fabricSupplierListData[row].supplier
            self.supplierTextField.tag = self.fabricSupplierListData[row].id ?? 0
        }
        thePicker.endEditing(true)
        self.view.endEditing(true)
    }
}

extension AddSupplierResponseVC: UITextFieldDelegate{
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

extension AddSupplierResponseVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextViewField = textView
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.layer.borderColor = UIColor.fabricPrimaryColor().cgColor
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

extension AddSupplierResponseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == supplierTextField{
            return self.fabricSupplierListData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == supplierTextField{
            return self.fabricSupplierListData[row].supplier
        }
        return ""
    }

}

extension AddSupplierResponseVC: RCFabricDelegate{
    // Save supplier response
    func didReceiveSaveSupplierResponse(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.supplierResponseDelegate?.ViewFabricSuppliersList()
                self.dismissViewController()
            }
        })
    }
    func didFailedToReceiveSaveSupplierResponse(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
}
