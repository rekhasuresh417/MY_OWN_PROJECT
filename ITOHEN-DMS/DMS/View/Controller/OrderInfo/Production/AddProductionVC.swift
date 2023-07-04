//
//  AddProductionVC.swift
//  Itohen-dms
//
//  Created by Dharma on 31/01/21.
//

import UIKit
import JTAppleCalendar
import MaterialComponents

class AddProductionVC: UIViewController {
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var workingDaysLabel:UILabel!
    @IBOutlet var notesLabel:UILabel!
   
    @IBOutlet var dateView: UIView!
    @IBOutlet var holidayView: UIView!
    @IBOutlet var cuttingDateView: UIView!
    @IBOutlet var sewingDateView: UIView!
    @IBOutlet var packingDateView: UIView!
    
    @IBOutlet var sundayButton:UIButton!
    @IBOutlet var mondayButton:UIButton!
    @IBOutlet var tuesdayButton:UIButton!
    @IBOutlet var wednesdayButton:UIButton!
    @IBOutlet var thursdayButton:UIButton!
    @IBOutlet var fridayButton:UIButton!
    @IBOutlet var saturdayButton:UIButton!
    
    @IBOutlet var sectionView:UIView!
    @IBOutlet var cuttingButton:UIButton!
    @IBOutlet var sewingButton:UIButton!
    @IBOutlet var packingButton:UIButton!
    
    @IBOutlet var toggleCuttingStartDateButton:UIButton!
    @IBOutlet var toggleCuttingEndDateButton:UIButton!

    @IBOutlet var toggleSewingStartDateButton:UIButton!
    @IBOutlet var toggleSewingEndDateButton:UIButton!
    
    @IBOutlet var togglePackingStartDateButton:UIButton!
    @IBOutlet var togglePackingEndDateButton:UIButton!
    
    @IBOutlet var cuttingStartDateTextField: MDCOutlinedTextField!
    @IBOutlet var cuttingEndDateTextField: MDCOutlinedTextField!
    
    @IBOutlet var sewingStartDateTextField: MDCOutlinedTextField!
    @IBOutlet var sewingEndDateTextField: MDCOutlinedTextField!
    
    @IBOutlet var packingStartDateTextField: MDCOutlinedTextField!
    @IBOutlet var packingEndDateTextField: MDCOutlinedTextField!
    
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var calenderMonthHeaderView: UIView!
    @IBOutlet var calenderMHViewHConstraint: NSLayoutConstraint!
    @IBOutlet var calenderDaysHeaderView: UIStackView!
    @IBOutlet var calenderDHViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet var calenderView: JTACMonthView!
    @IBOutlet var calenderToggleNextButton:UIButton!
    @IBOutlet var calenderTogglePreviousButton:UIButton!
    @IBOutlet var calenderViewHConstraint: NSLayoutConstraint!

    let formatter = DateFormatter()
    
    let theDatePicker = UIDatePicker()
    let theToolbarForDatePicker = UIToolbar()
    weak var activeField: UITextField?{
        willSet{
            //self.theDatePicker.date = Date()
        }
    }
 
    var weekDayButtons:[UIButton] = []
    var sectionButtons:[UIButton] = []
    var holidayList:[String] = []
    var compensateWorkingList:[String] = []
    var cuttingHolidayList:[String] = []
    var cuttingCompensateWorkingList:[String] = []
    var sewingHolidayList:[String] = []
    var sewingCompensateWorkingList:[String] = []
    var packingHolidayList:[String] = []
    var packingCompensateWorkingList:[String] = []
    
    var orderId:String = "0"
    var orderInfoDelegate:OrderInfoDataUpdateDelegate?
    var currentMonthDate: String?
    
    var isCuttingSelected: Bool?
    var isSewingSelected: Bool?
    var isPackingSelected: Bool?

    var currentSection:Int = 1{
        didSet{
            self.updateSectionsUI()
            self.updateWeekdaysUI()
            self.reloadCalenderUIComponents()
        }
    }
    var sections:[ProductionSection] = [ProductionSection(productionType: Config.Text.cut, startDate: "", endDate:  "", data: []),
                                        ProductionSection(productionType: Config.Text.sew, startDate:  "", endDate: "", data: []),
                                        ProductionSection(productionType: Config.Text.pack, startDate: "", endDate: "", data: [])]
//    var isCuttingFeeded: Bool = false
//    var isSewingFeeded: Bool = false
    
    var totalQuantity: Int = 0
    var calendarData: [CalendarDatum] = []{
        didSet{
            print("calendarData", calendarData)
        }
    }
    var basicInfoData: Basic?
    
    var weekOffList: [WeekOffData] = []
    var getMaxProdcInputDate: String = ""
    var isEditProduction: Bool = false
    var selectedWeekOff: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        formatter.dateFormat = "yyyy-MM-dd"
        RestCloudService.shared.productionDelegate = self
        self.setupUI()
        self.getWeekOffData()
        self.getHolidayData()
        self.setupCalenderUI()
        self.setupPickerViewWithToolBar()
       
        if self.isEditProduction{
            self.getProductionData(section: 0)
        }
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.title = LocalizationManager.shared.localizedString(key: "productionInputText")
    }
    
    func setupUI() {
      
        self.sectionButtons = [cuttingButton,
                               sewingButton,
                               packingButton]
        self.weekDayButtons = [self.sundayButton,
                               self.mondayButton,
                               self.tuesdayButton,
                               self.wednesdayButton,
                               self.thursdayButton,
                               self.fridayButton,
                               self.saturdayButton]
        
        self.view.backgroundColor = .appBackgroundColor()
        self.contentView.backgroundColor = .clear
     
        self.sectionView.layer.shadowOpacity = 0.3
        self.sectionView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.sectionView.layer.shadowRadius = 3.0
        self.sectionView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.sectionView.layer.masksToBounds = false
       
        self.holidayView.roundCorners(corners: .allCorners, radius: 10.0)
        self.sectionView.roundCorners(corners: .allCorners, radius: 10.0)
        self.cuttingButton.roundCorners(corners: [.topLeft], radius: 10.0)
        self.packingButton.roundCorners(corners: [.topRight], radius: 10.0)
        self.dateView.roundCorners(corners: .allCorners, radius: 10.0)
        self.packingDateView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        
        workingDaysLabel.text = LocalizationManager.shared.localizedString(key: "workingDaysText")
        workingDaysLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        workingDaysLabel.textColor = .customBlackColor()
        workingDaysLabel.textAlignment = .left
        workingDaysLabel.numberOfLines = 1
        
        notesLabel.text = LocalizationManager.shared.localizedString(key: "notesText")
        notesLabel.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
        notesLabel.textColor = UIColor.init(rgb: 0xFF4B1D, alpha: 1.0)
        notesLabel.textAlignment = .left
        notesLabel.numberOfLines = 2
        notesLabel.adjustsFontSizeToFitWidth = true
        
        let weekDays = LocalizationManager.shared.localizedStrings(key: "weekDays")
        for i in 0..<self.weekDayButtons.count{
            self.weekDayButtons[i].tag = i + 1
            self.weekDayButtons[i].layer.cornerRadius = self.weekDayButtons[i].frame.height / 2.0
            self.weekDayButtons[i].setTitle(weekDays[i], for: .normal)
            self.weekDayButtons[i].titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
            self.weekDayButtons[i].addTarget(self, action: #selector(weekDaysButtonTapped(_:)), for: .touchUpInside)
        }
        
        self.updateWeekdaysUI()
        
        self.cuttingButton.tag = 1
        self.sewingButton.tag = 2
        self.packingButton.tag = 3
        self.sectionButtons.forEach { (button) in
            button.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
            button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
            button.isEnabled = false
            if button == self.cuttingButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "cuttingText"), for: .normal)
            }else if button == self.sewingButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "sewingText"), for: .normal)
            }else if button == self.packingButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "packingText"), for: .normal)
            }
        }
    
        [toggleCuttingStartDateButton, toggleCuttingEndDateButton, toggleSewingStartDateButton, toggleSewingEndDateButton, togglePackingStartDateButton, togglePackingEndDateButton].forEach { (button) in
            button?.setImage(Config.Images.shared.getImage(imageName:Config.Images.calenderIcon), for: .normal)
            button?.tintColor = UIColor.init(rgb: 0x727272)
            button?.backgroundColor = .clear
            button?.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
        }
        
        [cuttingStartDateTextField, cuttingEndDateTextField, sewingStartDateTextField, sewingEndDateTextField, packingStartDateTextField, packingEndDateTextField].forEach { (textField) in
            textField?.delegate = self
            textField?.textColor = .customBlackColor()
            textField?.textAlignment = .left
            textField?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
            textField?.inputAccessoryView = self.theToolbarForDatePicker
            textField?.inputView = self.theDatePicker
            
            if textField == cuttingStartDateTextField || textField == sewingStartDateTextField || textField == packingStartDateTextField{
                self.setup(cuttingStartDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
                self.setup(sewingStartDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
                self.setup(packingStartDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "startDateText"))
            }else if textField == cuttingEndDateTextField || textField == sewingEndDateTextField || textField == packingEndDateTextField{
                self.setup(cuttingEndDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
                self.setup(sewingEndDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
                self.setup(packingEndDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "endDateText"))
            }
        }
     
        self.enableTextField()
        
        self.saveButton.backgroundColor = .primaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
        
        print(self.sections, self.sections.count, self.currentSection)
        if isEditProduction{
//            self.cuttingStartDateTextField.text = self.basicInfoData?.cutStartDate
//            self.sewingStartDateTextField.text = self.basicInfoData?.sewStartDate
//            self.packingStartDateTextField.text = self.basicInfoData?.packStartDate
//
//            self.cuttingEndDateTextField.text = self.basicInfoData?.cutEndDate
//            self.sewingEndDateTextField.text = self.basicInfoData?.sewEndDate
//            self.packingEndDateTextField.text = self.basicInfoData?.packEndDate
        }
    }
    
    @objc func toggleButtonTapped(_ sender: UIButton) {
        if sender == toggleCuttingStartDateButton{
            self.cuttingStartDateTextField.becomeFirstResponder()
        }else if sender == toggleCuttingEndDateButton{
            self.cuttingEndDateTextField.becomeFirstResponder()
        }else if sender == toggleSewingStartDateButton{
            self.sewingStartDateTextField.becomeFirstResponder()
        }else if sender == toggleSewingEndDateButton{
            self.sewingEndDateTextField.becomeFirstResponder()
        }else if sender == togglePackingStartDateButton{
            self.packingStartDateTextField.becomeFirstResponder()
        }else if sender == togglePackingEndDateButton{
            self.packingEndDateTextField.becomeFirstResponder()
        }
    }
    
    func setupPickerViewWithToolBar() {
        theDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            theDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.theToolbarForDatePicker.sizeToFit()
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style:.plain, target: self, action: #selector(doneDateButtonTapped(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clearButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "cancelButtonText"), style: .plain, target: self, action: #selector(cancelDateButtonTapped(_:)))
        self.theToolbarForDatePicker.setItems([clearButton,spaceButton,doneButton], animated: false)
    }
    
    @objc func doneDateButtonTapped(_ sender: UIBarButtonItem) {
        formatter.dateFormat = "yyyy-MM-dd"
        activeField?.text = formatter.string(from: theDatePicker.date)
        if activeField == self.cuttingStartDateTextField || activeField == self.sewingStartDateTextField || activeField == self.packingStartDateTextField{
            self.sections[self.currentSection-1].startDate = formatter.string(from: theDatePicker.date)
        }else{
            self.sections[self.currentSection-1].endDate = formatter.string(from: theDatePicker.date)
        }
        theDatePicker.endEditing(true)
        self.view.endEditing(true)
        activeField = nil
    }
    
    @objc func cancelDateButtonTapped(_ sender: UIBarButtonItem) {
        activeField = nil
        theToolbarForDatePicker.endEditing(true)
        self.view.endEditing(true)
    }
    
    func setupCalenderUI() {
        self.calenderViewHConstraint.constant = UIDevice.isPad ? 500.0 : 300.0
        calenderView.ibCalendarDataSource = self
        calenderView.ibCalendarDelegate = self
        calenderView.minimumLineSpacing = 1.0
        calenderView.minimumInteritemSpacing = 1.0
        calenderView.backgroundColor = UIColor.init(rgb: 0xE6E6E6)
        calenderView.scrollDirection = .horizontal
        calenderView.scrollingMode = .stopAtEachCalendarFrame
        
        self.calenderTogglePreviousButton.tintColor = .lightGray
        self.calenderTogglePreviousButton.setImage(Config.Images.shared.getImage(imageName:Config.Images.leftArrowIcon), for: .normal)
        self.calenderTogglePreviousButton.addTarget(self, action: #selector(moveToPreviousSegment), for: .touchUpInside)
        self.calenderToggleNextButton.tintColor = .lightGray
        self.calenderToggleNextButton.setImage(Config.Images.shared.getImage(imageName:Config.Images.rightArrowIcon), for: .normal)
        self.calenderToggleNextButton.addTarget(self, action: #selector(moveToNextSegment), for: .touchUpInside)
    }
     
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calenderView.visibleDates()
        calenderView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
   
    func enableTextField(){
        if currentSection == 1{
            cuttingStartDateTextField.isUserInteractionEnabled = true
            cuttingStartDateTextField.isEnabled = true
            cuttingStartDateTextField.alpha = 1.0
            cuttingStartDateTextField.backgroundColor = .white
            
            cuttingEndDateTextField.isUserInteractionEnabled = true
            cuttingEndDateTextField.isEnabled = true
            cuttingEndDateTextField.alpha = 1.0
            cuttingEndDateTextField.backgroundColor = .white
            
            sewingStartDateTextField.isUserInteractionEnabled = false
            sewingStartDateTextField.isEnabled = false
            sewingStartDateTextField.alpha = 0.5
            sewingStartDateTextField.backgroundColor = .appLightColor()
            
            sewingEndDateTextField.isUserInteractionEnabled = false
            sewingEndDateTextField.isEnabled = false
            sewingEndDateTextField.alpha = 0.5
            sewingEndDateTextField.backgroundColor = .appLightColor()
            
            packingStartDateTextField.isUserInteractionEnabled = false
            packingStartDateTextField.isEnabled = false
            packingStartDateTextField.alpha = 0.5
            packingStartDateTextField.backgroundColor = .appLightColor()
            
            packingEndDateTextField.isUserInteractionEnabled = false
            packingEndDateTextField.isEnabled = false
            packingEndDateTextField.alpha = 0.5
            packingEndDateTextField.backgroundColor = .appLightColor()
        }else if currentSection == 2{
            cuttingStartDateTextField.isUserInteractionEnabled = false
            cuttingStartDateTextField.isEnabled = false
            cuttingStartDateTextField.alpha = 0.5
            cuttingStartDateTextField.backgroundColor = .appLightColor()
            
            cuttingEndDateTextField.isUserInteractionEnabled = false
            cuttingEndDateTextField.isEnabled = false
            cuttingEndDateTextField.alpha = 0.5
            cuttingEndDateTextField.backgroundColor = .appLightColor()
           
            sewingStartDateTextField.isUserInteractionEnabled = true
            sewingStartDateTextField.isEnabled = true
            sewingStartDateTextField.alpha = 1.0
            sewingStartDateTextField.backgroundColor = .white
            
            sewingEndDateTextField.isUserInteractionEnabled = true
            sewingEndDateTextField.isEnabled = true
            sewingEndDateTextField.alpha = 1.0
            sewingEndDateTextField.backgroundColor = .white
            
            packingStartDateTextField.isUserInteractionEnabled = false
            packingStartDateTextField.isEnabled = false
            packingStartDateTextField.alpha = 0.5
            packingStartDateTextField.backgroundColor = .appLightColor()
            
            packingEndDateTextField.isUserInteractionEnabled = false
            packingEndDateTextField.isEnabled = false
            packingEndDateTextField.alpha = 0.5
            packingEndDateTextField.backgroundColor = .appLightColor()
        }else if currentSection == 3{
            cuttingStartDateTextField.isUserInteractionEnabled = false
            cuttingStartDateTextField.isEnabled = false
            cuttingStartDateTextField.alpha = 0.5
            cuttingStartDateTextField.backgroundColor = .appLightColor()
            
            cuttingEndDateTextField.isUserInteractionEnabled = false
            cuttingEndDateTextField.isEnabled = false
            cuttingEndDateTextField.alpha = 0.5
            cuttingEndDateTextField.backgroundColor = .appLightColor()
            
            sewingStartDateTextField.isUserInteractionEnabled = false
            sewingStartDateTextField.isEnabled = false
            sewingStartDateTextField.alpha = 0.5
            sewingStartDateTextField.backgroundColor = .appLightColor()
            
            sewingEndDateTextField.isUserInteractionEnabled = false
            sewingEndDateTextField.isEnabled = false
            sewingEndDateTextField.alpha = 0.5
            sewingEndDateTextField.backgroundColor = .appLightColor()
            
            packingStartDateTextField.isUserInteractionEnabled = true
            packingStartDateTextField.isEnabled = true
            packingStartDateTextField.alpha = 1.0
            packingStartDateTextField.backgroundColor = .white
            
            packingEndDateTextField.isUserInteractionEnabled = true
            packingEndDateTextField.isEnabled = true
            packingEndDateTextField.alpha = 1.0
            packingEndDateTextField.backgroundColor = .white
        }
        
    }
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        print(currentSection)
        self.currentSection = sender.tag

        if isEditProduction { //}&& self.sections[currentSection-1].data.count>0{
            self.getProductionData(section: self.currentSection-1)
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        
        guard self.currentSection-1 < self.sections.count else {
            return
        }
        
        if self.sections[self.currentSection-1].startDate.isEmptyOrWhitespace(){
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "errorTitle"),
                                        message: LocalizationManager.shared.localizedString(key: "startDateErrorText")
                                        ,target: self)
            return
        }else if self.sections[self.currentSection-1].endDate.isEmptyOrWhitespace(){
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "errorTitle"),
                                        message: LocalizationManager.shared.localizedString(key: "endDateErrorText")
                                        ,target: self)
            return
        }
        
        self.setProductionData(updateToDB: true)
    }
    
    @objc func weekDaysButtonTapped(_ sender: UIButton) {
        // Update Model
        
        if self.sections[currentSection-1].productionType != Config.Text.cut{
            return
        }
        
        if self.sections[currentSection-1].startDate == "" && self.sections[currentSection-1].endDate == ""{
            return
        }
        
        if self.currentSection-1 < self.sections.count{
            
            let index = self.sections[self.currentSection-1].weekoffs.indices.first { (index) in
                return self.sections[self.currentSection-1].weekoffs[index] == sender.tag
            }
            
            if let i = index{
                self.sections[self.currentSection-1].weekoffs.remove(at: i)
                self.updateHolidayFlagForWeekoff(weekDay: sender.tag, makeWeekdayAsHoliday: false)
            }else{
                self.sections[self.currentSection-1].weekoffs.append(sender.tag)
                self.updateHolidayFlagForWeekoff(weekDay: sender.tag, makeWeekdayAsHoliday: true)
            }
            self.selectedWeekOff = sender.tag - 1
            print(sender.tag)
            self.createWeekOff(weekOff: sender.tag)
        
        }
    }
    
    func updateWeekdaysUI() {
        if self.currentSection-1 < self.sections.count{
            for i in 0..<self.weekDayButtons.count{
                if self.sections[self.currentSection-1].weekoffs.contains(self.weekDayButtons[i].tag) {
                    self.weekDayButtons[i].setTitleColor(.customBlackColor(), for: .normal)
                    self.weekDayButtons[i].backgroundColor = UIColor.init(rgb: 0xE6E6E6)
                }else{
                    self.weekDayButtons[i].setTitleColor(.white, for: .normal)
                    self.weekDayButtons[i].backgroundColor = .primaryColor()
                }
            }
        }
    }

    func updateHolidayFlagForWeekoff(weekDay:Int, makeWeekdayAsHoliday:Bool) {
        
        let startDate:Date? = formatter.date(from: self.sections[self.currentSection-1].startDate)
        let endDate:Date? = formatter.date(from: self.sections[self.currentSection-1].endDate)
        
        if let sDate = startDate, let eDate = endDate{
            let dates = self.datesRange(from: sDate, to: eDate)
            let allSpecificDayDates = self.getAllSpecificDayDates(day: weekDay, from: dates)
            
            for index in self.sections[self.currentSection-1].data.indices{
                if allSpecificDayDates.contains(self.sections[self.currentSection-1].data[index].dateOfProduction ?? ""){
                    self.sections[self.currentSection-1].data[index].holidayFlag = makeWeekdayAsHoliday ? "1" : "0"
                }
            }
        }
    }
  
    func estimatedHeightOfLabel(text: String) -> CGFloat {

        let size = CGSize(width: view.frame.width - 20, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }
    
    func updateHolidayFlagForSingleDate(date:Date) {
    
        formatter.dateFormat = "yyyy-MM-dd"
        var isHoliday: Bool = false
        
        for index in self.sections[self.currentSection-1].data.indices{
            if self.sections[self.currentSection-1].data[index].dateOfProduction ?? "" == self.formatter.string(from: date){
                var message: String = ""
                if self.sections[self.currentSection-1].data[index].holidayFlag == "1"{
                    message =  LocalizationManager.shared.localizedString(key: "assignWorkingdayText")
                }else{
                    isHoliday = true
                    message =  LocalizationManager.shared.localizedString(key: "assignHolidayText")
                }
                
                UIAlertController.showAlert(message: message,
                                            firstButtonTitle: LocalizationManager.shared.localizedString(key: "noButtonText"),
                                            secondButtonTitle: LocalizationManager.shared.localizedString(key: "yesButtonText"),
                                            target: self) { (status) in
                    print(status)
                    if status{
                        self.sections[self.currentSection-1].data[index].holidayFlag = (self.sections[self.currentSection-1].data[index].holidayFlag) == "0" ? "1" : "0"
                        self.sections[self.currentSection-1].data[index].holidayDetail = (self.sections[self.currentSection-1].data[index].holidayDetail) == "" ? "Holiday" : ""
                       
                        if isHoliday{
                            self.createHoliday(startDate: self.formatter.string(from: date), endDate: self.formatter.string(from: date))
                        }else{
                            self.deleteHoliday(id: self.sections[self.currentSection-1].data[index].holidayId ?? "0")
                        }
                
                    }
                }
         
            }
        }
    }
    
    func reloadHoliday(){
        self.getHolidayList()
        self.updateQuantity()
        self.reloadCalenderUIComponents()
    }
    
    func getInitialHolidaysList() -> [String] {
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate:Date? = formatter.date(from: self.sections[self.currentSection-1].startDate)
        let endDate:Date? = formatter.date(from: self.sections[self.currentSection-1].endDate)
        var holidayList:[String] = []
        if let sDate = startDate, let eDate = endDate{
            let dates = self.datesRange(from: sDate, to: eDate)
            for wkday in self.sections[self.currentSection-1].weekoffs{
                let allSpecificDayDates = self.getAllSpecificDayDates(day: wkday, from: dates)
                holidayList.append(contentsOf: allSpecificDayDates)
            }
        }
        for lists in self.holidayList{
            if !holidayList.contains(lists){
                holidayList.append(lists)
            }
        }
        return holidayList
    }
    
    func getHolidaysListFromModel() -> [String] {
        var holidayList = [String]()
        for model in self.sections[self.currentSection-1].data{
            if model.holidayFlag == "1", let date = model.dateOfProduction{
                holidayList.append(date)
            }
        }
        return holidayList
    }
   
    func getHolidayList() {
        self.holidayList = [String]()
        for model in self.sections[self.currentSection-1].data {
          if model.holidayFlag == "1", let date = model.dateOfProduction{
                self.holidayList.append(date)
            }
        }
        
        print(self.holidayList)
    }
 
    func getWeekNUmber(date: String) -> Int {
        let day = self.getFormattedDate(strDate: date, currentFomat: "yyyy-MM-dd", expectedFromat: "EEEE")
        print(day)
        switch day {
        case "Sunday":
            return 1
        case "Monday":
            return 2
        case "Tuesday":
            return 3
        case "Wednesday":
            return 4
        case "Thursday":
            return 5
        case "Friday":
            return 6
        case "Saturday":
            return 7
        default:
            return 0
        }
    }
 
    // Get specific day dates
    func getAllSpecificDayDates(day:Int,from dates:[Date]) -> [String] {
        formatter.dateFormat = "yyyy-MM-dd"
        var result:[String] = []
        for date in dates{
            let wkday = Calendar.current.component(.weekday, from: date)
            if day == wkday{
                result.append(formatter.string(from: date))
            }
        }
        return result
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    func getCalenderModelForDate(date:String) -> CalendarDatum? {
        let index = self.sections[self.currentSection-1].data.indices.first { (index) in
            return self.sections[self.currentSection-1].data[index].dateOfProduction == date
        }
        
        if let i = index{
            return self.sections[self.currentSection-1].data[i]
        }
        
        return nil
    }
    
    func getTargetValueForDate(date:String) ->String {
        
        let index = self.sections[self.currentSection-1].data.indices.first { (index) in
            return self.sections[self.currentSection-1].data[index].dateOfProduction == date
        }
        
        if let i = index{
            return self.sections[self.currentSection-1].data[i].targetValue ?? "0"
        }
        
        return "0"
    }

    // After submit section data
    func updateSection(){
    
        self.cuttingStartDateTextField.text = self.sections[0].startDate
        self.cuttingEndDateTextField.text = self.sections[0].endDate
        self.sewingStartDateTextField.text = self.sections[1].startDate
        self.sewingEndDateTextField.text = self.sections[1].endDate
        self.packingStartDateTextField.text = self.sections[2].startDate
        self.packingEndDateTextField.text = self.sections[2].endDate
      
        self.calenderToggleNextButton.tintColor = .lightGray
        self.calenderTogglePreviousButton.tintColor = .lightGray
        
        self.mapWeekOff()
        self.enableTextField()
        self.sections[currentSection-1].data = []
        self.calenderView.reloadData()
        
    }
   
    func updateSectionsUI() {
        self.sectionButtons.forEach { (button) in
            print(currentSection, button.tag)

            button.backgroundColor = (button.tag == self.currentSection) ? .primaryColor() : .white
            button.setTitleColor((button.tag == self.currentSection) ? .white : .primaryColor(), for: .normal)
        
            if button == cuttingButton{
                button.isEnabled = true
            }else if button == sewingButton{
                button.isEnabled = self.sections[0].data.count > 0 ? true : false
                if button.tag == self.currentSection{
                    button.setTitleColor(.white, for: .normal)
                }else if self.sections[0].data.count > 0{
                    button.setTitleColor(.primaryColor(), for: .normal)
                }else{
                    button.setTitleColor(.primaryColor(withAlpha: 0.5), for: .normal)
                }
            }else if button == packingButton{
                button.isEnabled = self.sections[1].data.count > 0 ? true : false
                if button.tag == self.currentSection{
                    button.setTitleColor(.white, for: .normal)
                }else if self.sections[1].data.count > 0 || self.packingStartDateTextField.text?.isEmptyOrWhitespace() == false {
                    button.setTitleColor(.primaryColor(), for: .normal)
                }else{
                    button.setTitleColor(.primaryColor(withAlpha: 0.5), for: .normal)
                }
            }
        }
    }

    func updateNextPreviousButton() {
        var startDateMonth: [Int] = []
        var endDateMonth: [Int] = []
        var currentDateMonth: [Int] = []
        
        if self.sections[currentSection-1].startDate != "" && self.sections[currentSection-1].endDate != ""{
            startDateMonth = self.getMonth(dateString: self.sections[currentSection-1].startDate, formatter: "yyyy-MM-dd")
            endDateMonth = self.getMonth(dateString: self.sections[currentSection-1].endDate, formatter: "yyyy-MM-dd")
            currentDateMonth = self.getMonth(dateString: self.currentMonthDate ?? "", formatter: "yyyy-MM-dd HH:mm:ss Z")
            print(startDateMonth, endDateMonth, currentDateMonth)
            
            if startDateMonth.count>0 && endDateMonth.count>0 {
                if startDateMonth[0] == endDateMonth[0] && startDateMonth[1] == endDateMonth[1]{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor(withAlpha: 0.2)
                    self.calenderToggleNextButton.tintColor = .customBlackColor(withAlpha: 0.2)
                }else{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor()
                    self.calenderToggleNextButton.tintColor = .customBlackColor()
                }
                
                if startDateMonth[0] <= currentDateMonth[0] && startDateMonth[1] < currentDateMonth[1]{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor()
                }else{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor(withAlpha: 0.2)
                }
                
                if endDateMonth[0] >= currentDateMonth[0] && endDateMonth[1] > currentDateMonth[1]{
                    self.calenderToggleNextButton.tintColor = .customBlackColor()
                }else{
                    self.calenderToggleNextButton.tintColor = .customBlackColor(withAlpha: 0.2)
                }
            }
        }
    }
    
    func reloadCalenderUIComponents() {
        formatter.dateFormat = "yyyy-MM-dd"
        if self.currentSection-1 < self.sections.count{
            if self.sections[self.currentSection-1].startDate.isEmptyOrWhitespace() || self.sections[self.currentSection-1].endDate.isEmptyOrWhitespace(){
                return
            }
            
            if let sDate = self.formatter.date(from: self.sections[self.currentSection-1].startDate), let eDate = self.formatter.date(from: self.sections[self.currentSection-1].endDate){
                if sDate.compare(eDate) == .orderedDescending{
                    return
                }else{
                    self.showCalenderViews()
                    self.calenderView.reloadData()
                    self.calenderView.scrollToSegment(.start)
                }
            }
        }
    }
    
    @objc func moveToNextSegment() {
        self.calenderView.scrollToSegment(.next)
    }
    
    @objc func moveToPreviousSegment() {
        self.calenderView.scrollToSegment(.previous)
    }
    
    func showCalenderViews() {
        self.calenderMonthHeaderView.isHidden = false
        self.calenderDaysHeaderView.isHidden = false
        self.calenderMHViewHConstraint.constant = 35.0
        self.calenderDHViewHConstraint.constant = 35.0
        self.calenderView.isHidden = false
    }
    
    func hideCalenderViews() {
        self.calenderMonthHeaderView.isHidden = true
        self.calenderDaysHeaderView.isHidden = true
        self.calenderMHViewHConstraint.constant = 0.0
        self.calenderDHViewHConstraint.constant = 0.0
        self.calenderView.isHidden = true
    }
    
    func getProductionData(section: Int) {
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "type_of_production": self.sections[section].productionType ]
        print(params)
       RestCloudService.shared.getOrderProduction(params: params)
 
    }
   
    func getHolidayData() {
    
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
       RestCloudService.shared.getHolidays(params: params)
    }
    
    func getWeekOffData() {
    
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
       RestCloudService.shared.getWeekOffs(params: params)
    }
    
    func createHoliday(startDate: String, endDate: String) {
    
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "holiday_start_date": startDate,
                                    "holiday_end_date": endDate,
                                    "name": "Holiday",
                                    "description": "Holiday"]
        print(params)
       RestCloudService.shared.createHolidays(params: params)
    }
    
    func deleteHoliday(id: String) {
    
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "id": id]
        print(params)
       RestCloudService.shared.deleteHolidays(params: params)
    }
    
    func createWeekOff(weekOff: Int) {
    
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "days" : weekOff-1]
        print(params)
       RestCloudService.shared.createWeekOffs(params: params)
    }
    
   // /api/delete-holiday
    func bindProductionData(data: [CalendarDatum]){
        
  //      if data.count>0{
            self.sections[self.currentSection-1].startDate = data[0].dateOfProduction ?? ""
            self.sections[self.currentSection-1].endDate = data[data.count-1].dateOfProduction ?? ""
            self.sections[self.currentSection-1].data = data

            if self.sections[currentSection-1].productionType == Config.Text.cut{
                self.cuttingStartDateTextField.text = self.sections[currentSection-1].data[0].dateOfProduction
                self.cuttingEndDateTextField.text = self.sections[currentSection-1].data.last?.dateOfProduction
            }else if self.sections[currentSection-1].productionType == Config.Text.sew{
                self.sewingStartDateTextField.text = self.sections[currentSection-1].data[0].dateOfProduction
                self.sewingEndDateTextField.text = self.sections[currentSection-1].data.last?.dateOfProduction
            }else if self.sections[currentSection-1].productionType == Config.Text.pack{
                self.packingStartDateTextField.text = self.sections[currentSection-1].data[0].dateOfProduction
                self.packingEndDateTextField.text = self.sections[currentSection-1].data.last?.dateOfProduction
            }
            self.enableTextField()
            self.updateWeekdaysUI()
            self.updateSectionsUI()
            self.makeProductionData()
//        }else{
//
//        }
    }
  
    func mapWeekOff() {
        for weekOff in self.weekOffList {
            self.sections[0].weekoffs.append(weekOff.day+1)
            self.sections[1].weekoffs.append(weekOff.day+1)
            self.sections[2].weekoffs.append(weekOff.day+1)
        }
        self.updateWeekdaysUI()
    }
    
    func makeProductionData(isWeekOff: Bool = false){
      
        let allDates = DateTime.dates(from: DateTime.stringToDate(dateString: self.sections[self.currentSection-1].startDate, dateFormat: Date.simpleDateFormat) ?? Date(),
                                      to: DateTime.stringToDate(dateString: self.sections[self.currentSection-1].endDate, dateFormat: Date.simpleDateFormat) ?? Date())
        print(allDates, currentSection)
        
        if allDates.count == 0{
          return
        }

        let perDayQuantity: Int = Int(self.totalQuantity)/allDates.count

        self.calendarData = []
 
        if !isEditProduction || isWeekOff {
            
            for date in allDates{
                let myDate = DateTime.convertDateFormater("\(date)", currentFormat: Date.inspectionDateFormat, newFormat: Date.simpleDateFormat)
                let week = self.getWeekNUmber(date: myDate)
                print(sections[currentSection-1].weekoffs, myDate, week)
                
                if sections[currentSection-1].weekoffs.contains(week){
                    calendarData.append(CalendarDatum.init(dateOfProduction: myDate, targetValue: "\(perDayQuantity)", holidayFlag: "1", holidayDetail: "WeekOff"))
                }else{
                    calendarData.append(CalendarDatum.init(dateOfProduction: myDate, targetValue: "\(perDayQuantity)", holidayFlag: "0", holidayDetail: ""))
                }
            }
            self.sections[currentSection-1].data = calendarData
        }
        
        if self.currentSection == 1{
            self.sections[currentSection-1].productionType = Config.Text.cut
        }else if self.currentSection == 2{
            self.sections[currentSection-1].productionType = Config.Text.sew
        }else{
            self.sections[currentSection-1].productionType = Config.Text.pack
        }
  
        self.updateHoliday()
        self.getHolidayList()
        self.updateQuantity()
        self.reloadCalenderUIComponents()
    }
   
    func updateQuantity(){
        if self.sections[currentSection-1].data.count>0{
            let workingDays = self.sections[currentSection-1].data.count - (self.holidayList.count)
            print(self.sections[currentSection-1].data.count, self.totalQuantity, self.holidayList.count)
            var perDayQuantity: Int = 0
            var diffQuantity: Int = 0
            if workingDays>0{
                perDayQuantity =  self.totalQuantity/workingDays
            }
          
            diffQuantity = totalQuantity - (perDayQuantity * workingDays)
            print(diffQuantity)
            
            if perDayQuantity * workingDays > totalQuantity {
                for (index, model) in self.sections[self.currentSection-1].data.enumerated() {
                    if model.holidayFlag == "0"{
                        if diffQuantity > 0{
                            self.sections[self.currentSection-1].data[index].targetValue = "\(perDayQuantity - 1)"
                            diffQuantity += 1
                        }else{
                            self.sections[self.currentSection-1].data[index].targetValue = "\(perDayQuantity)"
                        }
                    }
                }
            }else if perDayQuantity * workingDays < totalQuantity {
                for (index, model) in self.sections[self.currentSection-1].data.enumerated() {
                    if model.holidayFlag == "0"{
                        if diffQuantity > 0{
                            self.sections[self.currentSection-1].data[index].targetValue = "\(perDayQuantity + 1)"
                            diffQuantity -= 1
                        }else{
                            self.sections[self.currentSection-1].data[index].targetValue = "\(perDayQuantity)"
                        }
                    }
                }
            }else{
                self.sections[currentSection-1].data.forEach{ $0.targetValue = "\(perDayQuantity)" }
            }
        }
    }
  
    
    func updateHoliday(){
        
        self.sections[currentSection-1].data.enumerated().forEach { index, value in
            
            print("holidayId-Date", self.sections[currentSection-1].data[index].dateOfProduction, self.sections[currentSection-1].data[index].holidayId)

            for holiday in self.sections[currentSection-1].holidays{
                
                self.sections[currentSection-1].data[index].holidayId = holiday.id ?? ""
                
                if let holidays = holiday.days{
                    print(holidays)
                    
                    var date: String = holiday.holidayStartDate ?? ""
                    print("holidayDate", date)
                    var count: Int = 0
                    let newDate: String = date // If having continuous holidays
                    for _ in 0..<holidays{
                        
                        print(value.dateOfProduction, date)
                        
                        let prodDate = DateTime.stringToDate(dateString: value.dateOfProduction ?? "", dateFormat: Date.simpleDateFormat)
                        let checkDate = DateTime.stringToDate(dateString: date, dateFormat: Date.simpleDateFormat)
                        
                        if let pDate = prodDate, let cDate = checkDate, pDate >= cDate || newDate != date{
                            if value.dateOfProduction == date || pDate < cDate{
                                if index+count<self.sections[currentSection-1].data.count{
                                    self.sections[currentSection-1].data[index+count].holidayFlag = "1"
                                    self.sections[currentSection-1].data[index+count].holidayDetail = holiday.name
                                    date = date.convertToNextDate(dateFormat: Date.simpleDateFormat)
                                    count += 1
                                    print("NextDate", date)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setProductionData(updateToDB: Bool) {
        
        guard self.currentSection-1 < self.sections.count else {
            return
        }
        
        if self.sections[self.currentSection-1].startDate.isEmptyOrWhitespace() || self.sections[self.currentSection-1].endDate.isEmptyOrWhitespace(){
            return
        }
        
        var prodDatas:[[String:Any]] = []
        
        for section in self.sections{
            var prodData:[String:Any] = [:]
            prodData["type_of_production"] = section.productionType
            prodData["start_date"] = section.startDate
            prodData["end_date"] = section.endDate
            
            var sectionData:[[String:Any]] = []
            for prodData in section.data{
                var secData:[String:Any] = [:]
                secData["date_of_production"] = prodData.dateOfProduction
                secData["target_value"] = prodData.targetValue
                secData["holiday_flag"] = prodData.holidayFlag
                secData["holiday_detail"] = prodData.holidayDetail
                
                sectionData.append(secData)
            }
            prodData["prod_data"] = sectionData
            
            if self.currentSection == 1{
                if section.productionType == Config.Text.cut{
                    prodDatas.append(prodData)
                }
            }else if self.currentSection == 2{
                if section.productionType == Config.Text.sew{
                    prodDatas.append(prodData)
                }
            }else if self.currentSection == 3{
                if section.productionType == Config.Text.pack{
                    prodDatas.append(prodData)
                }
            }
        }
        
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "prod_datas": prodDatas
        ]
        print(params)
        RestCloudService.shared.setOrderProduction(params: params)
    }
    
    func getLocaleMonthAndYear(date:Date) -> String {
        formatter.locale = Locale(identifier: LocalizationManager.shared.localizedString(key: "localeIdentifier"))
        formatter.dateFormat = "MMMM YYYY"
        let monthAndYear = formatter.string(from: date)
        return monthAndYear
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        self.orderInfoDelegate?.updateOrderInfoData(.production, orderInfoData: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddProductionVC: JTACMonthViewDataSource, JTACMonthViewDelegate {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy-MM-dd"
        var startDate:Date = Date()
        var endDate:Date = Date()
        
        if self.currentSection-1 < self.sections.count{
            if let date = formatter.date(from: self.sections[self.currentSection-1].startDate){
                startDate = date
            }
            if let date = formatter.date(from: self.sections[self.currentSection-1].endDate){
                endDate = date
            }
        }
        print(startDate, endDate)
        
        self.monthLabel.text = self.getLocaleMonthAndYear(date: startDate)
        self.currentMonthDate = "\(startDate)"
        self.updateNextPreviousButton()
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 6,
                                       calendar: .current,
                                       generateInDates: InDateCellGeneration.forAllMonths,
                                       generateOutDates: OutDateCellGeneration.tillEndOfRow,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: true)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dayCell", for: indexPath) as! CalenderDayCell
        cell.dateLabel.text = cellState.text
        
        // Hide other month cells, current month cell date text color
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Check the date within start & end date range and update UI
        if let calenderDataModel = self.getCalenderModelForDate(date: formatter.string(from: date)){
            cell.backgroundColor = .white
            cell.isUserInteractionEnabled = true
           
            cell.countLabel.isHidden = false
            cell.countLabel.backgroundColor = .lightGray
            
            // Update target value for visible dates
            cell.countLabel.text = calenderDataModel.targetValue ?? "0"
            
            // Update date UI for holidays
            if self.currentSection-1 < self.sections.count{
                // Update holiday text color
                if calenderDataModel.holidayFlag == "1"{
                    cell.dateLabel.textColor = .customBlackColor()
                    cell.countLabel.textColor = .red
                    cell.countLabel.text = calenderDataModel.holidayDetail
                    if calenderDataModel.holidayDetail == "WeekOff"{
                        cell.isUserInteractionEnabled = false
                        cell.countLabel.backgroundColor = .appLightColor()
                    }else{
                        cell.countLabel.backgroundColor = .primaryColor(withAlpha: 0.5)
                    }
                }else{
                    cell.countLabel.textColor = .white
                    cell.countLabel.backgroundColor = .lightGray
                    cell.dateLabel.textColor = .customBlackColor()
                }
            }
        }else{
            // Out of start & end date range UI updates
            cell.dateLabel.textColor = .customBlackColor()
            cell.countLabel.isHidden = true
            cell.backgroundColor = .lightText
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print(date as Any)
        self.updateHolidayFlagForSingleDate(date: date)
    }
    
    func calendarDidScroll(_ calendar: JTACMonthView) {
    }
    
    func scrollDidEndDecelerating(for calendar: JTACMonthView) {
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if let hasDate = visibleDates.monthDates.first?.date{
            self.monthLabel.text = self.getLocaleMonthAndYear(date: hasDate)
            self.currentMonthDate = "\(hasDate)"
            self.updateNextPreviousButton()
        }
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // Not calling
    }
}

extension AddProductionVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        
        if self.currentSection-1 < self.sections.count{
    
            formatter.dateFormat = "yyyy-MM-dd"
            
            let cuttingStartDate = self.sameDate(date: self.formatter.date(from: self.cuttingStartDateTextField.text ?? "") ?? Date())
            let cuttingEndDate = self.sameDate(date: self.formatter.date(from: self.cuttingEndDateTextField.text ?? "") ?? Date())
            let sewingStartDate = self.sameDate(date: self.formatter.date(from: self.sewingStartDateTextField.text ?? "") ?? Date())
            let sewingEndDate = self.sameDate(date: self.formatter.date(from: self.sewingEndDateTextField.text ?? "") ?? Date())
            let packingStartDate = self.sameDate(date: self.formatter.date(from: self.packingStartDateTextField.text ?? "") ?? Date())
            var maxProdInputtededDate:Date?
            
            if self.getMaxProdcInputDate != ""{
                maxProdInputtededDate =  startDate(startDate: self.getMaxProdcInputDate, formatter: "yyyy-MM-dd")
            }else{
                maxProdInputtededDate = nil
            }
            
            if self.sections[self.currentSection-1].productionType == Config.Text.cut{
                
                let cuttingPreviousDate = self.previousDate(date: self.formatter.date(from: self.cuttingEndDateTextField.text ?? "") ?? Date())
                
                self.theDatePicker.date =  startDate(startDate: textField.text ?? "", formatter: "yyyy-MM-dd" )
                    if textField == cuttingStartDateTextField {
                        self.theDatePicker.minimumDate = Date() //nil
                        if cuttingEndDateTextField.text == "" {
                            self.theDatePicker.maximumDate = nil
                        }else{
                            self.theDatePicker.maximumDate = cuttingPreviousDate
                        }
                    }else{
                        if cuttingStartDateTextField.text == "" {
                            self.theDatePicker.minimumDate = nil
                        }else{
                            if maxProdInputtededDate == nil{
                                self.theDatePicker.minimumDate = cuttingStartDate
                            }else{
                                if cuttingStartDate > maxProdInputtededDate ?? Date(){
                                    self.theDatePicker.minimumDate = cuttingStartDate
                                }else{
                                    self.theDatePicker.minimumDate = maxProdInputtededDate
                                }
                            }
                        }
                        self.theDatePicker.maximumDate = nil
                    }

            }else if self.sections[self.currentSection-1].productionType == Config.Text.sew{
            
                let sewingPreviousDate = self.previousDate(date: self.formatter.date(from: self.sewingEndDateTextField.text ?? "") ?? Date())
                self.theDatePicker.date =  startDate(startDate: textField.text ?? "", formatter: "yyyy-MM-dd" )
             
                    if textField == sewingStartDateTextField {
                        self.theDatePicker.minimumDate = cuttingStartDate
                        if sewingEndDateTextField.text == "" {
                            self.theDatePicker.maximumDate = nil
                        }else{
                            self.theDatePicker.maximumDate = sewingPreviousDate
                        }
                    }else{
                        if sewingStartDateTextField.text == "" {
                            self.theDatePicker.minimumDate = cuttingStartDate
                        }else{
                            
                            if maxProdInputtededDate == nil{
                                if cuttingEndDate > sewingStartDate {
                                     self.theDatePicker.minimumDate = cuttingEndDate
                                 }else  {
                                     self.theDatePicker.minimumDate = sewingStartDate
                                 }
                            }else{
                                if cuttingEndDate > sewingStartDate && cuttingEndDate > maxProdInputtededDate ?? Date() {
                                    self.theDatePicker.minimumDate = cuttingEndDate
                                }else if sewingStartDate > cuttingEndDate && sewingStartDate > maxProdInputtededDate ?? Date() {
                                    self.theDatePicker.minimumDate = sewingStartDate
                                }else if maxProdInputtededDate ?? Date() > cuttingEndDate && maxProdInputtededDate ?? Date() > sewingStartDate  {
                                    self.theDatePicker.minimumDate = maxProdInputtededDate
                                }
                            }
                        }
                        self.theDatePicker.maximumDate = nil
                    }
           
            }else  if self.sections[self.currentSection-1].productionType == Config.Text.pack{
            
                let packingPreviousDate = self.previousDate(date: self.formatter.date(from: self.packingEndDateTextField.text ?? "") ?? Date())
                self.theDatePicker.date =  startDate(startDate: textField.text ?? "", formatter: "yyyy-MM-dd" )
             
                    if textField == packingStartDateTextField {
                        self.theDatePicker.minimumDate = sewingStartDate
                        if packingEndDateTextField.text == "" {
                            self.theDatePicker.maximumDate = nil
                        }else{
                            self.theDatePicker.maximumDate = packingPreviousDate
                        }
                    }else{
                        if packingStartDateTextField.text == "" {
                            self.theDatePicker.minimumDate = sewingStartDate
                        }else{
                            
                            if maxProdInputtededDate == nil{
                                if sewingEndDate > packingStartDate {
                                      self.theDatePicker.minimumDate = sewingEndDate
                                  }else  {
                                      self.theDatePicker.minimumDate = packingStartDate
                                  }
                            }else{
                                if sewingEndDate > packingStartDate && sewingEndDate > maxProdInputtededDate ?? Date() {
                                    self.theDatePicker.minimumDate = sewingEndDate
                                }else if packingStartDate > sewingEndDate && packingStartDate > maxProdInputtededDate ?? Date(){
                                    self.theDatePicker.minimumDate = packingStartDate
                                }else if maxProdInputtededDate ?? Date() > sewingEndDate && maxProdInputtededDate ?? Date() > packingStartDate {
                                    self.theDatePicker.minimumDate = maxProdInputtededDate
                                }
                            }
                        }
                        self.theDatePicker.maximumDate = nil
                    }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        formatter.dateFormat = "yyyy-MM-dd"
        if self.currentSection-1 < self.sections.count{
            if currentSection == 1{
                if let date = formatter.date(from: self.sections[self.currentSection-1].startDate){
                    cuttingStartDateTextField.text = formatter.string(from: date)
                }
                if let date = formatter.date(from: self.sections[self.currentSection-1].endDate){
                    cuttingEndDateTextField.text = formatter.string(from: date)
                }
            }else if currentSection == 2{
                if let date = formatter.date(from: self.sections[self.currentSection-1].startDate){
                    sewingStartDateTextField.text = formatter.string(from: date)
                }
                if let date = formatter.date(from: self.sections[self.currentSection-1].endDate){
                    sewingEndDateTextField.text = formatter.string(from: date)
                }
            }else if currentSection == 3{
                if let date = formatter.date(from: self.sections[self.currentSection-1].startDate){
                    packingStartDateTextField.text = formatter.string(from: date)
                }
                if let date = formatter.date(from: self.sections[self.currentSection-1].endDate){
                    packingEndDateTextField.text = formatter.string(from: date)
                }
            }
        }
        self.makeProductionData()
        self.updateNextPreviousButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

struct ProductionSection {
    var productionType: String
    var startDate: String
    var endDate: String
//    var cuttingStartDate, sewingStartDate, packingStartDate: String
//    var cuttingEndDate, sewingEndDate, packingEndDate: String
    
    var weekoffs:[Int] = [] // 1-S,2-M,3-T,4-W,5-T,6-F,7-S - by default saturday & sunday is holiday at initially
    var holidayList:[Date] = []{
        didSet{
            print(holidayList)
        }
    }
    var manualHolidayList:[Date] = []
    var allDaysList:[Date] = []
    var data: [CalendarDatum] = []{
        didSet{
            print(data)
        }        
    }
    var holidays: [HolidayData] = []{
        didSet{
            print("holiday", holidays)
        }
    }
    
    var colorData:[ColorDatam] = []{
        didSet{
            print(colorData)
        }
    }
    var sizeData:[SizeDatam] = []{
        didSet{
            print(sizeData)
        }
    }
}

struct colorSection {
    var id, colorTitle: String
}

struct sizeSection {
    var id, colorTitle: String
}

extension AddProductionVC: RCProductionDelegate{
    
    // Get production delegate
    func didReceiveGetProduction(data: [CalendarDatum]?){
        self.hideHud()
        if let prodData = data{
            self.bindProductionData(data: prodData)
        }
    }
    
    func didFailedToReceiveGetProduction(errorMessage: String){
        self.hideHud()
    }
   
    // Set production delegate
    func didReceiveSetProduction(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                if self.currentSection == 1{
                    self.currentSection = 2
                    self.updateSection()
                }else if self.currentSection == 2{
                    self.currentSection = 3
                    self.updateSection()
                }else{
                    self.orderInfoDelegate?.updateOrderInfoData(.production, orderInfoData: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    func didFailedToReceiveSetProduction(errorMessage: String){
        self.hideHud()
    }
    
    // Get holidays delegate
    func didReceiveGetHolidays(data: [HolidayData]?){
        self.hideHud()
        if let holidayData = data{
            self.sections[0].holidays = holidayData
            self.sections[1].holidays = holidayData
            self.sections[2].holidays = holidayData
        }
        self.makeProductionData()
       
    }
    
    func didFailedToReceiveGetHolidays(errorMessage: String){
        self.hideHud()
    }
    
    func didReceiveGetWeekOffs(data: [WeekOffData]?){
        self.hideHud()
        if let weekOffData = data{
            self.weekOffList = weekOffData
            self.mapWeekOff()
        }
    }
    
    func didFailedToReceiveGetWeekOffs(errorMessage: String){
        self.hideHud()
    }
    
    // Create holidays delegate
    func didReceiveCreateHolidays(message: String){
        self.hideHud()
        self.getHolidayData()
    }
    
    func didFailedToReceiveCreateHolidays(errorMessage: String){
        self.hideHud()
    }
    
    // Delete holidays delegate
    func didReceiveDeleteHoliday(message: String){
        self.hideHud()
        self.getHolidayData()
    }
    
    func didFailedToReceiveDeleteHoliday(errorMessage: String){
        self.hideHud()
    }
    
    func didReceiveCreateWeekOffs(message: String, data: [WeekOffData]?){
        self.hideHud()
        print(self.sections[0].weekoffs, selectedWeekOff, data)
        if let holidayData = data{
            self.sections[0].weekoffs = []
            self.sections[1].weekoffs = []
            self.sections[2].weekoffs = []
            
            for data in holidayData{
                self.sections[0].weekoffs.append(data.day+1)
                self.sections[1].weekoffs.append(data.day+1)
                self.sections[2].weekoffs.append(data.day+1)
            }
            
        }
        print(self.sections[0].weekoffs,self.sections[1].weekoffs, self.sections[2].weekoffs, selectedWeekOff)
        
        self.makeProductionData(isWeekOff: true)
        self.updateWeekdaysUI()
    }
   
    func didFailedToReceiveCreateWeekOffs(errorMessage: String){
        self.hideHud()
    }
}

extension Double {
    func roundTo0f() -> NSString{
        return NSString(format: "%.0f", self)
      }
}
