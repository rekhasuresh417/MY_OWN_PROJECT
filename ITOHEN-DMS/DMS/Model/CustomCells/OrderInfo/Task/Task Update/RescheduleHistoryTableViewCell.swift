//
//  RescheduleHistoryTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 25/01/21.
//

import UIKit

class RescheduleHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var dateStampLabel:UILabel!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var reasonLabel:UILabel!
    @IBOutlet var changedFromLabel:UILabel!
    @IBOutlet var changedToLabel:UILabel!
    @IBOutlet var changedFromValueLabel:UILabel!
    @IBOutlet var changedToValueLabel:UILabel!
    @IBOutlet var highlighterLabel:UILabel!
    
    let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        self.mainView.layer.borderWidth = 1.0
        self.mainView.layer.borderColor = UIColor.init(rgb: 0x707070, alpha: 0.3).cgColor
        self.highlighterLabel.backgroundColor = .primaryColor()
        
        self.dateStampLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.dateStampLabel.textColor = .customBlackColor()
        self.dateStampLabel.textAlignment = .left
        self.dateStampLabel.numberOfLines = 1
        
        self.nameLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        
        self.reasonLabel.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
        self.reasonLabel.textColor = UIColor.init(rgb: 0x727272)
        self.reasonLabel.textAlignment = .left
        self.reasonLabel.numberOfLines = 2
        
        [changedFromLabel,changedToLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = UIColor.init(rgb: 0x727272)
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.text = label == changedFromLabel ? LocalizationManager.shared.localizedString(key1: "TaskRescheduleHistory", key2: "changedFromText") : LocalizationManager.shared.localizedString(key1: "TaskRescheduleHistory", key2: "changedToText")
        }
        
        changedFromValueLabel.text = "-"
        changedToValueLabel.text = "-"
        [changedToValueLabel,changedFromValueLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.dateStampLabel.text = ""
        self.reasonLabel.text = ""
        self.changedFromValueLabel.text = ""
        self.changedToValueLabel.text = ""
    }
    
    func setContent(data:DMSGetRescheduleHistoryData){
        self.nameLabel.text = data.userName
        self.dateStampLabel.text = data.updateTime
        self.reasonLabel.text = data.comments
        self.changedFromValueLabel.text = data.prevData
        self.changedToValueLabel.text = data.currentData
    }
}
