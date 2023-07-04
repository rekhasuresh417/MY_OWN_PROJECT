//
//  MultiFileDeleteTVCell.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 13/07/22.
//

import UIKit

class EmailScheduleSettingsTVCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var allDayButton: UIButton!
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wenesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!

    var target: UIViewController? = nil
    var data: DMSEmailScheduleSettings? = nil
    var weekdaysButtons:[UIButton] = []
    var selectedEmailSettings: [DMSEMailSettings]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        nameLabel.textColor = .customBlackColor()
        
        self.weekdaysButtons = [sundayButton, mondayButton, tuesdayButton, wenesdayButton, thursdayButton, fridayButton, saturdayButton]
        sundayButton.tag = 1
        mondayButton.tag = 2
        tuesdayButton.tag = 3
        wenesdayButton.tag = 4
        thursdayButton.tag = 5
        fridayButton.tag = 6
        saturdayButton.tag = 7
        
        [allDayButton, sundayButton, mondayButton, tuesdayButton, wenesdayButton, thursdayButton, fridayButton, saturdayButton].forEach { (theButton) in
            theButton?.setTitle("", for: .normal)
            theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            theButton?.setImage(UIImage.init(named: Config.Images.checkboxTickIcon), for: .selected)
            theButton?.backgroundColor = .white
            theButton?.isHighlighted = false
        }
    }

    func setContent(data: DMSEmailScheduleSettings, target: UserSettingsVC? = nil){
      
        self.data = data
        self.target = target
        
        switch data.name {
        case EmailScheduleSettings.orderStatus.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "orderStatusTitleText")
        case EmailScheduleSettings.delayedTasks.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "delayedTasksText")
        case EmailScheduleSettings.completedTasks.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "completedTasksText")
        case .none:
            self.nameLabel.text = ""
        case .some(_):
            self.nameLabel.text = ""
        }
        
        self.sundayButton.isSelected = data.days?.contains(Days.sunday.rawValue) ?? false ? true : false
        self.mondayButton.isSelected = data.days?.contains(Days.monday.rawValue) ?? false ? true : false
        self.tuesdayButton.isSelected = data.days?.contains(Days.tuesday.rawValue) ?? false ? true : false
        self.wenesdayButton.isSelected = data.days?.contains(Days.wednesday.rawValue) ?? false ? true : false
        self.thursdayButton.isSelected = data.days?.contains(Days.thursday.rawValue) ?? false ? true : false
        self.fridayButton.isSelected = data.days?.contains(Days.friday.rawValue) ?? false ? true : false
        self.saturdayButton.isSelected = data.days?.contains(Days.saturday.rawValue) ?? false ? true : false
    }

}
