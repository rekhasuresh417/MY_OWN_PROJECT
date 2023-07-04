//
//  TaskInputVC.swift
//  Itohen-dms
//
//  Created by Dharma on 19/01/21.
//

import UIKit
import MaterialComponents

class TaskInputVC: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var saveAsButton:UIButton!
    @IBOutlet var saveFileButton: UIButton!
    @IBOutlet var bottomViewHConstraint: NSLayoutConstraint!
    
   // var allTemplatesList:[String] = []
    var templateId: String = ""
    var templateName: String = ""
    // selected template data model
    var templateList: [DMSTaskTemplatesData] = []
    var editTemplateList: [DMSGetTaskData] = []
    
    var addSections: [TaskTemplateStructure] = []
    var tvSections: [TaskTVSections] = []
    
    // Get Task Data
    var dataSections: [EditTaskTemplateData] = []
    var taskFilesData: [TaskFilesData] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var tempTaskFiles: [TaskFilesData] = []{
        didSet{
            self.saveFileButton.isHidden = tempTaskFiles.count>0 ? false : true
            self.saveButton.isHidden = tempTaskFiles.count>0 ? true : false
            self.saveAsButton.isHidden = tempTaskFiles.count>0 || displayType != .add ? true : false
        }
    }
    
    var contactData:[OrderContact] = []
    var allContacts: [String] = [String]()
    weak var activeField: UITextField?{
        willSet{
            self.theDatePicker.date = Date()
        }
    }
    
    var displayType: TaskInputDisplayType = .view
    
    let theTemplatePicker = UIPickerView()
    let thePicker = UIPickerView()
    let theDatePicker = UIDatePicker()
    let theToolbarForDatePicker = UIToolbar()
    let theToolbarForPicker = UIToolbar()
    let theTemplateToolbarForPicker = UIToolbar()
    
    var orderId:String = "0"
    var orderInfoDelegate:OrderInfoDataUpdateDelegate?
    var isDelete: Bool = false
    var fileIndex: Int = 0
    
    let reorderCellHeight:CGFloat = 45.0
    let addCategoryCellHeight:CGFloat = 66.0
    let templateCellHeight:CGFloat = 120
    let contentCellSpace:CGFloat = 50.0
    let fieldsCellHeight:CGFloat = 200.0
    let headerCellHeight:CGFloat = 50.0
    let fieldsCellBottomSpace:CGFloat = 15.0
    let ccellminimumLineSpacing:CGFloat = 15.0
    let uploadCellHeight:CGFloat = 50.0
    let downloadCellHeight:CGFloat = 70.0
    var cellHeights = [IndexPath: CGFloat]()
    var categoriesAndTasksSectionIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.taskDelegate = self
        self.loadTableViewSections()
        self.setupUI()
        self.getTaskFiles()
        
        if self.displayType == .add || self.displayType == .edit{
            self.enableSaveButton()
            self.setupPickerViewWithToolBar()
        }
        
        if self.displayType == .edit || self.displayType == .view{
            self.getTaskData()
        }else{
            self.getTaskTemplate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.title = self.displayType == .view ? LocalizationManager.shared.localizedString(key: "taskInputTitleForTaskView") : LocalizationManager.shared.localizedString(key: "taskInputTitle")
    }
    
    func loadTableViewSections(){
        if self.displayType == .add{
            self.tvSections = [TaskTVSections.selectTemplate, TaskTVSections.uploadFile, TaskTVSections.downloadFile, TaskTVSections.reOrder, TaskTVSections.categoriesAndTasks]
        }else if self.displayType == .edit{
            self.tvSections = [TaskTVSections.selectTemplate, TaskTVSections.uploadFile, TaskTVSections.downloadFile, TaskTVSections.categoriesAndTasks]
        }else if self.displayType == .view{
            self.tvSections = [TaskTVSections.selectTemplate, TaskTVSections.downloadFile, TaskTVSections.categoriesAndTasks]
        }
        categoriesAndTasksSectionIndex = self.tvSections.firstIndex(of: .categoriesAndTasks) ?? 0
    }
    
    func setupUI() {
        self.view.backgroundColor = .appBackgroundColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .none
        self.tableView.showsVerticalScrollIndicator = false
  
        self.saveButton.backgroundColor = .primaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveContinueButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
        self.saveButton.isHidden = self.displayType == .view ? true : false
        
        self.saveAsButton.backgroundColor = .primaryColor()
        self.saveAsButton.layer.borderWidth = 1.0
        self.saveAsButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.saveAsButton.layer.cornerRadius = self.saveAsButton.frame.height / 2.0
        self.saveAsButton.setTitle(LocalizationManager.shared.localizedString(key: "saveTemplateButtonText"), for: .normal)
        self.saveAsButton.setTitleColor(.white, for: .normal)
        self.saveAsButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveAsButton.addTarget(self, action: #selector(self.saveAsButtonTapped(_:)), for: .touchUpInside)
        self.saveAsButton.isHidden = self.displayType == .add ? false : true
        
        self.saveFileButton.backgroundColor = .primaryColor()
        self.saveFileButton.layer.borderWidth = 1.0
        self.saveFileButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.saveFileButton.layer.cornerRadius = self.saveFileButton.frame.height / 2.0
        self.saveFileButton.setTitle(LocalizationManager.shared.localizedString(key: "saveFileButtonText"), for: .normal)
        self.saveFileButton.setTitleColor(.white, for: .normal)
        self.saveFileButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveFileButton.addTarget(self, action: #selector(self.saveFileButtonTapped(_:)), for: .touchUpInside)
        self.saveFileButton.isHidden = true
        
        self.bottomViewHConstraint.constant = self.displayType == .view ? 0.0 : 50.0
    }
    
    func setupPickerViewWithToolBar(){
        theTemplatePicker.dataSource = self
        theTemplatePicker.delegate = self
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
        
        self.theTemplateToolbarForPicker.sizeToFit()
        let doneButton3 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                                          style:.plain,
                                          target: self,
                                          action: #selector(doneTemplateButtonTapped(_:)))
        let spaceButton3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                           target: nil,
                                           action: nil)
        let spaceButton4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                           target: nil,
                                           action: nil)
        self.theTemplateToolbarForPicker.setItems([spaceButton3,spaceButton4,doneButton3], animated: false)
    }
    
    
    override func doneButtonTapped(_ sender: AnyObject) {
        if self.thePicker.selectedRow(inComponent: 0) < self.contactData.count{
            let data = self.contactData[self.thePicker.selectedRow(inComponent: 0)]
            activeField?.text = "\(data.firstName ?? "") \(data.lastName ?? "")"
            
            if let hasCell = self.getTaskFieldCell(){
                self.updateSectionData(section: hasCell.section,
                                       index: hasCell.index,
                                       text: data.staffId ?? "",
                                       isTaskPic: true)
            }
        }
        thePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    @objc func doneDateButtonTapped(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.simpleDateFormat
        activeField?.text = formatter.string(from: theDatePicker.date)
        if let hasCell = self.getTaskFieldCell(){
            if activeField == hasCell.startDateTextField{
                self.updateSectionData(section: hasCell.section, index: hasCell.index, text: activeField?.text ?? "", isStartDate: true, isEndDate: false)
            }else if activeField == hasCell.endDateTextField{
                self.updateSectionData(section: hasCell.section, index: hasCell.index, text: activeField?.text ?? "",isStartDate: false, isEndDate: true)
            }else{
                self.updateSectionData(section: hasCell.section, index: hasCell.index, text: activeField?.text ?? "", isStartDate: false, isEndDate: false)
            }
            
        }
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
        theDatePicker.minimumDate = Date()
    }
    
    func ValidateDateTextField(){
        let formatter = DateFormatter()
        formatter.dateFormat = Date.simpleDateFormat
        if let hasCell = self.getTaskFieldCell(){
            if activeField == hasCell.endDateTextField{
                let startDate = self.dataSections[hasCell.section].task_subtitles[hasCell.index].taskStartDate ?? ""
                let strDate = DateTime.convertDateFormater(startDate, currentFormat: Date.simpleDateFormat, newFormat: Date.inspectionDateFormat)
                let date = DateTime.stringToDate(dateString: strDate, dateFormat: Date.inspectionDateFormat)
                theDatePicker.minimumDate = date
            }
        }
    }
    
    @objc func doneTemplateButtonTapped(_ sender: UIBarButtonItem) {
        if self.theTemplatePicker.selectedRow(inComponent: 0) < self.templateList.count {
            activeField?.text = self.templateList[self.theTemplatePicker.selectedRow(inComponent: 0)].templateName
            self.templateId = self.templateList[self.theTemplatePicker.selectedRow(inComponent: 0)].templateId ?? ""
            self.bindTasktemplateData(templateId: self.templateId)
            self.isDelete = false
        }
        theTemplatePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    func getDataModel(isReloadSection: Bool){
        self.dataSections = []
      for category in self.addSections{
            var index: Int = 0
            var taskSubTitles: [EditTaskSubTitleData] = []
            for subTask in category.task_subtitles{
                taskSubTitles.append(EditTaskSubTitleData.init(taskID: "", taskSeq: "\(index)", catTitle: "", taskTitle: subTask, taskPic: "", subTaskPic: "", taskStartDate: "", subTaskStartDate: "", taskEndDate: "", subTaskEndDate: "", taskAccomplishedDate: "", subTaskAccomplishedDate: "", rescheduled: "", taskContacts: [], subTasks: [], isSubTask: false))
                index+=1
            }
            let catSection = EditTaskTemplateData.init(taskTitle: category.task_title, taskSubTitles: taskSubTitles)
            self.dataSections.append(catSection)
        }
        print("datasection", dataSections)
        if isReloadSection{
            self.tableView.reloadSections(IndexSet(integer: categoriesAndTasksSectionIndex), with: .automatic)
        }else{
            self.tableView.reloadData()
        }
     
    }
  
    @objc func clearDateButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        if let hasCell = self.getTaskFieldCell(){
            self.updateSectionData(section: hasCell.section,index: hasCell.index, text: activeField?.text ?? "")
        }
        theToolbarForDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        if let hasCell = self.getTaskFieldCell(){
            self.updateSectionData(section: hasCell.section, index: hasCell.index, text: activeField?.text ?? "", isTaskPic: true)
        }
        thePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    func getTaskFieldCell() -> TaskFieldsTableViewCell? {
        if let hasMainView = activeField?.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview as? TaskFieldsTableViewCell{
                    return hasCell
                }
            }
        }
        return nil
    }
    
    func getContactNameForId(id: String) -> String {
        let index = self.contactData.firstIndex { (data) -> Bool in
            return "\(data.staffId ?? "")" == id
        }
        guard let hasIndex = index else {
            return ""
        }
        return "\(self.contactData[hasIndex].firstName ?? "") \(self.contactData[hasIndex].lastName ?? "")"
    }
  
    func getTaskContacts(cid:String, tid:String) -> [String] {
//        for category in self.sections{
//            if category.categoryID == cid{
//                for task in category.data{
//                    if task.taskID == tid{
//                        return task.taskContacts ?? []
//                    }
//                }
//            }
//        }
        return []
    }
 
    func getTaskTemplate() {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getTaskTemplate(params: params)
    }
    
    func getTaskFiles() {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getTaskFiles(params: params)
    }
    
    func getTaskData() {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getTaskData(params: params)
    }
    
    func bindTasktemplateData(templateId: String){
        
        print(templateId)
        let indexValue = self.templateList.firstIndex{$0.templateId == templateId}
        if let index = indexValue{
            self.addSections = []
            let jsonData = (templateList[index].taskTemplateStructure ?? "").data(using: .utf8)!
            self.addSections = try! JSONDecoder().decode([TaskTemplateStructure].self, from: jsonData)
            
            self.templateId = templateList[index].templateId ?? "0"
            self.templateName = templateList[index].templateName ?? "0"
        }
        self.getDataModel(isReloadSection: false)
    }
 
    func bindTaskData(templateId: String, templateName: String, data: [EditTaskTemplateData]){
        self.templateId = templateId
        self.templateName = templateName
        self.dataSections = data
        self.tableView.reloadData()
    }
    
    func updateSectionData(section: Int, index: Int, text:String, isStartDate: Bool = false, isEndDate: Bool = false,  isTaskPic:Bool = false) {
        if isStartDate{
            self.dataSections[section].task_subtitles[index].taskStartDate = text
        }else if isEndDate {
            self.dataSections[section].task_subtitles[index].taskEndDate = text
        }else if isTaskPic{
            self.dataSections[section].task_subtitles[index].taskPic = text
        }
    }
    
    func removeTask(section: Int, index: Int) {
        self.dataSections[section].task_subtitles.remove(at: index)
        if self.addSections.count>0{
            self.addSections[section].task_subtitles.remove(at: index)
        }
        self.tableView.reloadSections(IndexSet(integer: categoriesAndTasksSectionIndex), with: .automatic)
    }
   
    @objc func addNewCategoryButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addNewTask) as? AddNewTaskVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.section = sender.tag
            vc.getAllContacts = self.allContacts
            vc.type = .category
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }

    @objc func addNewTaskButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addNewTask) as? AddNewTaskVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.section = sender.tag
            vc.getAllContacts = self.self.allContacts
            vc.type = .task
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func categoryDeleteButtonTapped(_ sender: UIButton) {
        if sender.tag < self.dataSections.count{
            UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "deleteCategoryPrefixText")) \(self.dataSections[sender.tag].task_title)?",
                                        firstButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                        secondButtonTitle: LocalizationManager.shared.localizedString(key: "deleteButtonText"),
                                        target: self) { (status) in
                print(status)
                if status{
                    self.isDelete = true
                    self.enableSaveButton()
                    self.dataSections.remove(at: sender.tag)
                    if self.addSections.count>0{
                        self.addSections.remove(at: sender.tag)
                    }
                    self.tableView.reloadSections(IndexSet(integer: self.categoriesAndTasksSectionIndex), with: .automatic)
                }
            }
        }
    }
    
    @objc func categoryLinkButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .concernedMembers) as? ConcernedMembersVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.contactList = self.contactData
            vc.type = .category
            //vc.selectedContacts = self.contactData
            vc.orderInfoDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func taskDeleteButtonTapped(_ sender: UIButton) {
        if let hasMainView = sender.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview?.superview as? TaskFieldsTableViewCell{
                    UIAlertController.showAlert(message: "\(LocalizationManager.shared.localizedString(key: "deleteTaskPrefixText")) \(hasCell.nameLabel.text ?? "")?",
                                                firstButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                                secondButtonTitle: LocalizationManager.shared.localizedString(key: "deleteButtonText"),
                                                target: self) { (status) in
                        print(status)
                        if status{
                            self.isDelete = true
                            self.enableSaveButton()
                            self.removeTask(section: hasCell.section, index: hasCell.index)
                        }
                    }
                }
            }
        }
    }
    
    @objc func taskEditButtonTapped(_ sender: UIButton) {
        if let hasMainView = sender.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview?.superview as? TaskFieldsTableViewCell{
                    if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .concernedMembers) as? ConcernedMembersVC{
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        vc.taskId = hasCell.taskId
                        vc.categotyId = hasCell.categoryId
                        vc.contactList = self.contactData
                        vc.selectedContacts = self.getTaskContacts(cid: hasCell.categoryId, tid: hasCell.taskId)
                        vc.type = .task
                        vc.orderInfoDelegate = self
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
  
    func enableSaveButton(){
        if isDelete{
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.5
            
            self.saveAsButton.isEnabled = true
            self.saveAsButton.alpha = 1.0
        }else{
            self.saveButton.isEnabled = true
            self.saveButton.alpha = 1.0
            
            self.saveAsButton.isEnabled = false
            self.saveAsButton.alpha = 0.5
        }
    }
    
    @objc func saveAsButtonTapped(_ sender: UIButton) {
        
        self.showAlertWithTextField(title: LocalizationManager.shared.localizedString(key: "enterTemplateNameText"),
                                    textFieldText: "",
                                    placeHolderText: LocalizationManager.shared.localizedString(key: "templateNameText"),
                                    firstButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                    secondButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText")) { (text) in
            if text.count == 0 || text.isEmpty{
                return
            }
            self.getEmptyTemplateModel(name:text)
        }
    }
  
    @objc func saveFileButtonTapped(_ sender: UIButton) {
        self.saveUploadeedFiles()
    }
    
    func getEmptyTemplateModel(name:String){
        self.addSections = []
      for category in self.dataSections{
            var index: Int = 0
            var taskSubTitles: [String] = []
            for subTask in category.task_subtitles{
                taskSubTitles.append(subTask.taskTitle ?? "")
                index+=1
            }
            let catSection = TaskTemplateStructure.init(taskTitle: category.task_title, taskSubTitles: taskSubTitles)
            self.addSections.append(catSection)
        }
//        print("datasection", addSections)
//        self.addSections = self.addSections.reversed()
        print("datasection", addSections)
        if self.addSections.count>0{
            self.saveAsTemplate(name: name)
        }

    }
    
    func saveAsTemplate(name:String) {
        
        if self.addSections.count == 0 || self.templateId == ""{
            return
        }
 
        var taskData:[[String:Any]] = []
        
        for category in self.addSections{
            taskData.append(category.asDictionary)
        }
      
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "template_name": name,
                                    "task_template_structure": taskData
        ]
        print(params)
        RestCloudService.shared.createTaskTemplate(params: params)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        
        if  self.dataSections.count == 0 || self.templateId == ""{
            return
        }
        
        var taskData:[String:Any] = [:]
        var index: Int = 0

        for category in self.dataSections{
            var categoryData:[String: Any] = [:]
            for subTask in category.task_subtitles{
                categoryData["\(index)"] = subTask.asDictionary
                index+=1
            }
            taskData[category.task_title] = categoryData
        }
      
        print("taskData", taskData)
        if taskData.count>0{
            self.showHud()
            let params:[String: Any] = [ "order_id": RMConfiguration.shared.orderId,
                                         "user_id": RMConfiguration.shared.userId,
                                         "staff_id": RMConfiguration.shared.staffId,
                                         "company_id": RMConfiguration.shared.companyId,
                                         "workspace_id": RMConfiguration.shared.workspaceId,
                                         "template_id": self.templateId,
                                         "template_data": taskData ]
            print(params)
            RestCloudService.shared.createTaskData(params: params)
        }
        
    }
  
    func saveUploadeedFiles(){
        self.showHud()
        
        print(self.tempTaskFiles, self.tempTaskFiles.count)
       
        self.tempTaskFiles.forEach({$0.id = ""})
        
        var form = MultipartForm()
        form.parts.append(MultipartForm.Part(name: "order_id", value: RMConfiguration.shared.orderId))
        form.parts.append(MultipartForm.Part(name: "user_id", value: RMConfiguration.shared.userId))
        form.parts.append(MultipartForm.Part(name: "staff_id", value: RMConfiguration.shared.staffId))
        form.parts.append(MultipartForm.Part(name: "company_id", value: RMConfiguration.shared.companyId))
        form.parts.append(MultipartForm.Part(name: "workspace_id", value: RMConfiguration.shared.workspaceId))
        form.parts.append(MultipartForm.Part(name: "order_id", value: RMConfiguration.shared.orderId))
        
        for (index, taskFiles) in self.tempTaskFiles.enumerated(){
            print(taskFiles)
            do{
                if let url = URL(string: taskFiles.filepath){
                    let fileData = try Data.init(contentsOf: url)
                    form.parts.append(MultipartForm.Part(name: "additional_spec.\(index)",
                                                         data: fileData,
                                                         filename: url.lastPathComponent,
                                                         contentType: url.pathExtension))
                }
                
            }catch{
                print("contents could not be loaded")
            }
        }
        
        let baseUrl = RMConfiguration.shared.loginType == Config.Text.user ? Config.baseURL : "\(Config.baseURL)staff/"
        
        print("\(baseUrl)\(Config.API.ADD_FILES)")
        if let url = URL(string: "\(baseUrl)\(Config.API.ADD_FILES)") {
            var request = URLRequest(url:  url)
        
            request.httpMethod = "POST"
            request.setValue(form.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = form.bodyData
         
            let hasToken = RMConfiguration.shared.accessToken
            if hasToken.count > 0, !hasToken.isEmpty{
                request.addValue("Bearer \(hasToken)", forHTTPHeaderField: "Authorization")
            }
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        if let res = json as? [String: Any]{
                          
                            if let code = res["status_code"] as? Int, code == Config.ErrorCode.SUCCESS{
                                UIAlertController.showAlertWithCompletionHandler(message: res["message"] as! String, target: self, alertCompletionHandler: { _ in
                                    DispatchQueue.main.async {
                                        self.tempTaskFiles = []
                                        self.getTaskFiles()
                                    }
                                })
                            }else{
                                if let error = res["error"] as? String{
                                    UIAlertController.showAlert(message: error, target: self)
                                }
                            }
                          
                        }
                    } catch {
                        print(error)
                    }
                }else{
                    UIAlertController.showAlert(message: "Failed to upload files, Please retry", target: self)
                }
                
                self.hideHud()
                
            }.resume()
        }
    }
        
    /// Upload files
    func uploadFiles() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: Config.DocumentType.supportedDocsTypes, in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .overFullScreen
        self.present(documentPicker, animated: false, completion: nil)
    }
    
    func deleteTaskFile(data: TaskFilesData){
        
        UIAlertController.showAlertWithCompletionHandler(title: LocalizationManager.shared.localizedString(key: "sure_to_delete_task_file_msg"),
                                                         message: data.orginalfilename,
                                                         firstButtonTitle: LocalizationManager.shared.localizedString(key: "noButtonText"),
                                                         secondButtonTitle: LocalizationManager.shared.localizedString(key: "yesButtonText"),
                                                         firstButtonStyle: .cancel, secondButtonStyle: .destructive, target: self)
        { index in
            if index == 1{
                self.showHud()
                let params:[String: Any] = [ "fileId": data.id,
                                             "user_id": RMConfiguration.shared.userId,
                                             "staff_id": RMConfiguration.shared.staffId,
                                             "company_id": RMConfiguration.shared.companyId,
                                             "workspace_id": RMConfiguration.shared.workspaceId,
                                             "order_id": RMConfiguration.shared.orderId]
                print(params)
                RestCloudService.shared.deleteTaskFiles(params: params)
            }
        }
     }
    
    func removeSpecFileLocally(filesData: TaskFilesData? = nil, index: Int){
        self.taskFilesData.remove(at: index)
        print(self.tempTaskFiles.count, filesData?.id)
        self.tempTaskFiles = self.tempTaskFiles.filter{$0.id != filesData?.id}
        print(self.tempTaskFiles.count)
    }
    
    func pushToTaskFileListVC() {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskFileListVC) as? TaskFileListVC {
            vc.specModel = self.taskFilesData
            vc.target = self
            vc.pageType = self.displayType
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func taskFileReAssign(taskFiles: [TaskFilesData]) {
        self.taskFilesData = taskFiles
    }
}

extension TaskInputVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView{ // Parent tableview
            return self.tvSections.count
        }else{ // Task fields tableview
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{ // Parent tableview
            if self.tvSections[section] == .selectTemplate || self.tvSections[section] == .reOrder || self.tvSections[section] == .uploadFile{
                return 1
            }else if self.tvSections[section] == .downloadFile {
                if taskFilesData.count > 3{
                    return 3
                }
                return taskFilesData.count
            }else if self.tvSections[section] == .categoriesAndTasks{
                // For section categoriesAndTasks, the total count is items count plus the number of headers
                var count = dataSections.count
                for _ in dataSections {
                    count += 1
                }
                return count
            
            }else{
                return 0
            }
        }else{ // Task fields tableview
            return self.dataSections[tableView.tag].task_subtitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if tableView == self.tableView{ // Parent tableview
            if self.tvSections[indexPath.section] == .selectTemplate {
                let cell = tableView.dequeueReusableCell(withIdentifier: "templateCell") as! TaskTemplateTableViewCell
                cell.displayMode = self.displayType
                cell.setContent(target: self)
                return cell
            }else if self.tvSections[indexPath.section] == .reOrder{
                let cell = tableView.dequeueReusableCell(withIdentifier: "reOrderCell") as! TaskReOrderTVCell
                cell.setContent(target: self)
                return cell
            }else if self.tvSections[indexPath.section] == .uploadFile{
                let cell = tableView.dequeueReusableCell(withIdentifier: "fileUpload") as! TaskFileUploadTVCell
                cell.setContent( target: self)
                return cell
            }else if self.tvSections[indexPath.section] == .downloadFile{
                let cell = tableView.dequeueReusableCell(withIdentifier: "fileDownload") as! TaskFileDownloadTVCell
                cell.taskFilesList = taskFilesData
                cell.pageType = self.displayType == .add ? .add : .edit
                cell.setContent(index: indexPath.row, data: taskFilesData[indexPath.row], target: self)
                return cell
            }else if self.tvSections[indexPath.section] == .categoriesAndTasks{
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TaskHeaderTableViewCell
                    cell.displayMode = self.displayType
                    cell.setContent(indexSection: section,section: self.dataSections[section], target: self)
    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! TaskContentTableViewCell
                    cell.displayMode = self.displayType
                    cell.setContent(indexSection: section, target: self)
                    return cell
                }
            }else{
                return UITableViewCell()
            }
        }else{ // Task fields tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell") as! TaskFieldsTableViewCell
            cell.displayMode = self.displayType
            if indexPath.row < self.dataSections[tableView.tag].task_subtitles.count{
                cell.setContent(target: self, section: tableView.tag, index: indexPath.row)
                cell.setData(data: self.dataSections[tableView.tag].task_subtitles[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView{ // Parent tableview
            
            if self.tvSections[indexPath.section] == .selectTemplate {
                return self.templateCellHeight
            }else if self.tvSections[indexPath.section] == .reOrder {
                return self.reorderCellHeight
            }else if self.tvSections[indexPath.section] == .uploadFile {
                return self.uploadCellHeight
            }else if self.tvSections[indexPath.section] == .downloadFile {
                if taskFilesData.count > 3 {
                    return indexPath.row == 2 ? downloadCellHeight + 30 : downloadCellHeight
                }
                return self.downloadCellHeight
            }else if self.tvSections[indexPath.section] == .categoriesAndTasks {
                // Calculate the real section index and row index
                let section = getSectionIndex(indexPath.row)
                let row = getRowIndex(indexPath.row)
                
                // Header has fixed height
                if row == 0 {
                    return self.headerCellHeight
                }
                
                var noOfSizeItems: CGFloat = 0
                noOfSizeItems = CGFloat(dataSections[section].task_subtitles.count)
                
                let expandSize:CGFloat = (noOfSizeItems * self.fieldsCellHeight)
               // expandSize = expandSize + (self.displayType == .add ? self.contentCellSpace: self.contentCellSpace - 30.0)
                return dataSections[section].collapsed ?? false ? 0.0 : expandSize
                
            }else{
                return 0.0
            }
        }else{ // Task fields tableview
            return self.fieldsCellHeight
        }
    }
    
    //
    // MARK: - Event Handlers
    //
    @objc func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        var collapsed: Bool? = false
        
        collapsed = dataSections[section].collapsed
        dataSections[section].collapsed = !(collapsed ?? false)
        
        // Toggle collapse
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        /* 1 denotes 1 tableview for each section */
        let end = start + 1 //sections[section].selectedSizes.count
                
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            //self.tableView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
            for i in start ..< end + 1 {
                self.tableView.reloadRows(at: [IndexPath(row: i, section: self.categoriesAndTasksSectionIndex)], with: .none)
            }
            self.tableView.endUpdates()
        }
    }
    
    //
    // MARK: - Helper Functions
    //
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
       
        for _ in dataSections {
            indices.append(index)
            index += 2 //section.selectedSizes.count + 1
        }

        return indices
    }
    
}

extension TaskInputVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        self.ValidateDateTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
}

extension TaskInputVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.theTemplatePicker{
            return self.templateList.count
        }else{
            return self.contactData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.theTemplatePicker{
            return self.templateList[row].templateName
        }else{
            return self.contactData[row].firstName?.appending(self.contactData[row].lastName ?? "")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension TaskInputVC: TaskInputAddNewTaskOrCategoryDelegate {
 
    func addedNewTaskOrCategoryFor(_ section: Int?, type: TemplateAddNew, taskData: String, categoryData: TaskTemplateStructure?) {
        if type == .task{
            self.addSections[section ?? 0].task_subtitles.append(taskData)
        }else{

            if let data = categoryData{
                self.addSections.append(data)
            }
        }
        self.isDelete = true
        self.enableSaveButton()
        self.getDataModel(isReloadSection: true)
     
    }
}

extension TaskInputVC: TaskInputAddConcernedMembersDelegate {
    func updateConcernedMembersOf(_ categoryId: String, taskId: String, type: ConcernedMembersFor, data: [String], dataForInstance: [String], unselectedDataForInstance: [String]) {
//        if type == .category{
//            for index in self.sections.indices{
//                          if self.sections[index].categoryID == categoryId{
//                              self.sections[index].categoryContacts = data
//                    // Update newly added category contacts into all tasks of category
//                    for taskIndex in self.sections[index].data.indices{
//                        if self.sections[index].data[taskIndex].taskContacts == nil{
//                            self.sections[index].data[taskIndex].taskContacts = dataForInstance
//                        }else{
//                            self.sections[index].data[taskIndex].taskContacts?.append(contentsOf: dataForInstance)
//                        }
//                    }
//
//                    // Update removed category contacts into all tasks of category
//                    for taskIndex in self.sections[index].data.indices{
//                        let filterdData = (self.sections[index].data[taskIndex].taskContacts ?? []).filter {unselectedDataForInstance.contains($0) == false}
//                        self.sections[index].data[taskIndex].taskContacts = filterdData
//                    }
//                    break
//                }
//            }
//        }else if type == .task{
//            for index in self.sections.indices{
//                if self.sections[index].categoryID == categoryId{
//                    for taskIndex in self.sections[index].data.indices{
//                        if self.sections[index].data[taskIndex].taskID == taskId{
//                            self.sections[index].data[taskIndex].taskContacts = data
//                            break
//                        }
//                    }
//                }
//            }
//        }
    }
}

extension TaskInputVC: RCTaskDelegate{
    
    func didReceiveTaskTemplate(data: [DMSTaskTemplatesData]?){
        self.hideHud()
        if let templateData = data{
            self.templateList = templateData
            self.bindTasktemplateData(templateId: self.templateList[0].templateId ?? "") // Default Statndard template chosen
        }
    }
    
    func didFailedToReceiveTaskTemplate(errorMessage: String){
        self.hideHud()
    }
  
    func didReceiveCreateTaskTemplate(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.isDelete = false
                self.enableSaveButton()
                self.getTaskTemplate()
            }
        })
    }
    
    func didFailedToReceiveCreateTaskTemplate(errorMessage: String){
        self.hideHud()
    }
    
    func didReceiveGetTaskData(templateId: String, templateName: String, data: [EditTaskTemplateData]?){
        self.hideHud()
        if let taskData = data{
            self.bindTaskData(templateId: templateId, templateName: templateName, data: taskData)
        }
    }
    
    func didFailedToReceiveGetTaskData(errorMessage: String){
        self.hideHud()
    }
    
    func didReceiveCreateTaskData(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.orderInfoDelegate?.updateOrderInfoData(.task, orderInfoData: nil)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func didFailedToReceiveCreateTaskData(errorMessage: String){
        self.hideHud()
    }
    
    func didReceiveGetTaskFiles(data: [TaskFilesData]){
        self.hideHud()
        self.taskFilesData = data
    }
    
    func didFailedToReceiveGetTaskFiles(errorMessage: String){
        self.hideHud()
    }
   
    /// Delete files list delegates
    func didReceiveDeleteTaskFiles(message: String, fileId: String){
        self.hideHud()
        if let index = self.taskFilesData.firstIndex(where: { $0.id == fileId }) {
            self.taskFilesData.remove(at: index)
        }
    }
    
    func didFailedToReceiveDeleteTaskFiles(errorMessage: String){
        self.hideHud()
    }
    
 
}

/// DocumentPickerDelegate
extension TaskInputVC: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    
        if urls.count>3{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "file_exceeded_text"),
                                        message: LocalizationManager.shared.localizedString(key: "max_file_server_text"),
                                        target: self)
            return
        }else if urls.count + self.taskFilesData.count > 10{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "total_max_file_text"),
                                        message: "Already uploaded \(self.taskFilesData.count) files",
                                        target: self)
            return
        }
        
        let singleFileStorage = Config.AppConstants.singleFileStorage
        
        for fileURL in urls{
            
            if self.getFileSize(url: fileURL) > Int(singleFileStorage) ?? 0{
                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "file_size_exceeded_text"),
                                            message: LocalizationManager.shared.localizedString(key: "single_file_size_text"),
                                            target: self)
                return
            }
            
            let taskFiles = TaskFilesData.init(id: "-\(tempTaskFiles.count)", fileSize: "\(self.getFileSize(url: fileURL))", fileName: fileURL.lastPathComponent, orginalfilename: fileURL.lastPathComponent, filepath: "\(fileURL)")
            self.tempTaskFiles.append(taskFiles)
            self.taskFilesData.insert(taskFiles, at: 0)
            
        }
    
        print(taskFilesData.count, self.tempTaskFiles.count)
    }
           
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
      
}
