//
//  UserSettingsVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 08/11/22.
//

import UIKit
import MaterialComponents

class UserSettingsVC: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var generalSettingTitleLabel: UILabel!
    @IBOutlet var dateTextField: MDCOutlinedTextField!
    @IBOutlet var timeTextField: MDCOutlinedTextField!
    @IBOutlet var generalSettingButton: UIButton!
    
    @IBOutlet var dashboardViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var notificationSettingTitleLabel: UILabel!
    @IBOutlet var notificationSettingButton: UIButton!
    @IBOutlet var notificationSettingTableView: UITableView!
    @IBOutlet var notificationTableHContraint: NSLayoutConstraint!
    
    @IBOutlet var emailSettingTitleLabel: UILabel!
    @IBOutlet var emailSettingButton: UIButton!
    @IBOutlet var emailSettingTableView: UITableView!
    @IBOutlet var emailSettingTableHContraint: NSLayoutConstraint!
 
    @IBOutlet var dashboardSettingTitleLabel: UILabel!
    @IBOutlet var dashboardSettingButton: UIButton!
    @IBOutlet var dashboardSettingTableView: UITableView!
    @IBOutlet var dashboardTableHContraint: NSLayoutConstraint!
    
    @IBOutlet var generalSettingView: UIView!
    @IBOutlet var notificationSettingView: UIView!
    @IBOutlet var emailSettingView: UIView!
    @IBOutlet var dashBoardSettingView: UIView!
  
    @IBOutlet var allDayLabel: UILabel!
    @IBOutlet var sundayLabel: UILabel!
    @IBOutlet var mondayLabel: UILabel!
    @IBOutlet var tuesdayLabel: UILabel!
    @IBOutlet var wenesdayLabel: UILabel!
    @IBOutlet var thursdayLabel: UILabel!
    @IBOutlet var fridayLabel: UILabel!
    @IBOutlet var saturdayLabel: UILabel!
    
    
    weak var activeField: UITextField?{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    let thePicker = UIPickerView()
    let theToolbarForPicker = UIToolbar()

    var dateFormat: [DMSDateFormat] = []
    var timeZoneFormat: [DMSTimeZoneFormat] = []
    var notificationSettings: [DMSNotificationSettings] = []{
        didSet{
            notificationSettingTableView.reloadData()
        }
    }
    var emailScheduleSettings: [DMSEmailScheduleSettings] = []{
        didSet{
            emailSettingTableView.reloadData()
        }
    }
    var dashboardSettings: [DMSDashboardSettings] = []{
        didSet{
            self.dashboardSettingTableView.reloadData()
            self.dashboardTableHContraint.constant = CGFloat(self.dashboardSettings.count * 42)
        }
    }
    
    var selectedGeneralSettings: DMSSelectedGeneralSettings?
    var selectedNotificationSettings: DMSSelectedNotificationSettings?
    var selectedEmailSettings: [DMSEMailSettings] = []
    var selectedDashboardSettings: [DMSDashboardSettings] = []
    
    var selectedNotifSettingsRows:[IndexPath] = []
    var selectedEmailSettingsRows:[IndexPath] = []
    var selectedDashboardSettingsRows:[IndexPath] = []
    var selectedDate: String = ""
    var selectedTime: String = ""
    var isFromTabBar: Bool = false
    var tempDateFormat: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        RestCloudService.shared.settingsDelegate = self
        self.getSettingsData()
        self.loadItems()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView),
                                                   name: .reloadUserSettingsVC, object: nil)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromTabBar{
            self.dashboardViewBottomConstraint.constant = 70
        }else{
            self.dashboardViewBottomConstraint.constant = 20
        }
        self.setTitle()
    }
    
    func setupUI(){
      
        self.contentView.backgroundColor = UIColor.init(rgb: 0xF5F7FA)
        [generalSettingView, notificationSettingView, emailSettingView, dashBoardSettingView].forEach { (theView) in
            theView?.backgroundColor = .white
            theView?.roundCorners(corners: .allCorners, radius: 8)
        }
     
        [generalSettingTitleLabel, notificationSettingTitleLabel, emailSettingTitleLabel, dashboardSettingTitleLabel].forEach { (theLabel) in
            theLabel?.textAlignment = .left
            theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theLabel?.textColor = .primaryColor()
        }
     
        [dateTextField, timeTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .none
        }

        [generalSettingButton, notificationSettingButton, emailSettingButton, dashboardSettingButton].forEach { (theButton) in
            theButton?.backgroundColor = .white
            theButton?.setTitleColor(.primaryColor(), for: .normal)
            theButton?.layer.borderWidth  = 1.0
            theButton?.layer.cornerRadius = generalSettingButton.frame.height / 2.0
            theButton?.layer.borderColor = UIColor.primaryColor().cgColor
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        }
        
        self.generalSettingButton.addTarget(self, action: #selector(self.generalSettingsButtonTapped(_:)), for: .touchUpInside)
        self.notificationSettingButton.addTarget(self, action: #selector(self.notificationSettingButtonTapped(_:)), for: .touchUpInside)
        self.emailSettingButton.addTarget(self, action: #selector(self.emailSettingButtonTapped(_:)), for: .touchUpInside)
        self.dashboardSettingButton.addTarget(self, action: #selector(self.dashboardSettingButtonTapped(_:)), for: .touchUpInside)
        
        self.notificationSettingTableView.dataSource = self
        self.notificationSettingTableView.delegate = self
        self.notificationSettingTableView.separatorStyle = .none
        self.notificationSettingTableView.backgroundColor = .none
        self.notificationSettingTableView.isScrollEnabled = false
        
        self.emailSettingTableView.dataSource = self
        self.emailSettingTableView.delegate = self
        self.emailSettingTableView.separatorStyle = .none
        self.emailSettingTableView.backgroundColor = .none
        self.emailSettingTableView.isScrollEnabled = false
        
        self.dashboardSettingTableView.dataSource = self
        self.dashboardSettingTableView.delegate = self
        self.dashboardSettingTableView.separatorStyle = .none
        self.dashboardSettingTableView.backgroundColor = .none
        self.dashboardSettingTableView.isScrollEnabled = false
    
    }

    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        theToolbarForPicker.sizeToFit()
        
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.dateTextField.inputView = thePicker
        self.timeTextField.inputView = thePicker
        
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                                          style:.plain, target: self,
                                          action: #selector(doneButtonTapped(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                           target: nil,
                                           action: nil)
        let clearButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "clearText"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(clearButtonTapped(_:)))
        self.theToolbarForPicker.setItems([clearButton, spaceButton, doneButton], animated: false)
        
        self.dateTextField.inputAccessoryView = theToolbarForPicker
        self.timeTextField.inputAccessoryView = theToolbarForPicker
    }
   
    func loadItems(){
        self.setupPickerViewWithToolBar()

        [allDayLabel, sundayLabel, mondayLabel, tuesdayLabel, wenesdayLabel, thursdayLabel, fridayLabel, saturdayLabel].forEach { (theLabel) in
            theLabel?.textAlignment = .center
            theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            allDayLabel.text = LocalizationManager.shared.localizedString(key: "allButtonText")
            sundayLabel.text = LocalizationManager.shared.localizedString(key: "sundayText")
            mondayLabel.text = LocalizationManager.shared.localizedString(key: "mondayText")
            tuesdayLabel.text = LocalizationManager.shared.localizedString(key: "tuesdayText")
            wenesdayLabel.text = LocalizationManager.shared.localizedString(key: "wenesdayText")
            thursdayLabel.text = LocalizationManager.shared.localizedString(key: "thursText")
            fridayLabel.text = LocalizationManager.shared.localizedString(key: "fridayText")
            saturdayLabel.text = LocalizationManager.shared.localizedString(key: "saturdayText")
        }
        
        [generalSettingButton, notificationSettingButton, emailSettingButton, dashboardSettingButton].forEach { (theButton) in
            theButton?.layer.borderWidth  = 1.0
            theButton?.layer.cornerRadius = emailSettingButton.frame.height / 2.0
            theButton?.layer.borderColor = UIColor.primaryColor().cgColor
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
            theButton?.setTitle("  \(LocalizationManager.shared.localizedString(key: "saveButtonText"))  ", for: .normal)
        }
       
        generalSettingTitleLabel.text = LocalizationManager.shared.localizedString(key: "generalSettingsText")
        notificationSettingTitleLabel.text = LocalizationManager.shared.localizedString(key: "notificationSettingsText")
        dashboardSettingTitleLabel.text = LocalizationManager.shared.localizedString(key: "dashboardSettingsText")
        emailSettingTitleLabel.text = LocalizationManager.shared.localizedString(key: "emailSettingsText")
    
    }
    
    func setTitle(){
      
        if isFromTabBar{
            self.addNavigationItem(type: [.menu], align: .left)
            var tempItems: [UIBarButtonItem] = []
            let menuButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(toggleHomeMenu(_:)))
            menuButton.tintColor = UIColor.white
            tempItems.append(menuButton)
            self.parent?.navigationItem.leftBarButtonItems = tempItems
            self.parent?.title = LocalizationManager.shared.localizedString(key: "userSettingText")
            self.setupUI()
        }else{
            self.title = LocalizationManager.shared.localizedString(key: "userSettingText")
        }
    }
    
    @objc func reloadTableView(){
        self.setupUI()
        self.setTitle()
        self.loadItems()
        self.notificationSettingTableView.reloadData()
        self.emailSettingTableView.reloadData()
        self.dashboardSettingTableView.reloadData()
    }
    
    func getSettingsData() {
        self.showHud()
        let params:[String:Any] = [ "userId": RMConfiguration.shared.userId,
                                    "staffId": RMConfiguration.shared.staffId,
                                    "companyId": RMConfiguration.shared.companyId,
                                    "workspaceId": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getSettingsDetails(params: params)
    }
    
    func saveGeneralSettings() {
        self.showHud()
        let params:[String:Any] = [ "userId": RMConfiguration.shared.userId,
                                    "staffId": RMConfiguration.shared.staffId,
                                    "companyId": RMConfiguration.shared.companyId,
                                    "workspaceId": RMConfiguration.shared.workspaceId,
                                    "date_format": self.selectedDate,
                                    "timezoneId": self.selectedTime]
        print(params)
        RestCloudService.shared.saveGeneralSettings(params: params)
    }
    
    func saveNotificationSettings() {
        
        self.showHud()
        var params:[String:Any] = ["user_id": RMConfiguration.shared.userId,
                                   "staff_id": RMConfiguration.shared.staffId,
                                   "company_id": RMConfiguration.shared.companyId,
                                   "workspace_id": RMConfiguration.shared.workspaceId
                                    ]
        for index in selectedNotifSettingsRows{
            params["\(self.notificationSettings[index.row].name ?? "")"] = "6"
        }
        
        print(params)
        RestCloudService.shared.saveNotificationSettings(params: params)
    }

    func saveEmailSettings() {
        
        var emailSchedule:[[String:Any]] = []
        for data in self.emailScheduleSettings{
            emailSchedule.append([
                "id" : data.id ?? 0,
                "days" : data.days ?? []
                ])
        }
        
        self.showHud()
        var params:[String:Any] = [ "userId": RMConfiguration.shared.userId,
                                    "staffId": RMConfiguration.shared.staffId,
                                    "companyId": RMConfiguration.shared.companyId,
                                    "workspaceId": RMConfiguration.shared.workspaceId
                                   ]
        params["emailSchedule"] = emailSchedule
        
        print(params)
        RestCloudService.shared.saveEmailSettings(params: params)
    }
    
    func saveDashboardSettings() {
        
        self.showHud()
        var params: [String: Any] = ["user_id": RMConfiguration.shared.userId,
                                     "staff_id": RMConfiguration.shared.staffId,
                                     "company_id": RMConfiguration.shared.companyId,
                                     "workspace_id": RMConfiguration.shared.workspaceId
        ]
        var data: [Int] = []
        for setting in self.dashboardSettings{
            if setting.isChecked == true{
                data.append(setting.id ?? 0)
            }
        }
        params["data"] = data
        print(params)
        RestCloudService.shared.saveDashboardSettings(params: params)
    }
    
    ///user-preferenc
    func bindSettingsData(data: DMSSettingsData){
        self.dateFormat = data.generalSetting?.dateformat ?? []
        self.timeZoneFormat = data.generalSetting?.timezoneformat ?? []
        self.notificationSettings = data.notificationSettings ?? []
        self.emailScheduleSettings = data.emailScheduleSettings ?? []
        self.dashboardSettings = data.dashboardSettings ?? []
        
        if let selectedSettingData = data.selectedGeneralSettings{
            self.selectedGeneralSettings = selectedSettingData
            self.bindGeneralSetting()
        }
        if let selectedNotifSetting = data.selectedNotificationSettings{
            self.selectedNotificationSettings = selectedNotifSetting
            self.bindSelectedNotificationSetting()
    
        }
        if let selectedEmailSetting = data.selectedEmailScheduleSettings?.emailsettings{
            self.selectedEmailSettings = selectedEmailSetting
            self.bindSelectedEmailSetting()
        }
        if let selectedDashboardSetting = data.dashboardSettings{
            self.selectedDashboardSettings = selectedDashboardSetting
            self.bindSelectedDashboardSetting()
        }
        
        self.notificationSettingTableView.reloadData()
        self.notificationTableHContraint.constant = CGFloat(self.notificationSettings.count * 42)
        self.emailSettingTableHContraint.constant = CGFloat(self.emailScheduleSettings.count * 80)
        
    }
  
    func bindGeneralSetting(){
        
        self.setup(dateTextField!, placeholderLabel: LocalizationManager.shared.localizedString(key: "dateFormatText"))
        self.setup(timeTextField!, placeholderLabel: LocalizationManager.shared.localizedString(key: "timeText"))
       
        self.dateFormat.indices.forEach { (index) in
            if self.dateFormat[index].name == self.selectedGeneralSettings?.dateFormat {
                self.dateTextField.text = self.dateFormat[index].displayName
                RMConfiguration.shared.dateFormat = String().convertDMSDateFormat(dateFormat: DateFormat(rawValue: self.dateFormat[index].name ?? "") ?? .D_SP_M_SP_Y)
            }
        }
        
        self.timeZoneFormat.indices.forEach { (index) in
            if self.timeZoneFormat[index].name == self.selectedGeneralSettings?.timeZoneFormat {
                self.timeTextField.text = self.timeZoneFormat[index].timezone
            }
        }
    }
    
    func bindSelectedNotificationSetting(){
        
        if self.selectedNotificationSettings?.emailDueToday == "6"{
            self.selectedNotifSettingsRows.append(IndexPath(row: 0, section: 0))
        }
        if self.selectedNotificationSettings?.emailDueTomorrow == "6"{
            self.selectedNotifSettingsRows.append(IndexPath(row: 1, section: 0))
        }
        if self.selectedNotificationSettings?.emailTaskReschedule == "6"{
            self.selectedNotifSettingsRows.append(IndexPath(row: 2, section: 0))
        }
        if self.selectedNotificationSettings?.emailDailyReminder == "6"{
            self.selectedNotifSettingsRows.append(IndexPath(row: 3, section: 0))
        }
        if self.selectedNotificationSettings?.emailWeeklyReminder == "6"{
            self.selectedNotifSettingsRows.append(IndexPath(row: 4, section: 0))
        }
        if self.selectedNotificationSettings?.emailTaskAccomplishment == "6"{
            self.selectedNotifSettingsRows.append(IndexPath(row: 5, section: 0))
        }
        
        self.notificationSettingTableView.reloadData()
    }
    
    func bindSelectedDashboardSetting(){
        self.selectedDashboardSettingsRows.removeAll()
        for dashboard in self.selectedDashboardSettings{
            if dashboard.isChecked == true{
                self.selectedDashboardSettingsRows.append(IndexPath(row: ((dashboard.id ?? 0)  - 1), section: 0))
            }
        }
        self.dashboardSettingTableView.reloadData()
    }
    
    func bindSelectedEmailSetting(){
        var index: Int = 0
        for data in self.selectedEmailSettings{
            self.emailScheduleSettings.indices.forEach { (index) in
                if self.emailScheduleSettings[index].id == data.emailScheduleTaskId {
                    let days = data.days?.components(separatedBy: ",") ?? []
                    self.emailScheduleSettings[index].days = days
                    if days.count == 7{
                        self.selectedEmailSettingsRows.append(IndexPath(row: index, section: 0))
                    }
                }
            }
            index = index + 1
        }
        self.emailSettingTableView.reloadData()
    }
    
    @objc override func doneButtonTapped(_ sender:AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            thePicker.endEditing(true)
            return
        }
        
        if activeField == dateTextField && row < dateFormat.count{
            activeField?.text = dateFormat[row].displayName
            activeField?.tag = dateFormat[row].id ?? 0
            self.selectedDate = dateFormat[row].name ?? ""
        }else if activeField == timeTextField && row < timeZoneFormat.count{
            activeField?.text = timeZoneFormat[row].timezone
            activeField?.tag = timeZoneFormat[row].id ?? 0
            self.selectedTime = timeZoneFormat[row].name ?? ""
        }
        print(selectedDate, selectedTime)
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }
   
    @objc func toggleHomeMenu(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .menuBar) as? MenuBarVC {
                vc.preferredSheetSizing = .large
                let navVC = UINavigationController(rootViewController:vc)
                navVC.isNavigationBarHidden = true
                navVC.modalPresentationStyle = .overCurrentContext
                navVC.modalTransitionStyle = .crossDissolve
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        self.view.endEditing(true)
    }

    @objc func generalSettingsButtonTapped(_ sender: UIButton){
        self.saveGeneralSettings()
    }
    
    @objc func notificationSettingButtonTapped(_ sender: UIButton){
        self.saveNotificationSettings()
    }
    
    @objc func emailSettingButtonTapped(_ sender: UIButton){
        self.saveEmailSettings()
    }
    
    @objc func dashboardSettingButtonTapped(_ sender: UIButton){
        self.saveDashboardSettings()
    }
    
    @objc func notificationCheckBoxSelection(_ sender: UIButton)
    {
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        if self.selectedNotifSettingsRows.contains(selectedIndexPath){
            self.selectedNotifSettingsRows.remove(at: self.selectedNotifSettingsRows.firstIndex(of: selectedIndexPath)!)
        }else {
            self.selectedNotifSettingsRows.append(selectedIndexPath)
        }
        print(self.selectedNotifSettingsRows)

        self.notificationSettingTableView.reloadData()
        
    }
    
    @objc func dashboardCheckBoxSelection(_ sender: UIButton)
    {
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        
        self.dashboardSettings[selectedIndexPath.row].isChecked = !(self.dashboardSettings[selectedIndexPath.row].isChecked ?? true)
      
//        if self.selectedDashboardSettingsRows.contains(selectedIndexPath){
//            self.selectedDashboardSettingsRows.remove(at: self.selectedDashboardSettingsRows.firstIndex(of: selectedIndexPath)!)
//        }else {
//            self.selectedDashboardSettingsRows.append(selectedIndexPath)
//        }
 //       print(self.selectedDashboardSettingsRows)

        self.dashboardSettingTableView.reloadData()
        
    }
    
    @objc func weekdaysButtonTapped(_ sender: UIButton)
    {
        if let cell = self.getEmailSettingCell(theButton: sender){
            let index = cell.allDayButton.tag
            let day = self.getDay(index: sender.tag)
            let isPresent = emailScheduleSettings[index].days?.contains(day)

            if isPresent ?? false{
                if let dayIndex = emailScheduleSettings[index].days?.firstIndex(of: day) {
                    emailScheduleSettings[index].days?.remove(at: dayIndex)
                }
            }else{
                if emailScheduleSettings[index].days == nil{
                    emailScheduleSettings[index].days = []
                }
                switch sender.tag{
                case 1:
                    emailScheduleSettings[index].days?.append(Days.sunday.rawValue)
                case 2:
                    emailScheduleSettings[index].days?.append(Days.monday.rawValue)
                case 3:
                    emailScheduleSettings[index].days?.append(Days.tuesday.rawValue)
                case 4:
                    emailScheduleSettings[index].days?.append(Days.wednesday.rawValue)
                case 5:
                    emailScheduleSettings[index].days?.append(Days.thursday.rawValue)
                case 6:
                    emailScheduleSettings[index].days?.append(Days.friday.rawValue)
                case 7:
                    emailScheduleSettings[index].days?.append(Days.saturday.rawValue)
                default:
                    return
                }
            }
            
            print(self.emailScheduleSettings[index], self.emailScheduleSettings[index].days ?? [], Days.sunday.rawValue)

        }

        self.emailSettingTableView.reloadData()
        
    }
   
    func getDay(index: Int) -> String {
        switch index{
        case 1:
            return Days.sunday.rawValue
        case 2:
            return Days.monday.rawValue
        case 3:
            return Days.tuesday.rawValue
        case 4:
            return Days.wednesday.rawValue
        case 5:
            return Days.thursday.rawValue
        case 6:
            return Days.friday.rawValue
        case 7:
            return Days.saturday.rawValue
        default:
            return ""
        }
    }
    
    @objc func selectAllButtonTapped(_ sender: UIButton) {
      
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        if self.selectedEmailSettingsRows.contains(selectedIndexPath){
            self.selectedEmailSettingsRows.remove(at: self.selectedEmailSettingsRows.firstIndex(of: selectedIndexPath)!)
            self.emailScheduleSettings[selectedIndexPath.row].days = []
        }else {
            self.selectedEmailSettingsRows.append(selectedIndexPath)
            self.emailScheduleSettings[selectedIndexPath.row].days = Config.weekdays.days
        }
        print(self.selectedEmailSettingsRows)
        self.emailSettingTableView.reloadData()
    }
    
    func getAllIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for j in 0..<emailSettingTableView.numberOfRows(inSection: 0) {
            indexPaths.append(IndexPath(row: j, section: 0))
        }
        return indexPaths
    }
  
    func getEmailSettingCell(theButton: UIButton) -> EmailScheduleSettingsTVCell? {
        if let hasMainView = theButton.superview{
            if let stackView = hasMainView.superview?.superview{
                if let hasContentView = stackView.superview{
                    if let hasCell = hasContentView.superview as? EmailScheduleSettingsTVCell{
                        return hasCell
                    }
                }
            }
          
        }else{
        }
        return nil
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .reloadHomeVC, object: nil)
        self.dismiss(animated: true)
    }
}

extension UserSettingsVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserSettingsVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == notificationSettingTableView{
            return notificationSettings.count
        }else if tableView == dashboardSettingTableView{
            return self.dashboardSettings.count
        }else{
            return emailScheduleSettings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.notificationSettingTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationSettingsTVCell
            cell.setContent(data: notificationSettings[indexPath.row])
           
            if selectedNotifSettingsRows.contains(indexPath) {
                cell.checkBoxButton.isSelected = true
            }else {
                cell.checkBoxButton.isSelected = false
            }
            cell.checkBoxButton.tag = indexPath.row
            cell.checkBoxButton.addTarget(self, action: #selector(notificationCheckBoxSelection(_:)), for: .touchUpInside)
            
            return cell
            
        }else if tableView == self.dashboardSettingTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationSettingsTVCell
            if indexPath.row < self.dashboardSettings.count {
                cell.setDashboardContent(data: dashboardSettings[indexPath.row])
            }
            
//            if selectedDashboardSettingsRows.contains(indexPath) {
//                cell.checkBoxButton.isSelected = true
//            }else {
//                cell.checkBoxButton.isSelected = false
//            }
            cell.checkBoxButton.tag = indexPath.row
            cell.checkBoxButton.addTarget(self, action: #selector(dashboardCheckBoxSelection(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmailScheduleSettingsTVCell
            cell.setContent(data: emailScheduleSettings[indexPath.row], target: self)
            
            if selectedEmailSettingsRows.contains(indexPath) && emailScheduleSettings[indexPath.row].days?.count == 7{
                cell.allDayButton.isSelected = true
            }else {
                cell.allDayButton.isSelected = false
            }
            cell.allDayButton.tag = indexPath.row
            cell.allDayButton.addTarget(self, action: #selector(selectAllButtonTapped(_:)), for: .touchUpInside)
            
            [cell.sundayButton, cell.mondayButton, cell.tuesdayButton, cell.wenesdayButton, cell.thursdayButton, cell.fridayButton, cell.saturdayButton].forEach { (theButton) in
                theButton?.addTarget(self, action: #selector(weekdaysButtonTapped(_:)), for: .touchUpInside)
            }
            
            return cell
        }
      
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.pushToOrderInfo(id: self.onGoingList[indexPath.row].id ?? "")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == self.notificationSettingTableView{
//            return 40.0
//        }else{
//            return 90
//        }
//    }

}

extension UserSettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == dateTextField{
            return dateFormat.count
        }else{
            return timeZoneFormat.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == dateTextField{
            return dateFormat[row].displayName
        }else{
            return timeZoneFormat[row].timezone
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension UserSettingsVC: RCSettingsDelegate{
    func didReceiveSettingDetails(data: DMSSettingsData?){
        self.hideHud()
        if let settingsData = data{
            self.bindSettingsData(data: settingsData)
        }
    }
    
    func didFailedToReceiveSettingDetails(errorMessage: String){
        self.hideHud()
    }
    
    /// save general settings
    func didReceiveSaveGeneralSettings(message: String){
        self.hideHud()
        RMConfiguration.shared.dateFormat = String().convertDMSDateFormat(dateFormat: DateFormat(rawValue: selectedDate) ?? .D_SP_M_SP_Y)
        NotificationCenter.default.post(name: .reloadHomeItemsVC, object: nil)
        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "generalSettingsText"),
                                    message: LocalizationManager.shared.localizedString(key: "savedSuccessfully"),
                                    target: self )
    }
    func didFailedToReceiveSaveGeneralSettings(errorMessage: String){
        self.hideHud()
    }
    
    /// save notification settings
    func didReceiveSaveNotificationSettings(message: String){
        self.hideHud()
        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "notificationSettingsText"),
                                    message: LocalizationManager.shared.localizedString(key: "savedSuccessfully"),
                                    target: self )
    }
    func didFailedToReceiveSaveNotificationSettings(errorMessage: String){
        self.hideHud()
    }
   
    /// save dashboard settings
    func didReceiveSaveDashboardSettings(message: String){
        self.hideHud()
        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "dashboardSettingsText"),
                                    message: LocalizationManager.shared.localizedString(key: "savedSuccessfully"),
                                    target: self )
    }
   
    func didFailedToReceiveSaveDashboardSettings(errorMessage: String){
        self.hideHud()
    }
    
    /// save email schedule settings
    func didReceiveSaveEmailScheduleSettings(message: String){
        self.hideHud()
        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "emailSettingsText"),
                                    message: LocalizationManager.shared.localizedString(key: "savedSuccessfully"),
                                    target: self )
    }
    func didFailedToReceiveSaveEmailScheduleSettings(errorMessage: String){
        self.hideHud()
    }
}
