//
//  PendingTaskContentTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 15/02/21.
//

import UIKit

class PendingTaskContentTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var taskTitleLabel:UILabel!
    @IBOutlet var styleNoLabel:UILabel!
    @IBOutlet var dayDiffImageView:UIImageView!
    @IBOutlet var dayDiffLabel:UILabel!
    
    var orderId:String = "0"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.mainView.backgroundColor = .white
        
        [taskTitleLabel,styleNoLabel, dayDiffLabel].forEach { (label) in
            label?.textColor = .customBlackColor()
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            
            if label == taskTitleLabel{
                label?.font = .appFont(ofSize: 14.0, weight: .medium)
            }else if label == styleNoLabel{
                label?.font = .appFont(ofSize: 12.0, weight: .regular)
            }else if label == dayDiffLabel{
                label?.font = .appFont(ofSize: 12.0, weight: .regular)
            }
        }
        
        dayDiffImageView.tintColor = .white
        dayDiffImageView.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.taskTitleLabel.text = ""
        self.styleNoLabel.text = ""
        self.dayDiffLabel.text = ""
        self.dayDiffImageView.image = nil
    }
    
    func setContent(data:TaskDetailsData, target:PendingTaskVC?){
        self.orderId = data.orderID
        self.taskTitleLabel.text = data.taskDetailTitle
        self.styleNoLabel.text = "Style No : " + data.styleNo
        self.dayDiffLabel.text = data.dayDiffInfo
        if let dayDiff = Int(data.dayDiff){
            if dayDiff > 0 {
                self.dayDiffImageView.image = Config.Images.shared.getImage(imageName: Config.Images.delayIcon)
                self.dayDiffLabel.textColor = UIColor.init(rgb: 0xFF9E0D)
            }else{
                self.dayDiffImageView.image = Config.Images.shared.getImage(imageName: Config.Images.warningIcon)
                self.dayDiffLabel.textColor = UIColor.init(rgb: 0xE40D22)
            }
            self.dayDiffImageView.alpha = 0.7
            self.dayDiffLabel.alpha = 0.7
        }
    }
}
