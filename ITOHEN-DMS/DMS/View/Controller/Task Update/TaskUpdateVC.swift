//
//  TaskUpdateVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class TaskUpdateVC: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var topView: UIView!
   // @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet var orderNoLabel: UILabel!
    @IBOutlet var StyleNoLabel: UILabel!
    @IBOutlet var totalTaskLabel: UILabel!
    @IBOutlet var scheduledTasksLabel: UILabel!
    @IBOutlet var accomplishedTasksLabel: UILabel!
    @IBOutlet var yetToStartLabel: UILabel!
    @IBOutlet var pendingLabel: UILabel!
  
    @IBOutlet var orderNoTitleLabel: UILabel!
    @IBOutlet var styleNoTitleLabel: UILabel!
    @IBOutlet var totalTitleLabel: UILabel!
    @IBOutlet var yetToStarttitleLabel: UILabel!
    @IBOutlet var scheduledTitleLabel: UILabel!
    @IBOutlet var accomplishedTitleLabel: UILabel!
    @IBOutlet var pendingTitleLabel: UILabel!
    
    @IBOutlet var deliveryDatesTitleLabel: UILabel!
    @IBOutlet var deliveryDatesLabel: UILabel!
    @IBOutlet var deliveryDatesCollectionView: UICollectionView!
    
    var templateId:String = ""
    // selected template data model
    var dataSections:[EditTaskTemplateData] = []
    var tempSections:[EditTaskTemplateData] = []
    var orderTaskCount: OrderTaskCount?
    var contactList: [Contact] = []
    var deliveryDates: [DeliveryDates] = []{
        didSet{
            self.deliveryDatesCollectionView.reloadData()
        }
    }
    
    var basicInfo:Basic?
    var activeField: UITextField?{
        willSet{
            self.theDatePicker.date = Date()
        }
    }
    let theDatePicker = UIDatePicker()
    let theToolbarForDatePicker = UIToolbar()
    
    var orderId:String = "0"
    var orderNo:String = "0"
    var styleNo:String = "0"
    
    let basicInfoCellHeight:CGFloat = 170.0
    let fieldsCellHeight:CGFloat = 180.0
    let headerCellHeight:CGFloat = 70.0
    let fieldsCellBottomSpace:CGFloat = 15.0
    let ccellminimumLineSpacing:CGFloat = 15.0
    
    var tabBarVC:TabBarVC? {
        return self.parent?.parent as? TabBarVC
    }

    var taskUpdateFilterString: String?
    var isFilter: Bool = false
    var cellHeights = [IndexPath: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.taskUpdateDelegate = self
        self.setupUI()
        self.setupPickerViewWithToolBar()
        self.getTaskData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle()
        self.setupPickerViewWithToolBar()
        RestCloudService.shared.taskUpdateDelegate = self
      //  self.addNavigationItem(type: [.filter], align: .right)
        self.title = LocalizationManager.shared.localizedString(key: "taskUpdateTitle")
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.init(rgb: 0xF5F7FA, alpha: 0.9)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .none
        self.tableView.tableHeaderView = self.topView
        
        self.deliveryDatesCollectionView.dataSource = self
        self.deliveryDatesCollectionView.delegate = self
        self.deliveryDatesCollectionView.isScrollEnabled = true
     
        self.orderNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "orderNoText")
        self.styleNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "styleNoText")
        self.totalTitleLabel.text = LocalizationManager.shared.localizedString(key: "totalText")
        self.yetToStarttitleLabel.text = LocalizationManager.shared.localizedString(key: "yetToStartText")
        self.scheduledTitleLabel.text = LocalizationManager.shared.localizedString(key: "scheduledText")
        self.accomplishedTitleLabel.text = LocalizationManager.shared.localizedString(key: "accomplishedText")
        self.pendingTitleLabel.text = LocalizationManager.shared.localizedString(key: "pendingText")
        self.deliveryDatesTitleLabel.text = LocalizationManager.shared.localizedString(key: "deliveryDatesText")
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.topView.addBottomShadow()
    }
    
    func setupPickerViewWithToolBar() {
        theDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            theDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.theToolbarForDatePicker.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style:.plain, target: self, action: #selector(doneDateButtonTapped(_:)))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearButton2 = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "cancelButtonText"), style: .plain, target: self, action: #selector(clearButtonTapped(_:)))
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
        activeField?.text = ""
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    func getTaskData() {
        self.showHud()
        RestCloudService.shared.taskUpdateDelegate = self
        let params:[String:Any] = [ "order_id": self.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getTaskData(params: params)
    }
   
    func deleteSubTaskData(taskId: String, taskName: String) {
        let localizedString = LocalizationManager.shared.localizedString(key: "deleteTheSubtask")
        let message = String(format: localizedString, taskName)
        
        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "areYouSureText"),
                                    message: message,
                                    firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                    secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                    target: self) { (status) in
            if status == false{
                self.showHud()
                RestCloudService.shared.taskUpdateDelegate = self
                let params:[String:Any] = [ "taskId": taskId,
                                            "user_id": RMConfiguration.shared.userId,
                                            "staff_id": RMConfiguration.shared.staffId,
                                            "company_id": RMConfiguration.shared.companyId,
                                            "workspace_id": RMConfiguration.shared.workspaceId ]
                print(params)
                RestCloudService.shared.deleteSubTask(params: params)
            }
        }

    }
 
    func updateActualStartData(actualStartDate: String, taskId: String) {
        self.showHud()
        RestCloudService.shared.taskUpdateDelegate = self
        let params:[String:Any] = [  "taskId": taskId,
                                     "actualStartDate": actualStartDate,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.updateActualStartDate(params: params)
    }
    
    func bindTaskData(data: [EditTaskTemplateData]){
        self.dataSections = []
     
        for mainData in data{
           
            var data: EditTaskTemplateData = mainData
            var taskMainData: [EditTaskSubTitleData] = []

            for taskData in mainData.task_subtitles{
               
                taskMainData.append(EditTaskSubTitleData.init(taskID: taskData.taskID ?? "", taskSeq: taskData.taskSeq ?? "", catTitle: taskData.catTitle ?? "", taskTitle: taskData.taskTitle ?? "", taskPic: taskData.taskPic ?? "", subTaskPic: "", taskStartDate: taskData.taskStartDate ?? "", subTaskStartDate: "", taskEndDate: taskData.taskEndDate ?? "", subTaskEndDate: "", taskAccomplishedDate: taskData.taskAccomplishedDate ?? "", subTaskAccomplishedDate: "", rescheduled: taskData.rescheduled ?? "", taskContacts: taskData.taskContacts ?? [], subTasks: [], isSubTask: false))
               
                if let subTask = taskData.subtasks{
                    
                    for subTaskData in subTask{
                        taskMainData.append(EditTaskSubTitleData.init(taskID: subTaskData.id ?? "", taskSeq: "", catTitle: taskData.catTitle ?? "", taskTitle: subTaskData.subtasktitle ?? "", taskPic: taskData.taskPic ?? "", subTaskPic: subTaskData.picId ?? "", taskStartDate: taskData.taskStartDate ?? "", subTaskStartDate: subTaskData.subTaskStartDate ?? "", taskEndDate: taskData.taskEndDate ?? "", subTaskEndDate: subTaskData.subTaskEndDate ?? "", taskAccomplishedDate: taskData.taskAccomplishedDate ?? "", subTaskAccomplishedDate: subTaskData.subTaskAccomplishedDate ?? "", rescheduled: "", taskContacts: taskData.taskContacts ?? [], subTasks: [], isSubTask: true))
                    }
                }
            }
            data.task_subtitles = taskMainData
            self.dataSections.append(data)
        }
        
        print(self.dataSections)
        
        self.orderNoLabel.text = self.orderNo
        self.StyleNoLabel.text = self.styleNo
        self.totalTaskLabel.text = "\(self.orderTaskCount?.totalTask ?? 0)"
        self.yetToStartLabel.text = "\(self.orderTaskCount?.yetToStart ?? 0)"
        self.scheduledTasksLabel.text = "\(self.orderTaskCount?.scheduledTasks ?? 0)"
        self.accomplishedTasksLabel.text = "\(self.orderTaskCount?.accomplishedTasks ?? 0)"
        self.pendingLabel.text = "\(self.orderTaskCount?.pending ?? 0)"
        
        self.tableView.reloadData()
    }
    
    @objc func updateAccomplishedDate(taskId:String, taskName:String, date:String, section: Int, row: Int) {
        
        let localizedString = LocalizationManager.shared.localizedString(key: "addThisDateValidation")
        let message = String(format: localizedString, date, taskName)
    
        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "areYouSureText"),
                                    message: message,
                                    firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                    secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                    target: self) { (status) in
            if status == false{
                RestCloudService.shared.taskUpdateDelegate = self
                self.showHud()
                let params:[String:Any] = [ "user_id": RMConfiguration.shared.userId,
                                            "staff_id": RMConfiguration.shared.staffId,
                                            "company_id": RMConfiguration.shared.companyId,
                                            "workspace_id": RMConfiguration.shared.workspaceId,
                                            "taskId": taskId,
                                            "accomplishedDate": date ]
                print(params)
                RestCloudService.shared.updateAccomplishedTask(params: params)
            }else{
                self.activeField?.text = ""
            }
        }
      
    }
//
//    func popupPopView(orderStatusType: String) {
//        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .popUpView) as? PopUpView{
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            vc.orderStatusType = orderStatusType
//            vc.orderId = self.orderId
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//
    @objc func taskEditButtonTapped(_ sender: UIButton) {
        if RMConfiguration.shared.loginType == Config.Text.user || (self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addTaskUpdates.rawValue) == true) || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOthersTask.rawValue) == true{
            
            if let hasMainView = sender.superview?.superview{
                if let hasContentView = hasMainView.superview{
                    if let hasCell = hasContentView.superview as? TaskUpdateFieldsTableViewCell{
                        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskUpdateEdit) as? TaskUpdate_EditVC {
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            vc.orderId = self.orderId
                            vc.taskId = hasCell.taskId
                            vc.catId = hasCell.categoryId
                            vc.contactList = self.contactList
                            vc.taskUpdateData = hasCell.taskUpdateCellData
                            vc.screenTitle = hasCell.taskUpdateCellData?.taskTitle ?? ""
                            vc.delegate = self
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }else{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
            self.view.endEditing(true)
        }
        
    }
    
    func taskReSchedule(hasCell: TaskUpdateFieldsTableViewCell, scheduleType: String) {
        
        if RMConfiguration.shared.loginType == Config.Text.user || (hasCell.taskUpdateCellData?.taskPic == RMConfiguration.shared.staffId && self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addTaskUpdates.rawValue) == true) || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOthersTask.rawValue) == true{
            if scheduleType == Config.Text.pic{
                self.pushToReassign(hasCell: hasCell)
            }else{
                self.pushToReschedule(hasCell: hasCell,
                                      scheduleType: scheduleType)
            }
        }else{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
            self.view.endEditing(true)
        }
    }
    
    func pushToReschedule(hasCell: TaskUpdateFieldsTableViewCell, scheduleType: String){
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskRescheduleDate) as? TaskRescheduleDateVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.orderId = self.orderId
            vc.taskId = hasCell.taskId
            vc.rescheduleType = scheduleType
            vc.taskUpdateData = hasCell.taskUpdateCellData
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func pushToReassign(hasCell: TaskUpdateFieldsTableViewCell){
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskReAssignPIC) as? TaskReAssignPICVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.orderId = self.orderId
            vc.taskId = hasCell.taskId
            vc.contactList = self.contactList
            vc.taskUpdateData = hasCell.taskUpdateCellData
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func taskHistoryButtonTapped(_ sender: UIButton) {
        if let hasMainView = sender.superview?.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview as? TaskUpdateFieldsTableViewCell{
                    if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskRescheduleHistory) as? TaskRescheduleHistoryVC{
                        vc.orderId = self.orderId
                        vc.taskId = hasCell.taskId
                        vc.catName = hasCell.taskUpdateCellData?.taskTitle ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
   
    @objc func addDeleteSubTaskButtonTapped(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            if let hasMainView = sender.superview?.superview{
                if let hasContentView = hasMainView.superview{
                    if let hasCell = hasContentView.superview as? TaskUpdateFieldsTableViewCell{
                        
                        if hasCell.taskUpdateCellData?.isSubTask == false{
                            if  RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addSubTask.rawValue) == true{
                                if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addSubTask) as? AddSubTaskVC{
                                    vc.modalPresentationStyle = .overCurrentContext
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.orderId = self.orderId
                                    vc.templateId = self.templateId
                                    vc.contactList = self.contactList
                                    vc.taskUpdateData = hasCell.taskUpdateCellData
                                    vc.delegate = self
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }else{
                                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText") , message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"), target: self)
                            }
                       
                        }else{
                            if  RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.deleteSubTask.rawValue) == true{
                                self.deleteSubTaskData(taskId: hasCell.taskId, taskName: hasCell.taskUpdateCellData?.taskTitle ?? "")
                            }else{
                                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText") , message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"), target: self)
                            }
                        }
                        
                    }
                }
            }
        }
    
    }

    func getTaskUpdateFieldCell() -> TaskUpdateFieldsTableViewCell? {
        if let hasMainView = activeField?.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview as? TaskUpdateFieldsTableViewCell{
                    return hasCell
                }
            }
        }else{
        }
        return nil
    }

}

extension TaskUpdateVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView{ // Parent tableview
            var count = dataSections.count
            for _ in dataSections {
                count += 1
            }
            return tableView.updateNumberOfRow(count)
        }else{ // Task fields tableview
            return self.dataSections[tableView.tag].task_subtitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if tableView == self.tableView{ // Parent tableview
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TaskUpdateHeaderTableViewCell
                cell.setContent(indexSection: section, section: self.dataSections[section],target: self)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! TaskUpdateContentTableViewCell
                cell.setContent(indexSection: section, target: self)
                return cell
            }
        }else{ // Task fields tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell") as! TaskUpdateFieldsTableViewCell
            if indexPath.row < self.dataSections[tableView.tag].task_subtitles.count{
                cell.taskId = self.dataSections[tableView.tag].task_subtitles[indexPath.row].taskID ?? ""
                cell.contactList = self.contactList
                cell.setContent(target: self, data: self.dataSections[tableView.tag].task_subtitles[indexPath.row], section: tableView.tag, index: indexPath.row)
            }
            return cell
          
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView{ // Parent tableview
            // Calculate the real section index and row index
            let section = getSectionIndex(indexPath.row)
            let row = getRowIndex(indexPath.row)
            
            // Header has fixed height
            if row == 0 {
                return self.headerCellHeight
            }
            
            let noOfSizeItems = CGFloat(dataSections[section].task_subtitles.count)
            return dataSections[section].collapsed ?? false ? 0.0 : (noOfSizeItems * self.fieldsCellHeight)
        }else{ // Task fields tableview
            return self.fieldsCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    //
    // MARK: - Event Handlers
    //
    @objc func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = dataSections[section].collapsed
   
        // Toggle collapse
        dataSections[section].collapsed = !(collapsed ?? false)
        self.tableView.reloadData()
  
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

extension TaskUpdateVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return deliveryDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DeliveryDatesCollectionViewCell
        cell.setContent(date: self.deliveryDates[indexPath.row], target: self)
        return cell
    }

}

extension TaskUpdateVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if let cell = self.getTaskUpdateFieldCell(){
            if textField == cell.accompalishDateTextField{
                var minDate = DateTime.stringToDatetaskUpdate(dateString: cell.startDate, dateFormat: "yyyy-MM-dd")
                if let date = minDate, date>Date(){
                    minDate = Date()
                }
                theDatePicker.minimumDate = minDate
                theDatePicker.maximumDate = Date()
            }else if textField == cell.schduleStartDateTextField{
                self.taskReSchedule(hasCell: cell, scheduleType: "StartDate")
            }else if textField == cell.schduleEndDateTextField{
                self.taskReSchedule(hasCell: cell, scheduleType: "EndDate")
            }else if textField == cell.schdulePICTextField{
                self.taskReSchedule(hasCell: cell, scheduleType: "PIC")
            }
            
            if textField != cell.accompalishDateTextField{
                textField.inputView = UIView()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text ?? "").isEmptyOrWhitespace(){
            if let cell = self.getTaskUpdateFieldCell(){
                if textField == cell.accompalishDateTextField{
                    let table: UITableView = cell.superview as! UITableView
        let indexPath = table.indexPath(for: cell)!
                    
                    if DateTime.stringToDatetaskUpdate(dateString: cell.startDate, dateFormat: Date.simpleDateFormat) ?? Date() > DateTime.stringToDatetaskUpdate(dateString: textField.text ?? "", dateFormat: Date.simpleDateFormat) ?? Date(){
                        UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "accomplished_task_error_text"),
                                                    target: self)
                        textField.text = ""
                        return
                    }
                    self.updateAccomplishedDate(taskId: cell.taskId, taskName: cell.taskUpdateCellData?.taskTitle ?? "", date: textField.text ?? "", section: indexPath.section, row: indexPath.row)
                }
                
            }
        }else{
            activeField = nil
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        if let cell = self.getTaskUpdateFieldCell(){
            if textField == cell.accompalishDateTextField{
                if RMConfiguration.shared.loginType == Config.Text.user || (cell.taskUpdateCellData?.taskPic == RMConfiguration.shared.staffId && self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addTaskUpdates.rawValue) == true) || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOthersTask.rawValue) == true{
                    return true
                }else { 
                    UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                                message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                                target: self)
                    return false
                }
            }
        }
        
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

extension TaskUpdateVC: ReloadUpdateTaskDelegate {
    func reloadUpdateTaskScreen(orderId: String) {
        self.orderId = orderId
        self.getTaskData()
    }
}

extension UITableView {
  func reloadSectionWithoutAnimation(section: Int) {
      UIView.performWithoutAnimation {
          let offset = self.contentOffset
          self.reloadSections(IndexSet(integer: section), with: .none)
          self.contentOffset = offset
      }
  }
}

extension TaskUpdateVC: RCTaskUpdateDelegate{
  
    func didReceiveGetTaskData(data: DMSGetTaskData?){
        self.hideHud()
//    templateId: "\(response.value?.templateID ?? 0)",
//                                               templateName: response.value?.templateName ?? "",
//                                               data: response.value?.data,
//                                               orderTaskCountData: response.value?.orderTaskCount,
//                                               contactList: response.value?.pic
        if let taskData = data{
            self.orderTaskCount = taskData.orderTaskCount
            self.templateId = "\(taskData.templateID ?? 0)"
            self.contactList = taskData.pic ?? []
            
            self.deliveryDatesLabel.text = taskData.deliveryDates?.count ?? 0 > 0 ? "\(taskData.deliveryDates?[0].delivery_date ?? "")" : "-"
            self.bindTaskData(data: taskData.data)
        }
    }
    
    func didFailedToReceiveGetTaskData(errorMessage: String){
        self.hideHud()
        self.topView.isHidden = true
        //self.topViewHConstraint.constant = 0
    }
    
    func didReceiveUpdateAccomplishedTask(statusCode: Int, message: String){
        self.hideHud()
        if statusCode == Config.ErrorCode.SUCCESS{
            UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
                self.getTaskData()
                let accomplished = (Int(self.accomplishedTasksLabel.text ?? "0") ?? 0) + 1
                let pending = (Int(self.pendingLabel.text ?? "0") ?? 0) - 1
                self.accomplishedTasksLabel.text = "\(accomplished)"
                self.pendingLabel.text = "\(pending)"
            })
        }else {
            activeField?.text = ""
            UIAlertController.showAlert( title: LocalizationManager.shared.localizedString(key: "accomplishedDateText"),
                                         message: String().getAlertSuccess(message: message),
                                         target: self )
        }
      
    }
    
    func didFailedToReceiveUpdateAccomplishedTask(errorMessage: String){
        self.hideHud()
        activeField?.text = ""
        UIAlertController.showAlert( title: LocalizationManager.shared.localizedString(key: "accomplishedDateText"),
                                     message: String().getAlertSuccess(message: errorMessage),
                                     target: self )
    }
    
    /// Delete sub  task
    func didReceiveDeleteSubTask(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            self.getTaskData()
        })
    }
    func didFailedToReceiveDeleteSubTask(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
    
    /// Update actual start date
    func didReceiveUpdateActualStartDate(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            self.getTaskData()
        })
    }
    func didFailedToReceiveUpdateActualStartDate(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
}
