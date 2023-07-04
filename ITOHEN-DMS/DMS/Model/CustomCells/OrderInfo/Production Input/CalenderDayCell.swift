//
//  CalenderDayCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 01/02/21.
//

import UIKit
import JTAppleCalendar

class CalenderDayCell: JTACDayCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.dateLabel.textColor = .customBlackColor()
        self.dateLabel.backgroundColor = .clear
        self.dateLabel.textAlignment = .center
        self.dateLabel.numberOfLines = 1
        
        self.countLabel.isHidden = true
        self.countLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.countLabel.textColor = .white
        self.countLabel.backgroundColor = UIColor.init(rgb: 0x929292)
        self.countLabel.textAlignment = .center
        self.countLabel.numberOfLines = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = ""
        self.countLabel.text = ""
    }
}

