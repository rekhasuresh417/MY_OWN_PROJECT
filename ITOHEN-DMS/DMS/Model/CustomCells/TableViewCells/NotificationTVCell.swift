//
//  NotificationTVCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class NotificationTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var statusLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var firstImageView:UIImageView!
    @IBOutlet var readStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.mainView.backgroundColor = .white
        self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
        self.mainView.layer.shadowOpacity = 0.2
        self.mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.mainView.layer.shadowRadius = 2.0
        self.mainView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.mainView.layer.masksToBounds = false
        
        self.titleLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.titleLabel.textColor = .customBlackColor()
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 0
        
        self.dateLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.dateLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.dateLabel.textAlignment = .right
        self.dateLabel.numberOfLines = 1
        
        self.statusLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.statusLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.statusLabel.textAlignment = .left
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.dateLabel.text = ""
        self.statusLabel.text = ""
    }
    
    func setContent(data: DMSNotificationData, target: UIViewController){
        
        self.titleLabel.textColor = data.readNotification == "1" ? .customBlackColor() : .customBlackColor()
        self.readStatusLabel.backgroundColor = data.readNotification == "1" ? .lightGray : .primaryColor()
        self.titleLabel.text = data.notificationTitle
        let date = (data.createdBy ?? "").components(separatedBy: " ")
        self.dateLabel.text = DateTime.convertDateFormater(date[0], currentFormat: Date.simpleDateFormat, newFormat: RMConfiguration.shared.dateFormat)
        self.statusLabel.text = data.notificationDescription
    
        
        let dict = String().convertToDictionary(text: data.notificationDetails ?? "")
        var msg: String = data.notificationDescription ?? ""
        
        print("dict::", data.notificationType, msg)
        
        if data.notificationType == "Reschedule" {
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.attnIcon)
            self.firstImageView.tintColor = .delyCompletionColor()
            let localizedString = LocalizationManager.shared.localizedString(key: "taskRescheduleNotification")
            msg = String(format: localizedString, "\(dict?["to"] ?? "")", "\(dict?["taskName"] ?? "")", "\(dict?["from"] ?? "")", "\(dict?["to"] ?? "")", "\(dict?["reason"] ?? "")" )
            self.titleLabel.text = LocalizationManager.shared.localizedString(key: "TaskRescheduleTitleNotification")
        }else if data.notificationType == "Reassign" {
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.attnIcon)
            self.firstImageView.tintColor = .delyCompletionColor()
            let localizedString = LocalizationManager.shared.localizedString(key: "taskReassignNotification")
            msg = String(format: localizedString, "\(dict?["to"] ?? "")", "\(dict?["taskName"] ?? "")", "\(dict?["from"] ?? "")", "\(dict?["to"] ?? "")", "\(dict?["reason"] ?? "")" )
            self.titleLabel.text = LocalizationManager.shared.localizedString(key: "TaskReassignTitleNotification")
        }else if data.notificationType == "Accomplished"{
            let localizedString = LocalizationManager.shared.localizedString(key: "taskAccomplishedNotification")
            if let taskName = dict?["taskName"], let accomplishedOn = dict?["accomplishedOn"], let accomplishedBy = dict?["accomplishedBy"] {
                msg = String(format: localizedString, "\(taskName)", "\(accomplishedOn)", "\(accomplishedBy)")
            }
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.remindIcon)
            self.firstImageView.tintColor = .primaryColor()
            self.titleLabel.text = LocalizationManager.shared.localizedString(key: "TaskAccomplishedTitleNotification")
            
        }else if data.notificationType == "Delayed"{
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.dangerIcon)
            self.firstImageView.tintColor = .delayedColor()
        }else if data.notificationType == "overdelay"{
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.overdelayIcon)
            self.firstImageView.tintColor = .delayedColor()
        }
    
        self.statusLabel.text = msg
        
//        if data.redirection == "0" {
//            for subview in self.mainView.subviews {
//                subview.alpha = 1.0
//               }
//        }else{
//            for subview in self.mainView.subviews {
//                subview.alpha = 0.6
//            }
//        }
        
    }
 
}
