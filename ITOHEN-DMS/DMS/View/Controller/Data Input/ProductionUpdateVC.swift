//
//  ProductionUpdateVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import JTAppleCalendar

protocol ProductionDataUpdateDelegate {
    func reloadProductionData()
}

class ProductionUpdateVC: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topStackView: UIStackView!

    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var sectionImageView: UIImageView!
    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var startDateTextLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var endDateTextLabel: UILabel!
    
    @IBOutlet var sectionView:UIView!
    @IBOutlet var cuttingButton:UIButton!
    @IBOutlet var sewingButton:UIButton!
    @IBOutlet var packingButton:UIButton!
    
    @IBOutlet var targetColorLabel: UILabel!
    @IBOutlet var targetTextLabel: UILabel!
    @IBOutlet var actualColorLabel: UILabel!
    @IBOutlet var actualTextLabel: UILabel!
    @IBOutlet var excessColorLabel: UILabel!
    @IBOutlet var excessTextLabel: UILabel!
    @IBOutlet var shortColorLabel: UILabel!
    @IBOutlet var shortTextLabel: UILabel!
    
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var calenderMonthHeaderView: UIView!
    @IBOutlet var calenderMHViewHConstraint: NSLayoutConstraint!
    @IBOutlet var calenderDaysHeaderView: UIStackView!
    @IBOutlet var calenderDHViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet var calenderView: JTACMonthView!
    @IBOutlet var calenderToggleNextButton:UIButton!
    @IBOutlet var calenderTogglePreviousButton:UIButton!
    @IBOutlet var calenderViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet var entireProgressSectionLabel: UILabel!
    @IBOutlet var entireProgressSectionView: UIView!
    @IBOutlet var completedPcsLabel: UILabel!
    @IBOutlet var completedPcsValueLabel: UILabel!
    @IBOutlet var totalPcsLabel: UILabel!
    @IBOutlet var totalPcsValueLabel: UILabel!
    @IBOutlet var completedPercentageLabel: UILabel!
    @IBOutlet var completedPercentageValueLabel: UILabel!
    
    @IBOutlet var circularProgressBarSectionView: UIView!
    @IBOutlet var currentOutputLabel: UILabel!
    @IBOutlet var requiredOutputLabel: UILabel!
    @IBOutlet var estCompletionDateLabel: UILabel!
    @IBOutlet var reqCompletionDateLabel: UILabel!
    @IBOutlet var estDateLabel: UILabel!
    @IBOutlet var reqDateLabel: UILabel!
    @IBOutlet var estValueLabel: UILabel!
    @IBOutlet var reqValueLabel: UILabel!
    @IBOutlet var estimatedBarView: MBCircularProgressBarView!
    @IBOutlet var requiredBarView: MBCircularProgressBarView!

    @IBOutlet var delayedProductionType: UILabel!
    @IBOutlet var delayTextLabel: UILabel!
    @IBOutlet var delayTextView: UIView!
 
    @IBOutlet var mondayLabel: UILabel!
    @IBOutlet var tuesdayLabel: UILabel!
    @IBOutlet var wenesdayLabel: UILabel!
    @IBOutlet var thursdayLabel: UILabel!
    @IBOutlet var fridayLabel: UILabel!
    @IBOutlet var saturdayLabel: UILabel!
    @IBOutlet var sundayLabel: UILabel!

    let formatter = DateFormatter()
    var orderInfoSKUData:[OrderSKUData] = []
    var orderSKUData:[SKUData] = []
    var weekDayButtons:[UIButton] = []
    var sectionButtons:[UIButton] = []
    var originalEndDate: String = ""
    
    var orderId:String = "0"
    var currentMonthDate: String?
    var calendarData: DMSGetCalendarData?
    var isDelayedCompletion: Bool = false
    
    var weekoffs: [String] = [] // 0-S,1-M,2-T,3-W,4-T,5-F,6-S
    var holidays: [HolidayData] = []
    var holidayList: [Date] = []
    
    var currentSection:Int = 1{
        didSet{
            self.updateSectionsUI()
            self.updateHolidays()
           // self.updateEntireProgressUI()
            self.getProductionData()
            self.reloadCalenderUIComponents()
        }
    }
    var sections:[ProductionSection] = [ProductionSection(productionType: Config.Text.cut,
                                                          startDate: "",
                                                          endDate: "" ),
                                        ProductionSection(productionType: Config.Text.sew,
                                                          startDate: "",
                                                          endDate: ""),
                                        ProductionSection(productionType: Config.Text.pack,
                                                          startDate: "",
                                                          endDate: "")]

    var processData:ProductionData? = nil{
        didSet{
            self.updateSectionsUI()
            //self.updateEntireProgressUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.productionDelegate = self
        self.setupUI()
        self.setupCalenderUI()
        self.getProductionData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.productionDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.title = LocalizationManager.shared.localizedString(key: "prodDataInputTitle")
    }
    
    func setupUI() {
        
        self.sectionButtons = [cuttingButton, sewingButton, packingButton]
        
        noteLabel.text = LocalizationManager.shared.localizedString(key: "prodNotesText")
        noteLabel.font = .appFont(ofSize: 11.0, weight: .medium)
        noteLabel.textColor = UIColor.init(rgb: 0xFF4B1D, alpha: 1.0)
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 1
        noteLabel.adjustsFontSizeToFitWidth = true
        
        self.view.backgroundColor = .appBackgroundColor()
        self.contentView.backgroundColor = .clear
        
        [sundayLabel, mondayLabel, tuesdayLabel, wenesdayLabel, thursdayLabel, fridayLabel, saturdayLabel].forEach { (theLabel) in
            theLabel?.textAlignment = .center
            theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            sundayLabel.text = LocalizationManager.shared.localizedString(key: "sundayText")
            mondayLabel.text = LocalizationManager.shared.localizedString(key: "mondayText")
            tuesdayLabel.text = LocalizationManager.shared.localizedString(key: "tuesdayText")
            wenesdayLabel.text = LocalizationManager.shared.localizedString(key: "wenesdayText")
            thursdayLabel.text = LocalizationManager.shared.localizedString(key: "thursText")
            fridayLabel.text = LocalizationManager.shared.localizedString(key: "fridayText")
            saturdayLabel.text = LocalizationManager.shared.localizedString(key: "saturdayText")
        }
        
        [sectionView, entireProgressSectionView, circularProgressBarSectionView].forEach { (theView) in
            theView?.layer.shadowOpacity = 0.3
            theView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            theView?.layer.shadowRadius = 3.0
            theView?.layer.shadowColor = UIColor.customBlackColor().cgColor
            theView?.layer.masksToBounds = false
            theView?.roundCorners(corners: .allCorners, radius: 10.0)
        }
  
        self.calenderView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
    
        self.cuttingButton.tag = 1
        self.sewingButton.tag = 2
        self.packingButton.tag = 3
        self.sectionButtons.forEach { (button) in
            button.titleLabel?.font = .appFont(ofSize: 15.0, weight: .medium)
            button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
            button.isEnabled = true
            
            if button == cuttingButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "cuttingText"), for: .normal)
            }else if button == sewingButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "sewingText"), for: .normal)
            }else if button == packingButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "packingText"), for: .normal)
            }
        }
        
        self.targetColorLabel.backgroundColor = .targetTaskColor()
        self.actualColorLabel.backgroundColor = .actualTaskColor()
        self.excessColorLabel.backgroundColor = .excessTaskColor()
        self.shortColorLabel.backgroundColor = .delayedColor()
        
        [targetColorLabel, actualColorLabel, excessColorLabel, shortColorLabel].forEach { (label) in
            label?.layer.cornerRadius = 2
            label?.clipsToBounds = true
        }
        
        [targetTextLabel, actualTextLabel, excessTextLabel, shortTextLabel].forEach { (label) in
            label?.backgroundColor = .clear
            label?.font = .appFont(ofSize: 12.0, weight: .medium)
            label?.textColor = .darkGray
            label?.textAlignment = .left
            label?.numberOfLines = 1
            
            if label == targetTextLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "targetText")
            }else if label == actualTextLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "actualText")
            }else if label == excessTextLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "excessText")
            }else if label == shortTextLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "shortText")
            }
        }
        
        self.startDateLabel.text = LocalizationManager.shared.localizedString(key: "startDateText")
        self.endDateLabel.text = LocalizationManager.shared.localizedString(key: "endDateText")

        entireProgressSectionLabel.text = LocalizationManager.shared.localizedString(key: "entireProgressText")
        entireProgressSectionLabel.font = .appFont(ofSize: 16.0, weight: .medium)
        entireProgressSectionLabel.textColor = .customBlackColor()
        entireProgressSectionLabel.textAlignment = .left
        entireProgressSectionLabel.numberOfLines = 1
        
        [completedPcsLabel, totalPcsLabel, completedPercentageLabel].forEach { (label) in
            label?.backgroundColor = .white
            label?.font = .appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = .gray
            label?.textAlignment = .center
            label?.numberOfLines = 1
            
            if label == completedPcsLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "completedPcsText")
            }else if label == totalPcsLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "totalPcsText")
            }else if label == completedPercentageLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "pendingText")
            }
        }
        
        [completedPcsValueLabel, totalPcsValueLabel, completedPercentageValueLabel].forEach { (label) in
            label?.backgroundColor = .clear
            label?.font = .appFont(ofSize: 18.0, weight: .medium)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
        }
        
        [currentOutputLabel, requiredOutputLabel, estDateLabel, reqDateLabel].forEach { (label) in
            label?.backgroundColor = .clear
            label?.font = .appFont(ofSize: 14.0, weight: .semibold)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 2
            
            if label == currentOutputLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "completedQtyText")
            }else if label == requiredOutputLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "requiredQtyText")
            }else{
                label?.numberOfLines = 1 // for estDateLabel & reqDateLabel
            }
        }
        
        [estCompletionDateLabel, reqCompletionDateLabel].forEach { (label) in
            label?.backgroundColor = .clear
            label?.font = .appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = UIColor.init(rgb: 0x7B7B7B)
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            
            if label == estCompletionDateLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "currentDateText")
            }else if label == reqCompletionDateLabel{
                label?.text = LocalizationManager.shared.localizedString(key: "reqCompletionDateText")
            }
        }
        self.completedPercentageValueLabel.textColor = .delayedColor()
        self.completedPercentageLabel.textColor = .delayedColor()
        
        self.estimatedBarView.showValueString = false
        self.requiredBarView.showValueString = false
        self.estimatedBarView.maxValue = 100
        self.requiredBarView.maxValue = 100
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topStackView.addBottomShadow()
    }
    
    func setupCalenderUI() {
        self.calenderViewHConstraint.constant = UIDevice.isPad ? 600.0 : 400.0
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
        
        self.hideCalenderViews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calenderView.visibleDates()
        calenderView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        self.currentSection = sender.tag
    }
  
//    @objc func weekDaysButtonTapped(_ sender: UIButton) {
//        // Update Model
//        if self.currentSection-1 < self.sections.count{
//
//            let index = self.sections[self.currentSection-1].weekoffs.indices.first { (index) in
//                return self.sections[self.currentSection-1].weekoffs[index] == sender.tag
//            }
//
//            if let i = index{
//                self.sections[self.currentSection-1].weekoffs.remove(at: i)
//            }else{
//                self.sections[self.currentSection-1].weekoffs.append(sender.tag)
//            }
//
//            self.reloadCalenderUIComponents()
//        }
//    }
//
    // Get specific day dates
//    func getAllSpecificDayDates(day:Int,from dates:[Date]) -> [Date] {
//        var result:[Date] = []
//        for date in dates{
//            let wkday = Calendar.current.component(.weekday, from: date)
//            if day == wkday{
//                result.append(date)
//            }
//        }
//        return result
//    }
    
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
    
//    func datesRanges(from: Date, to: Date) -> [Date] {
//        if from > to { return [Date]() }
//
//        var tempDate = from
//        var array = [tempDate]
//
//        while tempDate < to {
//            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
//            array.append(tempDate)
//        }
//
//        return array
//    }
    
    func getValuesForDate(date:String) -> (String, String, String, [ColorDatam], [SizeDatam], isExcess:Bool) {
        
        let index = self.sections[self.currentSection-1].data.indices.first { (index) in
            return self.sections[self.currentSection-1].data[index].dateOfProduction == date
        }
        
        if let i = index{
            var excessOrShort:String = "0"
            var isExcess:Bool = true
            if let tValue = Int(self.sections[self.currentSection-1].data[i].targetValue ?? "0"), let aValue = Int(self.sections[self.currentSection-1].data[i].actualValue ?? "0"){
                if tValue > aValue{
                    excessOrShort = "\(tValue-aValue)"
                    isExcess = false
                }else if tValue < aValue{
                    excessOrShort = "\(aValue-tValue)"
                    isExcess = true
                }
            }
            return (self.sections[self.currentSection-1].data[i].targetValue ?? "0", self.sections[self.currentSection-1].data[i].actualValue ?? "0", excessOrShort, self.sections[self.currentSection-1].colorData, self.sections[self.currentSection-1].sizeData, isExcess)
        }
        
        return ("0","0", "0", [], [], true)
    }
   
    func updateNextPreviousButton() {
        var startDateMonth: [Int] = []
        var endDateMonth: [Int] = []
        var currentDateMonth: [Int] = []
        
        if self.sections[self.currentSection-1].startDate != "" && self.sections[self.currentSection-1].endDate != ""{
            startDateMonth = self.getMonth(dateString: self.sections[self.currentSection-1].startDate, formatter: Date.simpleDateFormat)
            endDateMonth = self.getMonth(dateString: self.sections[self.currentSection-1].endDate, formatter: Date.simpleDateFormat)
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
                
                if startDateMonth[0] < currentDateMonth[0]{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor()
                }else if startDateMonth[0] == currentDateMonth[0] && startDateMonth[1] < currentDateMonth[1]{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor()
                }else{
                    self.calenderTogglePreviousButton.tintColor = .customBlackColor(withAlpha: 0.2)
                }
                
                if endDateMonth[0] > currentDateMonth[0]{
                    self.calenderToggleNextButton.tintColor = .customBlackColor()
                }else if endDateMonth[0] == currentDateMonth[0] && endDateMonth[1] > currentDateMonth[1]{
                    self.calenderToggleNextButton.tintColor = .customBlackColor()
                }else{
                    self.calenderToggleNextButton.tintColor = .customBlackColor(withAlpha: 0.2)
                }
            }
        }
        
    }
    
    func updateSectionsUI() {
        self.sectionButtons.forEach { (button) in
            
            button.backgroundColor = .white // (button.tag == self.currentSection) ? .primaryColor() : .white
            button.setTitleColor((button.tag == self.currentSection) ? .primaryColor() : .darkGray, for: .normal)
       
            if button == cuttingButton{
                button.isEnabled = true
            }else if button == sewingButton{
                if button.tag == self.currentSection{
                    button.setTitleColor(.primaryColor(), for: .normal)
                }else if self.processData?.cuttingDataFeed ?? false{
                    button.setTitleColor(.darkGray, for: .normal)
                }else{
                    button.setTitleColor(.darkGray, for: .normal)
                }
            }else if button == packingButton{
                if button.tag == self.currentSection{
                    button.setTitleColor(.primaryColor(), for: .normal)
                }else if self.processData?.sewingDataFeed ?? false{
                    button.setTitleColor(.darkGray, for: .normal)
                }else{
                    button.setTitleColor(.darkGray, for: .normal)
                }
            }
        }
    }
    
    func updateHolidays() {
        formatter.dateFormat = Date.simpleDateFormat
        
        let startDate:Date? = formatter.date(from: self.sections[self.currentSection-1].startDate)
        let endDate:Date? = formatter.date(from: self.sections[self.currentSection-1].data.last?.dateOfProduction ?? "")//formatter.date(from: self.sections[self.currentSection-1].endDate)
        
        if let sDate = startDate, let eDate = endDate{
            let dates = self.datesRange(from: sDate, to: eDate)
            self.sections[self.currentSection-1].allDaysList = dates
            
            // removed already assigned holiday list to avoid dublicate
            self.sections[self.currentSection-1].holidayList.removeAll()
            
            for model in self.sections[self.currentSection-1].data{
                if model.holidayFlag == "1"{
                    if let pDate = formatter.date(from: model.dateOfProduction ?? ""){
                        self.sections[self.currentSection-1].holidayList.append(pDate)
                    }
                }
            }
        }
    }
    
    func reloadCalenderUIComponents() {
        formatter.dateFormat = Date.simpleDateFormat
        
        if self.currentSection-1 < self.sections.count{
            if self.sections[self.currentSection-1].startDate.isEmptyOrWhitespace() || self.sections[self.currentSection-1].endDate.isEmptyOrWhitespace(){
                self.hideCalenderViews()
                return
            }
          
            if let sDate = self.formatter.date(from: self.sections[self.currentSection-1].startDate), let eDate = self.formatter.date(from: self.sections[self.currentSection-1].endDate){
                if sDate.compare(eDate) == .orderedDescending{
                    self.hideCalenderViews()
                    return
                }else{
                    self.showCalenderViews()
                    self.calenderView.reloadData()
                    self.calenderView.scrollToSegment(.start)
                }
            }
        }
    }
    
//    func updateEntireProgressUI() {
//
//        self.totalPcsValueLabel.text = self.processData?.totalQuantity
//        self.estimatedBarView.progressColor =  UIColor.init(rgb: 0xC92121)
//        self.estimatedBarView.value = 0
//        self.requiredBarView.value = 0
//
//        if self.currentSection == 1{
//            if let perc = self.processData?.cutPerc{
//                self.estimatedBarView.value = perc
//                if perc >= 100.0{
//                    self.estimatedBarView.value = 100.0
//                    self.estimatedBarView.progressColor =  UIColor.init(rgb: 0x016901)
//                }
//            }
//            if let perc = self.processData?.cutPercExp{
//                self.requiredBarView.value = perc
//                if perc >= 100.0{
//                    self.requiredBarView.value = 100.0
//                }
//            }
//        }else if self.currentSection == 2{
//            self.estimatedBarView.value = 0
//            if let perc = self.processData?.sewPerc{
//                self.estimatedBarView.value = perc
//                if perc >= 100.0{
//                    self.estimatedBarView.value = 100.0
//                    self.estimatedBarView.progressColor =  UIColor.init(rgb: 0x016901)
//                }
//            }
//            if let perc = self.processData?.sewPercExp{
//                self.requiredBarView.value = perc
//                if perc >= 100.0{
//                    self.requiredBarView.value = 100.0
//                }
//            }
//        }else if self.currentSection == 3{
//            self.estimatedBarView.value = 0
//            if let perc = self.processData?.packPerc{
//                self.estimatedBarView.value = perc
//                if perc >= 100.0{
//                    self.estimatedBarView.value = 100.0
//                    self.estimatedBarView.progressColor =  UIColor.init(rgb: 0x016901)
//                }
//            }
//            if let perc = self.processData?.packPercExp{
//                self.requiredBarView.value = perc
//                if perc >= 100.0{
//                    self.requiredBarView.value = 100.0
//                }
//            }
//        }
//    }

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
  
    func getProductionData() {
        
        guard self.currentSection-1 < self.sections.count else {
            return
        }
        self.showHud()
        let params:[String:Any] = [ "order_id": self.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "type_of_production": self.sections[self.currentSection-1].productionType]
        print(params)
        RestCloudService.shared.getCalendarData(params: params)
 
    }
    
    func bindCalendarData(data: DMSGetCalendarData){
      
        // set dateformat
        formatter.dateFormat = Date.simpleDateFormat
        
        // get sections data
        self.sections[self.currentSection-1].data = data.CalendarData ?? []
        self.sections[self.currentSection-1].colorData = []
        self.sections[self.currentSection-1].sizeData = []
        
        // get weekopff
        if let weekoffs = data.weekOffs{
            for days in weekoffs{
                self.weekoffs.append("\(days.days)")
            }
        }
        // get holidays
        self.holidays = data.holidays ?? []
       
        // get order SKU data
        if let skuData = data.skuData{
            self.orderSKUData = skuData
        }
      
        var isCompleted: Int = 0
        var completionDate: String = ""
        
        // get cutting start & end date
      if self.sections[currentSection-1].productionType == Config.Text.cut{
          self.sections[self.currentSection-1].startDate = data.prodDetails?.cutStartDate ?? ""
          self.sections[self.currentSection-1].endDate = data.prodDetails?.cutEndDate ?? ""
          isCompleted = data.prodDetails?.isCutAccomplished ?? 0
          completionDate = data.prodDetails?.cutAccomplishedDate ?? ""
      
          self.sectionLabel.text = LocalizationManager.shared.localizedString(key: "cuttingText")
          self.delayedProductionType.text = LocalizationManager.shared.localizedString(key: "cuttingText")
          
          self.sectionImageView.image = UIImage.init(named: Config.Images.cuttingIcon)
          self.sections[currentSection-1].productionType = Config.Text.cut
   
      }else if self.sections[currentSection-1].productionType == Config.Text.sew{ // get sewing start & end date
          self.sections[self.currentSection-1].startDate = data.prodDetails?.sewStartDate ?? ""
          self.sections[self.currentSection-1].endDate = data.prodDetails?.sewEndDate ?? ""
          isCompleted = data.prodDetails?.isSewAccomplished ?? 0
          completionDate = data.prodDetails?.sewAccomplishedDate ?? ""
             
           self.sectionLabel.text = LocalizationManager.shared.localizedString(key: "sewingText")
          self.delayedProductionType.text = LocalizationManager.shared.localizedString(key: "sewingText")

           self.sectionImageView.image = UIImage.init(named: Config.Images.sewingIcon)
           self.sections[currentSection-1].productionType = Config.Text.sew
        
      }else if self.sections[currentSection-1].productionType == Config.Text.pack{  // get packing start & end date
          self.sections[self.currentSection-1].startDate = data.prodDetails?.packStartDate ?? ""
          self.sections[self.currentSection-1].endDate = data.prodDetails?.packEndDate ?? ""
          isCompleted = data.prodDetails?.isPackAccomplished ?? 0
          completionDate = data.prodDetails?.packAccomplishedDate ?? ""
        
          self.sectionLabel.text = LocalizationManager.shared.localizedString(key: "packingText")
          self.delayedProductionType.text = LocalizationManager.shared.localizedString(key: "packingText")

          self.sectionImageView.image = UIImage.init(named: Config.Images.packingIcon)
          self.sections[currentSection-1].productionType = Config.Text.pack
      }
      
        self.originalEndDate = self.sections[self.currentSection-1].endDate
   
        self.startDateTextLabel.text = DateTime.convertDateFormater(self.sections[self.currentSection-1].startDate, currentFormat: Date.simpleDateFormat, newFormat: RMConfiguration.shared.dateFormat)
        self.endDateTextLabel.text =  DateTime.convertDateFormater(self.sections[self.currentSection-1].endDate, currentFormat: Date.simpleDateFormat, newFormat: RMConfiguration.shared.dateFormat)
        
        delayTextView.backgroundColor = .clear
      
        // formatted start and end date
        let startDate = DateTime.stringToDate(dateString: self.sections[self.currentSection-1].startDate, dateFormat: Date.simpleDateFormat)
        let endDate = DateTime.stringToDate(dateString: self.sections[self.currentSection-1].endDate, dateFormat: Date.simpleDateFormat)
        let accomplished = DateTime.stringToDate(dateString: completionDate, dateFormat: Date.simpleDateFormat) ?? Date()
      
        // Get holidays and weekoff list
        self.getHolidayWeekOffList(data: data)
     
      if let end = endDate, end < Date() && accomplished > end{
            self.sectionLabel.isHidden = true
            self.delayTextView.isHidden = false
        
            if isCompleted == 1 || data.knobChart?.pendingQuantity ?? 0==0{ // completion with delay
                sectionImageView.tintColor = .delyCompletionColor()
                delayedProductionType.textColor = .delyCompletionColor()
                delayTextLabel.textColor = .delyCompletionColor()
                delayTextLabel.text = LocalizationManager.shared.localizedString(key: "delayedCompletionTitleText") //"delayedCompletionTitleText")
                isDelayedCompletion = true
            }else{ // not yet completed (delayed)
                sectionImageView.tintColor = .delayedColor()
                delayedProductionType.textColor = .delayedColor()
                delayTextLabel.textColor = .delayedColor()
                delayTextLabel.text = LocalizationManager.shared.localizedString(key: "delayedTitleText")
            }
        }else{ // completion without delay

            if isCompleted == 1{
                self.sectionLabel.isHidden = true
                self.delayTextView.isHidden = false
                isDelayedCompletion = false
                sectionImageView.tintColor = .primaryColor()
                delayedProductionType.textColor = .primaryColor()
                delayTextLabel.textColor = .primaryColor()
                delayTextLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
            }else{
                sectionImageView.tintColor = .primaryColor()
                sectionLabel.textColor = .primaryColor()
                self.delayTextView.isHidden = true
                self.sectionLabel.isHidden = false
            }
        }

        self.completedPcsValueLabel.text = "\(data.knobChart?.completedQuantity ?? 0)"
        self.totalPcsValueLabel.text = "\(data.knobChart?.totalQuantity ?? 0)"
        self.completedPercentageValueLabel.text = "\(data.knobChart?.pendingQuantity ?? 0)"
   
        /// Set knop chart data
        let currentDate = DateTime.formatDate(date: Date(), dateFormat: Date.simpleDateFormat)
        var targetValue = Int(data.knobChart?.currentOutputQuantity ?? 0) + Int(data.knobChart?.reqOutputRate ?? 0)
        var completdQty: Double = 0
        var count: Double = 0
        
       if let calData = calendarData?.CalendarData{
            for item in calData{
                if item.dateOfProduction == currentDate{
                    targetValue = Int(item.targetValue ?? "0") ?? 0
                }
                
                if item.actualValue != "0"{
                    print((item.actualValue ?? "0"))
                    completdQty = completdQty + (Double(item.actualValue ?? "0") ?? 0.0)
                    count = count+1
                }
            }
        }
            
        if let end = endDate, end < Date() && data.knobChart?.pendingQuantity ?? 0 > 0{
            targetValue = data.knobChart?.pendingQuantity ?? 0
        }
        
        print(targetValue)
        self.estimatedBarView.maxValue = CGFloat(targetValue)
        self.requiredBarView.maxValue = CGFloat(targetValue)
            
        var currentOutputQty: Double = 0
        
        if count > 0 {//}&& data.knobChart?.pendingQuantity ?? 0 > 0{
            currentOutputQty = completdQty/count //data.knobChart?.currentOutputQuantity ?? 0
        }
        
        currentOutputQty = currentOutputQty.rounded()
        
        let reqOutputRate: Int = data.knobChart?.reqOutputRate ?? 0
       
        var currentOutputQtyPerc: Double = 0
        var reqOutputRatePerc: Double = 0
       
        if targetValue > 0{
            currentOutputQtyPerc = (Double(currentOutputQty)/Double(targetValue)) * 100
            reqOutputRatePerc = (Double(reqOutputRate)/Double(targetValue)) * 100
        }

        let stDate = DateTime.formatDate(date: Date.reduceDays(day: 1, fromDate: startDate ?? Date()), dateFormat: Date.simpleDateFormat)
        let edDate = DateTime.formatDate(date: Date.reduceDays(day: 1, fromDate: endDate ?? Date()), dateFormat: Date.simpleDateFormat)
        let ctDate = DateTime.formatDate(date: Date(), dateFormat: Date.simpleDateFormat)
        
        //-------------------------
        self.estimatedBarView.value = Int(currentOutputQty) > targetValue ? CGFloat(targetValue) : CGFloat(currentOutputQty)
        self.requiredBarView.value = reqOutputRate  > targetValue ? CGFloat(targetValue) : CGFloat(reqOutputRate)
      
        if edDate < ctDate && isCompleted == 0{
            estimatedBarView.progressColor = .delayedColor()
            requiredBarView.progressColor = .delayedColor()
        }else if stDate <= ctDate && isCompleted == 0{ // 'completed' bar chart percentage
            if currentOutputQtyPerc > 0 && currentOutputQtyPerc <= 50{
                estimatedBarView.progressColor = .delayedColor()
            }else if currentOutputQtyPerc > 99{
                estimatedBarView.progressColor = .snobChatCompletedColor()
            }else if currentOutputQtyPerc > 50 && currentOutputQtyPerc < 100{
                estimatedBarView.progressColor = .snobChatDelyCompletionColor()
            }else {
                estimatedBarView.progressColor = .snobChatInitialColor()
            }
            
            // 'Required' bar chart percentage
            if reqOutputRatePerc == 0{
                requiredBarView.progressColor = .snobChatInitialColor()
            }else if reqOutputRatePerc > 99{
                requiredBarView.progressColor = .delayedColor()
            }else if reqOutputRatePerc > 50 && reqOutputRatePerc < 100{
                requiredBarView.progressColor = .snobChatDelyCompletionColor()
            }else if reqOutputRatePerc > 0 && reqOutputRatePerc <= 50{
                requiredBarView.progressColor = .snobChatCompletedColor()
            }
             
        }else{ // Start date is future date
            estimatedBarView.progressColor = .snobChatInitialColor()
            requiredBarView.progressColor = .snobChatInitialColor()
        }
    
        var completed: UIColor = UIColor()
        var required: UIColor = UIColor()
       
        print(currentOutputQtyPerc,
              reqOutputRatePerc,
              isCompleted)
        
        /// Snob Chat's Text Color
        if stDate <= ctDate && isCompleted == 0  && targetValue != 0{
            completed = currentOutputQtyPerc == 0 ? .delayedColor() : estimatedBarView.progressColor
            required = requiredBarView.progressColor == .snobChatInitialColor() ? .snobChatDefaultColor() : requiredBarView.progressColor
        }else{
            completed = .snobChatDefaultColor()
            required = .snobChatDefaultColor()
        }
        
        
        self.estValueLabel.attributedText = self.getAttributedText(firstString: "\(Int(currentOutputQty))\n",
                                                                   firstFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                   firstColor: completed,
                                                                   secondString: LocalizationManager.shared.localizedString(key: "perDayText"),
                                                                   secondFont: UIFont.appFont(ofSize: 10.0, weight: .medium),
                                                                   secondColor:  .inProgressColor())
        self.estDateLabel.text = DateTime.formatDate(date: Date(), dateFormat: RMConfiguration.shared.dateFormat)
        
        self.reqValueLabel.attributedText = self.getAttributedText(firstString: "\(data.knobChart?.reqOutputRate ?? 0)\n",
                                                                   firstFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                   firstColor: required,
                                                                   secondString: LocalizationManager.shared.localizedString(key: "perDayText"),
                                                                   secondFont: UIFont.appFont(ofSize: 10.0, weight: .medium),
                                                                   secondColor:  .inProgressColor())
        self.reqDateLabel.text = self.endDateTextLabel.text
      
        /// We should change start date and end date for Calendar showing from next to prevois
        self.updateHolidays()
        // self.sections[self.currentSection-1].startDate = DateTime.formatDate(date: Date.reduceDays(day: 1000, fromDate: Date()), dateFormat: Date.simpleDateFormat)
        self.sections[self.currentSection-1].endDate = DateTime.formatDate(date: Date.addDays(day: 1000, fromDate: Date()), dateFormat: Date.simpleDateFormat)

        self.updateSectionsUI()
        self.reloadCalenderUIComponents()
    }
   
    func completedLabelColor(){
        self.sectionLabel.isHidden = true
        self.delayTextView.isHidden = false
        sectionImageView.tintColor = .completedColor()
        self.delayedProductionType.textColor = .completedColor()
        isDelayedCompletion = false
        sectionLabel.textColor = .completedColor()
        delayTextLabel.textColor = .completedColor()
    }
    
    // Get holidays and weekoff list
    func getHolidayWeekOffList(data: DMSGetCalendarData){
//        if data.knobChart?.pendingQuantity ?? 0 == 0{
//            self.sections[self.currentSection-1].endDate = DateTime.formatDate(date: Date(), dateFormat: Date.simpleDateFormat)
//        }else{
//            self.sections[self.currentSection-1].endDate = DateTime.formatDate(date: Date.nextTo30Days, dateFormat: Date.simpleDateFormat)
//        }
  
      //  self.sections[self.currentSection-1].startDate = DateTime.formatDate(date: Date.nextTo30Days, dateFormat: Date.simpleDateFormat)
        
      if let holidayData = data.holidays{
          /// get holidayList
          self.holidayList.removeAll()
          self.holidays.removeAll()
          
          for holiday in holidayData{
              let startDate: Date? = formatter.date(from: holiday.holidayStartDate ?? "")
              let endDate: Date? = formatter.date(from: holiday.holidayEndDate ?? "")
       
              if let sDate = startDate, let eDate = endDate{
                  let dates = self.datesRange(from: sDate, to: eDate)
                  self.holidayList.append(contentsOf: dates)
                  for date in dates{
                      let holidayDate = "\(date)".components(separatedBy: " ")
                      self.holidays.append(HolidayData.init(id: holiday.id ?? "",
                                                           name: holiday.name ?? "",
                                                           desc: holiday.description,
                                                           holidayStartDate: "\(holidayDate[0])",
                                                           holidayEndDate:  "\(holidayDate[0])", days: 1))
                  }
              }
          }
      }
    }
    
    func getLocaleMonthAndYear(date:Date) -> String {
        formatter.locale = Locale(identifier: LocalizationManager.shared.localizedString(key: "localeIdentifier"))
        formatter.dateFormat = "MMMM YYYY"
        let monthAndYear = formatter.string(from: date)
        return monthAndYear
    }
    
    func getDay(date:Date) -> String {
        formatter.locale = Locale(identifier: LocalizationManager.shared.localizedString(key: "localeIdentifier"))
        formatter.dateFormat = "EE"
        let day = formatter.string(from: date)
        switch day {
        case Days.sunday.rawValue:
            return "0"
        case Days.monday.rawValue:
            return "1"
        case Days.tuesday.rawValue:
            return "2"
        case Days.wednesday.rawValue:
            return "3"
        case Days.thursday.rawValue:
            return "4"
        case Days.friday.rawValue:
            return "5"
        case Days.saturday.rawValue:
            return "6"
        default:
            return "7"
        }
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductionUpdateVC: JTACMonthViewDataSource, JTACMonthViewDelegate {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = Date.simpleDateFormat
        
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
     
        self.monthLabel.text = self.getLocaleMonthAndYear(date: startDate)
        self.currentMonthDate = "\(startDate)"
        self.updateNextPreviousButton()
    
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 6,
                                       calendar: .current,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid,
                                       firstDayOfWeek: .sunday,
                                       hasStrictBoundaries: false)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dayCell", for: indexPath) as! ProductionUpdateCalenderDayCell
        cell.dateLabel.text = "  \(cellState.text)"

        // Hide other month cells, current month cell date text color
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
 
        formatter.dateFormat = Date.simpleDateFormat
        let calendarDate = DateTime.formatDate(date: date, dateFormat: Date.simpleDateFormat)
        let currentDate = DateTime.formatDate(date: Date(), dateFormat: Date.simpleDateFormat)
        let originalDate = DateTime.stringToDate(dateString:  self.originalEndDate, dateFormat:  Date.simpleDateFormat)
        
        let newDate = DateTime.convertDateFormater(endDateTextLabel.text ?? "", currentFormat: RMConfiguration.shared.dateFormat, newFormat: Date.simpleDateFormat)
        let endDate = formatter.date(from: newDate)
        let startDateStr = DateTime.convertDateFormater(startDateTextLabel.text ?? "", currentFormat: RMConfiguration.shared.dateFormat, newFormat: Date.simpleDateFormat)
        let startDate = formatter.date(from: startDateStr)
        
        cell.backgroundColor = calendarDate == currentDate ? .cellCurrentDateBackgroundColor() : .white
        cell.dateLabel.textColor = calendarDate == currentDate ? UIColor.primaryColor() : UIColor.customBlackColor()
        cell.dateLabel.backgroundColor = .clear
       
        // Update target value for visible dates
        let values = self.getValuesForDate(date: formatter.string(from: date))
        cell.visibleLabel()
      
        // Check the date within start & end date range and update UI
        if self.sections[self.currentSection-1].allDaysList.contains(date){
            cell.targetLabel.isHidden = false
            cell.targetLabel.textColor = .white
            cell.excessShortLabel.backgroundColor =  values.isExcess ? .excessTaskColor() : .delayedColor()
           
            if values.0 == "0"{
                cell.hideLabel()

                if self.sections[self.currentSection-1].holidayList.contains(date){
                    cell.isUserInteractionEnabled = false
                    cell.targetLabel.backgroundColor = .weekOffColor()
                    cell.dateLabel.textColor = .delayedColor()
                    
                    let model = self.sections[self.currentSection-1].data.filter({$0.dateOfProduction == calendarDate})
                    if model.count > 0{
                        cell.targetLabel.text = model[0].holidayDetail
                    }
                }
            }else{
                // Update worked days
                cell.isUserInteractionEnabled = true

                cell.targetLabel.text = values.0
                cell.actualLabel.text = values.1
                //cell.excessShortLabel.text = values.2
                cell.colorId = values.3
                cell.sizeId = values.4
              
                // For not yet started task, Short should be 0
                if let startDt = startDate, startDt > Date() && self.calendarData?.knobChart?.pendingQuantity ?? 0 != 0 {
                    cell.excessShortLabel.text = "0"
                }else if date > Date() && self.calendarData?.knobChart?.pendingQuantity ?? 0 != 0 {
                    cell.excessShortLabel.text = "0"
                }else{
                    cell.excessShortLabel.text = values.2
                }
                
                if let end = endDate, end < date {
                    // after dalyed task
                    cell.targetLabel.isHidden = true
                }
                
                /// Delayed completion
                if let end = endDate, date > end && values.0 == values.1 && self.calendarData?.knobChart?.pendingQuantity ?? 0 == 0{
                    cell.targetLabel.isHidden = false
                    cell.targetLabel.text = "\(LocalizationManager.shared.localizedString(key: "delayedCompletionTitleText"))"
                    cell.targetLabel.textColor = .delyCompletionColor()
                    cell.targetLabel.backgroundColor = .white
                }
            }
         
        }else{
            // Out of start & end date range UI updates
            cell.hideLabel()
            cell.backgroundColor = calendarDate == currentDate ? .cellCurrentDateBackgroundColor() : .white
            cell.isUserInteractionEnabled = false
        }
  
        /*-------------Delayed task with Holiday and weekoff showing-------------------*/
        let day = self.getDay(date: date) // Get day
        if let oriEndDate = originalDate, oriEndDate < date && (self.weekoffs.contains(day) || self.holidayList.contains(date)) {
           
            // after dalyed task
            
            cell.dateLabel.textColor = .delayedColor()
            cell.delayLabel.isHidden = false
            cell.delayLabel.backgroundColor = .weekOffColor()
            cell.isUserInteractionEnabled = false

            print("date", date, "day", day,"weekoff", weekoffs, "holiday list", holidayList)
            if self.weekoffs.contains(day) {
                
                // Update Weekoff
                cell.delayLabel.text = LocalizationManager.shared.localizedString(key: "weekOffText")
            }else{
               
                // Update Holiday
                if self.holidayList.contains(date){
                    let today = DateTime.formatDate(date: Date.reduceDays(day: 1, fromDate: date), dateFormat: Date.simpleDateFormat)
                    let holiday = self.holidays.filter {
                        $0.holidayStartDate == today }
                    if holiday.count>=1{
                        cell.delayLabel.text = holiday[0].name
                    }else{
                        cell.delayLabel.text = "Holiday"
                    }
                }
            }

        }else{
            cell.delayLabel.isHidden = true
        }
     
        /// Delayed Task and Current date
        if let end = endDate, date > end && calendarDate == currentDate && self.calendarData?.knobChart?.pendingQuantity ?? 0>0 && !self.sections[self.currentSection-1].holidayList.contains(date){
            print(self.sections[self.currentSection-1].holidayList, date)
            cell.isUserInteractionEnabled = true
            cell.visibleLabel()
            cell.targetLabel.backgroundColor = .white
            cell.targetLabel.textColor = .delayedColor()
            cell.actualLabel.backgroundColor = .actualTaskColor()
            cell.excessShortLabel.backgroundColor = "\(self.calendarData?.knobChart?.reqOutputRate ?? 0)" == "0" ? .excessTaskColor() : .delayedColor()

           // cell.actualLabel.textColor = .customBlackColor()
            
            cell.targetLabel.text = "\(LocalizationManager.shared.localizedString(key: "delayedTitleText"))"
            cell.actualLabel.text = "\(self.calendarData?.knobChart?.currentOutputQuantity ?? 0)"
            cell.excessShortLabel.text = "\(self.calendarData?.knobChart?.reqOutputRate ?? 0)"
        }
        cell.delayLabel.isHidden = cell.delayLabel.text?.isEmptyOrWhitespace() == false ? false : true
        cell.targetLabel.isHidden = cell.targetLabel.text?.isEmptyOrWhitespace() == false ? false : true
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print(date as Any)
        formatter.dateFormat = Date.simpleDateFormat
        let newDate = DateTime.convertDateFormater(endDateTextLabel.text ?? "", currentFormat: RMConfiguration.shared.dateFormat, newFormat: Date.simpleDateFormat)
        let endDate = formatter.date(from: newDate)
        let calendarDate = DateTime.formatDate(date: date, dateFormat: Date.simpleDateFormat)
        let currentDate = DateTime.formatDate(date: Date(), dateFormat: Date.simpleDateFormat)
    
        /// Only current date , we can put input (For delayed date aprt from current date not allowed))
        if let end = endDate, Date() > end && calendarDate != currentDate && self.calendarData?.knobChart?.pendingQuantity ?? 0 >= 0{
            print("date expired")
            return
        }
        
        // Only allow current and previous dates to give entry - not for future dates
        if date.timeIntervalSinceNow.sign == .minus{
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editDataInput.rawValue) == true || (calendarDate == currentDate && self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addDataInput.rawValue) == true){
                DispatchQueue.main.async {
                    if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .dataInputUpdate) as? DataInputUpdateVC {
                        vc.orderId = self.orderId
                        vc.productionType = self.sections[self.currentSection-1].productionType
                        vc.viewSkuData = self.orderSKUData
                        vc.selectedDate = date
                        vc.knobChart = self.calendarData?.knobChart
                        vc.targetValue = "\(Int(self.calendarData?.knobChart?.currentOutputQuantity ?? 0) + Int(self.calendarData?.knobChart?.reqOutputRate ?? 0))"
                        vc.dataUpdateDelegate = self
                        vc.isDelayedCompletion = self.isDelayedCompletion
                        
                        if let end = endDate, date > end{
                            vc.isExcess = true
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                            message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                            target: self)
            }
        }
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

extension ProductionUpdateVC: ProductionDataUpdateDelegate {
    func reloadProductionData() {
        DispatchQueue.main.async {
            self.getProductionData()
        }
    }
}

extension ProductionUpdateVC: RCProductionDelegate{
   
    func didReceiveGetCalendarData(data: DMSGetCalendarData?){
        self.hideHud()
        if let calendarData = data{
            DispatchQueue.main.async {
                self.calendarData = calendarData
                self.bindCalendarData(data: calendarData)
            }
    
        }
    }
    
    func didFailedToReceiveGetCalendarData(errorMessage: String){
        self.hideHud()
    }
}
