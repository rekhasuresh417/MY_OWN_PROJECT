//
//  TaskRescheduleDateVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

protocol ReloadUpdateTaskDelegate{
    func reloadUpdateTaskScreen(orderId: String)
}

class TaskRescheduleDateVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var startDateTextField:MDCOutlinedTextField!
    @IBOutlet var endDateTextField:MDCOutlinedTextField!
    @IBOutlet var reasonTextField:MDCOutlinedTextField!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var taskId:String = "0"
    var orderId:String = "0"
    var rescheduleType: String = ""
    var taskUpdateData: EditTaskSubTitleData?
    var delegate:ReloadUpdateTaskDelegate?
    
    weak var activeField: UITextField?{
        willSet{
            self.theDatePicker.date = Date()
        }
    }
    let theDatePicker = UIDatePicker()
    let theToolbarForDatePicker = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupPickerViewWithToolBar()
        RestCloudService.shared.taskUpdateDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(TaskRescheduleDateVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TaskRescheduleDateVC.keyboardWillBeHidden),
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
        if rescheduleType == Config.Text.startDate{
            sectionTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "rescheduleTitle")) \(LocalizationManager.shared.localizedString(key: "startDateText"))"
        }else{
            sectionTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "rescheduleTitle")) \(LocalizationManager.shared.localizedString(key: "endDateText"))"
        }
            
        [reasonTextField, startDateTextField, endDateTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.layer.cornerRadius = 10.0
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            
            if theTextField == startDateTextField{
                self.setup(startDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
            }else if theTextField == endDateTextField{
                self.setup(endDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
            }else{
                self.setup(reasonTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "reasonPlaceHolderText"))
            }
        }
        self.startDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.startDateTextField.inputView = self.theDatePicker

        self.endDateTextField.inputAccessoryView = self.theToolbarForDatePicker
        self.endDateTextField.inputView = self.theDatePicker
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white

        self.startDateTextField.text = self.taskUpdateData?.taskStartDate
        self.endDateTextField.text = self.taskUpdateData?.taskEndDate
        self.enableTextField()
        
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
   
    func enableTextField(){
        if rescheduleType == Config.Text.startDate{
            self.endDateTextField.isUserInteractionEnabled = false
            self.endDateTextField.backgroundColor = .appLightColor()
        }else if rescheduleType == Config.Text.endDate{
            self.startDateTextField.isUserInteractionEnabled = false
            self.startDateTextField.backgroundColor = .appLightColor()
        }
    }
        
    func setupPickerViewWithToolBar() {
        theDatePicker.datePickerMode = .date
        theDatePicker.minimumDate = rescheduleType == Config.Text.startDate ? Date() : DateTime.stringToDate(dateString: taskUpdateData?.taskStartDate ?? "", dateFormat: Date.simpleDateFormat)
        
        theDatePicker.maximumDate = rescheduleType == Config.Text.endDate ? nil : DateTime.stringToDate(dateString: taskUpdateData?.taskEndDate ?? "", dateFormat: Date.simpleDateFormat)
        
        if #available(iOS 13.4, *) {
            theDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.theToolbarForDatePicker.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style:.plain, target: self, action: #selector(doneDateButtonTapped(_:)))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "clearText"), style: .plain, target: self, action: #selector(clearButtonTapped(_:)))
        self.theToolbarForDatePicker.setItems([clearButton2,spaceButton2,doneButton2], animated: false)
    }

    
    @objc func doneDateButtonTapped(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.simpleDateFormat
        activeField?.text = formatter.string(from: theDatePicker.date)
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }

    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        self.view.endEditing(true)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        
        let date: String = self.rescheduleType == Config.Text.startDate ? self.startDateTextField.text ?? "" : self.endDateTextField.text ?? ""
        self.showHud()
        var params:[String:Any] = ["id": self.taskId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "date": date,
                                    "the_type": self.rescheduleType,
                                    "reschedule_type" : Config.Text.reschedule,
                                    "reason": self.reasonTextField.text ?? "" ]
        
        if taskUpdateData?.isSubTask == true{
            params["isSubtask"] = "Subtask"
        }
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

extension TaskRescheduleDateVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        self.saveButton.isUserInteractionEnabled = false
        self.saveButton.backgroundColor = .lightGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if rescheduleType == Config.Text.startDate{
            if (self.startDateTextField.text ?? "").isEmptyOrWhitespace() || (self.reasonTextField.text ?? "").isEmptyOrWhitespace() {
                return
            }
        }else if rescheduleType == Config.Text.endDate{
            if (self.endDateTextField.text ?? "").isEmptyOrWhitespace() || (self.reasonTextField.text ?? "").isEmptyOrWhitespace() {
                return
            }
        }
        self.saveButton.isUserInteractionEnabled = true
        self.saveButton.backgroundColor = .primaryColor()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskRescheduleDateVC: RCTaskUpdateDelegate{
    
    /// Update  task
    func didReceiveUpdateTask(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            self.delegate?.reloadUpdateTaskScreen(orderId: self.orderId)
            self.dismissViewController()
        })

    }
    
    func didFailedToReceiveUpdateTask(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
     
    }
    
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
