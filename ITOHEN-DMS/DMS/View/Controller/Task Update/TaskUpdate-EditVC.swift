//
//  TaskUpdate-EditVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 02/11/22.
//

    import UIKit
    import MaterialComponents

class TaskUpdate_EditVC: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var sectionView: UIView!
    @IBOutlet var sectionTitleLabel: UILabel!
    @IBOutlet var startDateTextField: MDCOutlinedTextField!
    @IBOutlet var endDateTextField: MDCOutlinedTextField!
    @IBOutlet var picTextField: MDCOutlinedTextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var swipeToDownButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var subTaskDateView: UIView!
    @IBOutlet var subTaskDateViewHConstraint: NSLayoutConstraint!
    @IBOutlet var startDateTitleLabel: UILabel!
    @IBOutlet var endDateTitleLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    var taskId:String = "0"
    var catId:String = "0"
    var orderId:String = "0"
    var screenTitle:String = ""
    var contactList: [Contact] = []
    var taskUpdateData: EditTaskSubTitleData?
    
    var delegate:ReloadUpdateTaskDelegate?
    
    weak var activeField: UITextField?{
        willSet{
            self.theDatePicker.date = Date()
        }
    }
    let thePicker = UIPickerView()
    let theDatePicker = UIDatePicker()
    let theToolbarForPicker = UIToolbar()
    let theToolbarForDatePicker = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.setupUI()
        self.setupPickerViewWithToolBar()
        RestCloudService.shared.taskUpdateDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(TaskUpdate_EditVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TaskUpdate_EditVC.keyboardWillBeHidden),
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
        sectionTitleLabel.text =  "\(LocalizationManager.shared.localizedString(key: "updateTaskTitle")) - \(screenTitle)"
        
        [startDateTextField, endDateTextField, picTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.layer.cornerRadius = 10.0
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            
            if theTextField == startDateTextField{
//                startDateTextField.isUserInteractionEnabled = false
//                startDateTextField.backgroundColor = .appLightColor()
                self.setup(startDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
            }else if theTextField == endDateTextField{
                self.setup(endDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
            }else{
                self.setup(picTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "personInChargeText"))
            }
        }
   
        self.startDateTextField.delegate = self
        self.startDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.startDateTextField.inputView = self.theDatePicker
        
        self.endDateTextField.delegate = self
        self.endDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.endDateTextField.inputView = self.theDatePicker
        
        self.picTextField.delegate = self
        self.picTextField.inputAccessoryView = self.theToolbarForPicker
        self.picTextField.inputView = self.thePicker
   
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
        
        self.startDateTitleLabel.textColor = .primaryColor()
        self.endDateTitleLabel.textColor = .primaryColor()
        self.startDateTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "startDateText")):"
        self.endDateTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "endDateText")):"
        
        self.startDateLabel.textColor = .black
        self.endDateLabel.textColor = .black
        
        if taskUpdateData?.isSubTask == true{ // For subtask update
            self.subTaskDateView.isHidden = false
            self.subTaskDateViewHConstraint.constant = 55.0
            
            if let startDate = taskUpdateData?.taskStartDate, startDate.count > 0{
                self.startDateLabel.text = startDate
            }else{
                self.startDateLabel.text = "-"
            }
            if let endDate = taskUpdateData?.taskEndDate, endDate.count > 0{
                self.endDateLabel.text = endDate
            }else{
                self.endDateLabel.text = "-"
            }
            
        }else{ // For task update
            self.subTaskDateView.isHidden = true
            self.subTaskDateViewHConstraint.constant = 0.0
            
            if let contact = contactList.first(where: {$0.id == self.taskUpdateData?.taskPic}) {
                self.picTextField.text = contact.contactName
                self.picTextField.tag = Int(contact.id ?? "0") ?? 0
            }
            self.startDateTextField.text = self.taskUpdateData?.taskStartDate
            self.endDateTextField.text = self.taskUpdateData?.taskEndDate
        }
    }
   
    func setupPickerViewWithToolBar(){
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
        
        theDatePicker.datePickerMode = .date
        theDatePicker.minimumDate = Date()

        if #available(iOS 13.4, *) {
            theDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.theToolbarForDatePicker.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                                          style:.plain,
                                          target: self,
                                          action: #selector(doneDateButtonTapped(_:)))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                           target: nil,
                                           action: nil)
        let clearButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "clearText"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(clearDateButtonTapped(_:)))
        self.theToolbarForDatePicker.setItems([clearButton2,spaceButton2,doneButton2], animated: false)
  
    }
 
    @objc func doneDateButtonTapped(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.simpleDateFormat
        activeField?.text = formatter.string(from: theDatePicker.date)
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
   
    @objc override func doneButtonTapped(_ sender:AnyObject){
        if self.thePicker.selectedRow(inComponent: 0) < self.contactList.count{
            let data = self.contactList[self.thePicker.selectedRow(inComponent: 0)]
            activeField?.text = data.contactName
            self.picTextField.tag = Int(data.id ?? "0") ?? 0
        }
        thePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        self.view.endEditing(true)
    }
    
    @objc func clearDateButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        theToolbarForDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": self.orderId,
                                    "task_id": self.taskId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "start_date": self.startDateTextField.text ?? "",
                                    "end_date": self.endDateTextField.text ?? "",
                                    "pic_id": "\( self.picTextField.tag)"]
        print(params)
        RestCloudService.shared.updateTask(params: params)
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

extension TaskUpdate_EditVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        theDatePicker.minimumDate = textField == startDateTextField ? Date() : DateTime.stringToDatetaskUpdate(dateString: self.startDateTextField.text ?? "", dateFormat: Date.simpleDateFormat)
        self.saveButton.isUserInteractionEnabled = false
        self.saveButton.backgroundColor = .lightGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if !(self.startDateTextField.text ?? "").isEmptyOrWhitespace() && !(self.endDateTextField.text ?? "").isEmptyOrWhitespace() && !(self.picTextField.text ?? "").isEmptyOrWhitespace() {
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

extension TaskUpdate_EditVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension TaskUpdate_EditVC: RCTaskUpdateDelegate{
    
    /// Update  task
    func didReceiveUpdateTask(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            self.delegate?.reloadUpdateTaskScreen(orderId: self.orderId)
            self.dismissViewController()
        })

    }
    
    func didFailedToReceiveUpdateTask(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
     
    }
}
