//
//  TaskReAssignPICVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/11/22.
//

import UIKit
import MaterialComponents

class TaskReAssignPICVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var previousPICTextField:MDCOutlinedTextField!
    @IBOutlet var currentPICTextField:MDCOutlinedTextField!
    @IBOutlet var reasonTextField:MDCOutlinedTextField!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var cancelButton: UIButton!
   
    var taskId:String = "0"
    var catId:String = "0"
    var orderId:String = "0"
    var screenTitle:String = ""
    var taskUpdateData: EditTaskSubTitleData?
    var delegate: ReloadUpdateTaskDelegate?
    var contactList: [Contact] = []
    
    weak var activeField: UITextField?
    let thePicker = UIPickerView()
    let theToolbarForPicker = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupPickerViewWithToolBar()
        RestCloudService.shared.taskUpdateDelegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(TaskRescheduleDateVC.keyboardDidShow),
//                                               name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(TaskRescheduleDateVC.keyboardWillBeHidden),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
        sectionTitleLabel.text =  LocalizationManager.shared.localizedString(key: "taskReAssignTitle")
            
        [reasonTextField, previousPICTextField, currentPICTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.layer.cornerRadius = 10.0
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            
            if theTextField == previousPICTextField{
                previousPICTextField.isUserInteractionEnabled = false
                previousPICTextField.backgroundColor = .appLightColor()
                self.setup(previousPICTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "previousPICText"))
            }else if theTextField == currentPICTextField{
                self.setup(currentPICTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "currentPICText"))
            }else{
                theTextField?.autocapitalizationType = .sentences
                self.setup(reasonTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "reasonPlaceHolderText"))
            }
        }
        
        if let contact = contactList.first(where: {$0.id == taskUpdateData?.taskPic}) {
            self.previousPICTextField.text = contact.contactName
        }
       
        self.currentPICTextField.delegate = self
        self.currentPICTextField.inputAccessoryView = self.theToolbarForPicker
        self.currentPICTextField.inputView = self.thePicker
    
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white

        self.cancelButton.backgroundColor = .white
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        self.cancelButton.setTitleColor(.primaryColor(), for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.cancelButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        
        self.saveButton.isUserInteractionEnabled = false
        self.saveButton.backgroundColor = .lightGray
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
    }
    
    func setupPickerViewWithToolBar() {
        thePicker.dataSource = self
        thePicker.delegate = self
        theToolbarForPicker.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                                          style:.plain, target: self,
                                          action: #selector(doneButtonTapped(_:)))
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                           target: nil,
                                           action: nil)
        let clearButton1 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "clearText"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(clearButtonTapped(_:)))
        self.theToolbarForPicker.setItems([clearButton1,spaceButton1,doneButton1], animated: false)
        
    }
    
    @objc override func doneButtonTapped(_ sender:AnyObject){
        if self.thePicker.selectedRow(inComponent: 0) < self.contactList.count{
            let data = self.contactList[self.thePicker.selectedRow(inComponent: 0)]
            activeField?.text = data.contactName
            self.currentPICTextField.tag = Int(data.id ?? "0") ?? 0
        }
        thePicker.endEditing(true)
        self.view.endEditing(true)
    }

    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        self.view.endEditing(true)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        
        self.showHud()
        let params:[String:Any] = [ "id": self.taskId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "reschedule_type" : Config.Text.reassign,
                                    "pic_id": "\(self.currentPICTextField.tag)",
                                    "reason": self.reasonTextField.text ?? "" ]
        print(params)
        RestCloudService.shared.reScheduleTask(params: params)
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

extension TaskReAssignPICVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        self.saveButton.isUserInteractionEnabled = false
        self.saveButton.backgroundColor = .lightGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if !(self.currentPICTextField.text ?? "").isEmptyOrWhitespace() && !(self.reasonTextField.text ?? "").isEmptyOrWhitespace() {
            self.saveButton.isUserInteractionEnabled = true
            self.saveButton.backgroundColor = .primaryColor()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension TaskReAssignPICVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.contactList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.contactList[row].contactName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension TaskReAssignPICVC: RCTaskUpdateDelegate{

    /// Reschedule  task
    func didReceiveRescheduleTask(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            self.delegate?.reloadUpdateTaskScreen(orderId: self.orderId)
            self.dismissViewController()
        })
    }
    
    func didFailedToReceiveRescheduleTask(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
}
