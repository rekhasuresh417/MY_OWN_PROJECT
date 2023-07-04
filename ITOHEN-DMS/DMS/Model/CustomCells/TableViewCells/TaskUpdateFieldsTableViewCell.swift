//
//  TaskUpdateFieldsTableViewCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

class TaskUpdateFieldsTableViewCell: UITableViewCell {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerLabelView: UIView!
    @IBOutlet var headerHistoryView: UIView!
    @IBOutlet var headerEditView: UIView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var historyImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var schduleStartDateTextField:MDCOutlinedTextField!
    @IBOutlet var schduleEndDateTextField: MDCOutlinedTextField!
    @IBOutlet var schdulePICTextField: MDCOutlinedTextField! // Person InCharge
    @IBOutlet var accompalishDateTextField: MDCOutlinedTextField!
    @IBOutlet var toggleStartDateCalenderButton: UIButton!
    @IBOutlet var toggleEndDateCalenderButton: UIButton!
    @IBOutlet var toggleAccomblishedCalenderButton: UIButton!
    @IBOutlet var toggleArrowButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var fieldView1: UIView!
    @IBOutlet var fieldView2: UIView!
    @IBOutlet var fieldView3: UIView!
    @IBOutlet var fieldView4: UIView!
    @IBOutlet var fieldView5: UIView!
    
    @IBOutlet var addSubTaskButton: UIButton!
    @IBOutlet var addSubtaskView: UIView!

    @IBOutlet var headerLabelLConstraint: NSLayoutConstraint!
    @IBOutlet var headerLabelTConstraint: NSLayoutConstraint!
    @IBOutlet var fieldView1LConstraint: NSLayoutConstraint!
    @IBOutlet var fieldView2TConstraint: NSLayoutConstraint!
    @IBOutlet var fieldView3LConstraint: NSLayoutConstraint!
    @IBOutlet var fieldView4TConstraint: NSLayoutConstraint!
    
    @IBOutlet var headerHistoryViewWConstraint: NSLayoutConstraint!
    @IBOutlet var headerEditViewWConstraint: NSLayoutConstraint!
    @IBOutlet var addSubTaskViewWConstraint: NSLayoutConstraint!
    
    var categoryId:String = ""
    var taskId:String = ""
    var taskUpdateCellData: EditTaskSubTitleData?
    var contactList: [Contact] = []
    var startDate: String = ""
    var target: TaskUpdateVC? = nil
    var section: Int = 0
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        self.mainView.backgroundColor = .white
        self.headerView.backgroundColor = .primaryColor(withAlpha: 0.3)
        
        self.nameLabel.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.backgroundColor = .clear
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.sizeToFit()
    
//        [headerLabelView,headerHistoryView,headerEditView].forEach { (view) in
//            view?.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
//        }
   
        historyImageView.image = Config.Images.shared.getImage(imageName:  Config.Images.historyIcon)
        editButton.setImage(Config.Images.shared.getImage(imageName:  Config.Images.editInfoIcon), for: .normal)
        editButton.tintColor = .customBlackColor()
        
        [toggleStartDateCalenderButton, toggleEndDateCalenderButton, toggleAccomblishedCalenderButton].forEach { (button) in
            button?.setImage(Config.Images.shared.getImage(imageName:  Config.Images.calenderIcon), for: .normal)
            button?.tintColor = UIColor.init(rgb: 0x727272)
            button?.backgroundColor = .clear
        }
        
        [toggleArrowButton].forEach { (button) in
            button?.setImage(Config.Images.shared.getImage(imageName:  Config.Images.downArrowIcon), for: .normal)
            button?.tintColor = UIColor.init(rgb: 0x727272)
            button?.backgroundColor = .clear
        }
        
        [schduleStartDateTextField, schduleEndDateTextField, schdulePICTextField, accompalishDateTextField].forEach { (textField) in
            textField?.textColor = .customBlackColor()
            textField?.textAlignment = .left
            textField?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
         
           // textField?.isUserInteractionEnabled = textField == accompalishDateTextField ? true : false
        }

        self.headerEditViewWConstraint.constant = 0.0
        self.headerEditView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.accompalishDateTextField.text = ""
        self.schduleStartDateTextField.text = ""
        self.schduleEndDateTextField.text = ""
        self.schdulePICTextField.text = ""
        self.headerView.backgroundColor = .primaryColor(withAlpha: 0.3)
        
        self.addSubTaskButton.setImage(UIImage.init(named: Config.Images.addNewTask), for: .normal)

        self.accompalishDateTextField.isUserInteractionEnabled = true
        self.schduleStartDateTextField.isUserInteractionEnabled = true
        self.schduleEndDateTextField.isUserInteractionEnabled = true
        self.schdulePICTextField.isUserInteractionEnabled = true
  
        self.accompalishDateTextField.isEnabled = true
        self.schduleStartDateTextField.isEnabled = true
        self.schduleEndDateTextField.isEnabled = true
        self.schdulePICTextField.isEnabled = true
        
        // Show addSubtask view
        self.addSubtaskView.isHidden = false
        self.addSubTaskViewWConstraint.constant = 30.0
    }
    
    func setContent(target: TaskUpdateVC?, data: EditTaskSubTitleData, section: Int, index: Int){
   
        self.taskUpdateCellData = data
        self.startDate = data.taskStartDate ?? ""
        self.index = index
        self.section = section
        self.target = target
        
        self.headerView.backgroundColor = data.isSubTask == false ? .primaryColor(withAlpha: 0.3) : UIColor.init(rgb: 0xEFEFEF)
        self.nameLabel.textColor = data.isSubTask == false ? .black : .primaryColor()
       
        self.headerLabelLConstraint.constant = data.isSubTask == false ? 0 : 10
        self.headerLabelTConstraint.constant = data.isSubTask == false ? 0 : 10
//        self.fieldView1LConstraint.constant = data.isSubTask == false ? 8 : 13
//        self.fieldView2TConstraint.constant = data.isSubTask == false ? 8 : 13
//        self.fieldView3LConstraint.constant = data.isSubTask == false ? 8 : 13
//        self.fieldView4TConstraint.constant = data.isSubTask == false ? 8 : 13
           
        target?.setup(schduleStartDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
        target?.setup(schduleEndDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
        target?.setup(schdulePICTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "personInChargeText"))
        target?.setup(accompalishDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "accomplishedDateText"))
        
        self.nameLabel.text = data.taskTitle
     
        self.accompalishDateTextField.inputAccessoryView = target?.theToolbarForDatePicker
        self.accompalishDateTextField.inputView = target?.theDatePicker
      
        self.accompalishDateTextField.delegate = target
        self.schduleStartDateTextField.delegate = target
        self.schduleEndDateTextField.delegate = target
        self.schdulePICTextField.delegate = target
        
        self.editButton.addTarget(target, action: #selector(target?.taskEditButtonTapped(_:)), for: .touchUpInside)
        self.historyButton.addTarget(target, action: #selector(target?.taskHistoryButtonTapped(_:)), for: .touchUpInside)
        self.addSubTaskButton.addTarget(target, action: #selector(target?.addDeleteSubTaskButtonTapped(_:)), for: .touchUpInside)

        self.permissionBasedAddDeleteSubTask()

        /// For sub task
        if data.isSubTask == true{
            self.hideShowEditView(startDate: data.subTaskStartDate ?? "", endDate: data.subTaskEndDate ?? "", taskPIC: data.subTaskPic ?? "")
            self.hideShowHistoryView(startDate: data.subTaskStartDate ?? "", endDate: data.subTaskEndDate ?? "", taskPIC: data.subTaskPic ?? "")
            
            self.handleAccomplished(accomplishedDate: data.subTaskAccomplishedDate ?? "")
            self.accompalishDateTextField.text = data.subTaskAccomplishedDate
            
            self.schduleStartDateTextField.text = data.subTaskStartDate
            self.schduleEndDateTextField.text = data.subTaskEndDate
            if let contact = contactList.first(where: {$0.id == data.subTaskPic}) {
                self.schdulePICTextField.text = contact.contactName
            }
            
            self.addSubTaskButton.setImage(UIImage.init(named: Config.Images.removeNewTask), for: .normal)
        }else{
            self.hideShowEditView(startDate: data.taskStartDate ?? "", endDate: data.taskEndDate ?? "", taskPIC: data.taskPic ?? "")
            self.hideShowHistoryView(startDate: data.taskStartDate ?? "", endDate: data.taskEndDate ?? "", taskPIC: data.taskPic ?? "")
            
            self.handleAccomplished(accomplishedDate: data.taskAccomplishedDate ?? "")
            self.accompalishDateTextField.text = data.taskAccomplishedDate
            
            self.schduleStartDateTextField.text = data.taskStartDate
            self.schduleEndDateTextField.text = data.taskEndDate
        
            if let contact = contactList.first(where: {$0.id == data.taskPic}) {
                self.schdulePICTextField.text = contact.contactName
            }
            
            self.addSubTaskButton.setImage(UIImage.init(named: Config.Images.addNewTask), for: .normal)
        }
        self.handleRemoveSubTask()
    }
    
    func permissionBasedAddDeleteSubTask(){
        if self.taskUpdateCellData?.isSubTask == false{ // Main Task
            if  RMConfiguration.shared.loginType == Config.Text.user || target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addSubTask.rawValue) == true{
                // Add permission allowed

            }else{
                self.addSubTaskButton.isHidden = true
                self.addSubTaskViewWConstraint.constant = 0
            }
       
        }else{ // Sub Task
            if  RMConfiguration.shared.loginType == Config.Text.user || target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.deleteSubTask.rawValue) == true{
               // Delete permission allowed
                self.addSubTaskButton.isHidden = false
                self.addSubTaskViewWConstraint.constant = 30
            }else{
                self.addSubTaskButton.isHidden = true
                self.addSubTaskViewWConstraint.constant = 0
            }
            
            if  RMConfiguration.shared.loginType == Config.Text.user || target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addSubTask.rawValue) == true{
               // Edit permission allowed
                self.headerEditViewWConstraint.constant = 30
                self.headerEditView.isHidden = false
            }else{
                self.headerEditViewWConstraint.constant = 0.0
                self.headerEditView.isHidden = true
            }
        }
    }

    //hide and show history view
    func hideShowHistoryView(startDate: String, endDate: String, taskPIC: String){
        if startDate.count != 0 || endDate.count != 0 || taskPIC != "0" {
            self.headerHistoryViewWConstraint.constant = 30.0
            self.headerHistoryView.isHidden = false
        }else{
            self.headerHistoryViewWConstraint.constant = 0.0
            self.headerHistoryView.isHidden = true
        }
        
    }
    
    // Main Task
    func hideShowMainTaskView(data: EditTaskSubTitleData, startDate: String, endDate: String, taskPIC: String){
        
    }
    
    // Subtask
    func hideShowEditView(startDate: String, endDate: String, taskPIC: String){
        if startDate.count != 0 || endDate.count != 0 || taskPIC != "0" {
            self.hideEditView()
        }else{
            self.showEditView()
            self.disbleTexField()
        }
    }
 
    func handleAccomplished(accomplishedDate: String){
        if accomplishedDate.isEmptyOrWhitespace() == false{
            self.disbleTexField()
            self.hideEditView()
            /// Hide plus button
            self.addSubtaskView.isHidden = true
            self.addSubTaskViewWConstraint.constant = 0.0
        }
    }
  
    func handleRemoveSubTask(){
        if schduleStartDateTextField.text?.isEmptyOrWhitespace() == false && schduleEndDateTextField.text?.isEmptyOrWhitespace() == false && schdulePICTextField.text?.isEmptyOrWhitespace() == false{
            if self.taskUpdateCellData?.isSubTask == true{
                // Hide remove button
                self.addSubtaskView.isHidden = true
                self.addSubTaskViewWConstraint.constant = 0.0
            }
        }
    }
    
    func hideEditView(){
        self.headerEditViewWConstraint.constant = 0.0
        self.headerEditView.isHidden = true
    }
    
    func showEditView(){
        self.headerEditViewWConstraint.constant = 30.0
        self.headerEditView.isHidden = false
    }
    
    func disbleTexField(){
        self.accompalishDateTextField.isUserInteractionEnabled = false
        self.schduleStartDateTextField.isUserInteractionEnabled = false
        self.schduleEndDateTextField.isUserInteractionEnabled = false
        self.schdulePICTextField.isUserInteractionEnabled = false
        
        self.accompalishDateTextField.isEnabled = false
        self.schduleStartDateTextField.isEnabled = false
        self.schduleEndDateTextField.isEnabled = false
        self.schdulePICTextField.isEnabled = false
    }
}
