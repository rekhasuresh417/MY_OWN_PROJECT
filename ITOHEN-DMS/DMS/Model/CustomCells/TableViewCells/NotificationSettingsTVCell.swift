//
//  MultiFileDeleteTVCell.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 13/07/22.
//

import UIKit

class NotificationSettingsTVCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
 
    var target: UIViewController? = nil
    var data: DMSNotificationSettings? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        nameLabel.textColor = .customBlackColor()
        
        self.checkBoxButton.setTitle("", for: .normal)
        self.checkBoxButton.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
        self.checkBoxButton.setImage(UIImage.init(named: Config.Images.checkboxTickIcon), for: .selected)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkBoxButton.isSelected = false
        self.checkBoxButton.isUserInteractionEnabled = true
    }
    
    func setContent(data: DMSNotificationSettings, target: UIViewController? = nil) {
      
        self.data = data
        self.target = target
        
        switch data.displayName {
        case NotificationSettings.emailDueToday.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "emailDueTodayText")
        case NotificationSettings.emailDueTomorrow.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "emailDueTomorrowText")
        case NotificationSettings.emailTaskReschedule.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "emailTaskRescheduleText")
        case NotificationSettings.emailDailyReminder.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "emailDailyReminderText")
        case NotificationSettings.emailWeeklyReminder.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "emailWeeklyReminderText")
        case NotificationSettings.emailTaskAccomplishment.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "emailTaskAccomplishmentText")
        case .none:
            self.nameLabel.text = data.displayName
        case .some(_):
            self.nameLabel.text = data.displayName
        }
    }
   
    func setDashboardContent(data: DMSDashboardSettings) {
      
        self.checkBoxButton.isSelected = data.isChecked ?? false
   
        switch data.name {
        case DashboardSettings.prodStatus.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "productionStatus")
        case DashboardSettings.taskStatus.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "taskStatusText")
        case DashboardSettings.top5DelayedProd.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "top5DelayedProduction")
        case DashboardSettings.top5DelayedTask.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "top5DelayedTasks")
        case DashboardSettings.notifications.rawValue:
            self.checkBoxButton.isSelected = true
            self.checkBoxButton.isUserInteractionEnabled = false
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "notificationTitle")
        case DashboardSettings.ongoingList.rawValue:
            self.checkBoxButton.isSelected = true
            self.checkBoxButton.isUserInteractionEnabled = false
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "onGoingListHeaderText")
        case DashboardSettings.orderStatus.rawValue:
            self.nameLabel.text = LocalizationManager.shared.localizedString(key: "orderStatusTitleText")
        case .none:
            self.nameLabel.text = data.name
        case .some(_):
            self.nameLabel.text = data.name
        }
    }
}
