//
//  OrderStatusDetailTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 17/02/21.
//

import UIKit

class OrderStatusDetailTVCell: UITableViewCell {
    
    @IBOutlet var taskTitleLabel:UILabel!
    @IBOutlet var dayDiffLabel:UILabel!
    @IBOutlet var dotLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        
        self.dotLabel.backgroundColor = .customBlackColor()
        self.dotLabel.layer.cornerRadius = self.dotLabel.frame.height / 2.0
        
        [taskTitleLabel, dayDiffLabel].forEach { (label) in
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            if label == self.taskTitleLabel{
                label?.font = .appFont(ofSize: 13.0, weight: .medium)
                label?.textColor = .customBlackColor()
            }else if label == self.dayDiffLabel{
                label?.font = .appFont(ofSize: 12.0, weight: .medium)
                label?.textColor = UIColor.init(rgb: 0xD4313C)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.taskTitleLabel.text = ""
        self.dayDiffLabel.text = ""
    }
    
    func setContent(data:Pending){
        self.taskTitleLabel.text = data.taskDetailTitle
        self.dayDiffLabel.text = data.dayDiffInfo
    }
}
