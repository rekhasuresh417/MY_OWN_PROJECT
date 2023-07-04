//
//  TaskProgressContentTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 21/01/21.
//

import UIKit

class TaskProgressContentTableViewCell: UITableViewCell {
    
    @IBOutlet var firstImageBackgrondView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var statusLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var firstImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.firstImageBackgrondView.layer.cornerRadius =  self.firstImageBackgrondView.frame.width / 2.0
        self.firstImageView.contentMode = .scaleAspectFit
        self.firstImageView.image = nil
        self.firstImageBackgrondView.backgroundColor = .clear
        
        self.titleLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.titleLabel.textColor = .customBlackColor()
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 1
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
        self.dateLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.dateLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.dateLabel.textAlignment = .right
        self.dateLabel.numberOfLines = 1
        
        self.statusLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.statusLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.statusLabel.textAlignment = .left
        self.statusLabel.numberOfLines = 1
        self.statusLabel.lineBreakMode = .byTruncatingTail
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.dateLabel.text = ""
        self.statusLabel.text = ""
        self.firstImageView.image = nil
        self.firstImageBackgrondView.backgroundColor = .clear
    }
    
    func setContent(data:TaskData){
        
        self.titleLabel.text = data.taskTitle
        self.dateLabel.text = data.scheduleDate
        self.statusLabel.text = data.daysLeftInfo
        
        if data.status == "delay"{
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.delayIcon)
            self.firstImageBackgrondView.backgroundColor = UIColor.init(rgb: 0xFF9E0D, alpha: 0.3)
        }else if data.status == "warning"{
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.warningIcon)
            self.firstImageBackgrondView.backgroundColor = UIColor.init(rgb: 0xE40D22, alpha: 0.3)
        }
    }
}
