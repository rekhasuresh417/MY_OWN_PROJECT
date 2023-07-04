//
//  NotificationTVCell.swift
//  Itohen-dms
//
//  Created by Dharma on 30/01/21.
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
    
    func setContent(data:DMSNotificationData, target: UIViewController){
        
        self.titleLabel.textColor = data.readNotification == "1" ? .customBlackColor() : .customBlackColor() //.gray : .customBlackColor()
        self.readStatusLabel.backgroundColor = data.readNotification == "1" ? .lightGray : .primaryColor()
        self.titleLabel.text = data.notificationTitle
        self.dateLabel.text = data.createdDay ?? ""
        self.statusLabel.text = data.notificationDescription
        
        if data.notificationType.lowercased() == "attn" || data.notificationType.lowercased() == "close_order_reject"  || data.notificationType.lowercased().contains("cancel_order"){
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.attnIcon)
        }else if data.notificationType.lowercased() == "danger"{
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.dangerIcon)
        }else if data.notificationType.lowercased() == "remind" || data.notificationType.lowercased().contains("close_order") {
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.remindIcon)
        }else if data.notificationType.lowercased() == "overdelay"{
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.overdelayIcon)
        }else if data.notificationType.lowercased().contains("delete_order") {
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.overdelayIcon)
        }
        
        if data.redirection == "0" {
            for subview in self.mainView.subviews {
                subview.alpha = 1.0
               }
        }else{
            for subview in self.mainView.subviews {
                subview.alpha = 0.6
               }
        }
        
    }
 
}
