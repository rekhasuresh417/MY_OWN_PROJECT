//
//  ProductionUpdateCalenderDayCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 04/02/21.
//

import UIKit
import JTAppleCalendar

class ProductionUpdateCalenderDayCell: JTACDayCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var actualLabel: UILabel!
    @IBOutlet var excessShortLabel: UILabel!
    
    var colorId:[ColorDatam]?
    var sizeId:[SizeDatam]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.dateLabel.textColor = .customBlackColor()
        self.dateLabel.backgroundColor = .clear
        self.dateLabel.textAlignment = .center
        self.dateLabel.numberOfLines = 1
        
        self.targetLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.targetLabel.textColor = .white
        self.targetLabel.backgroundColor = UIColor.init(rgb: 0x4B54A9)
        self.targetLabel.textAlignment = .center
        self.targetLabel.numberOfLines = 1
        self.targetLabel.adjustsFontSizeToFitWidth = true
        
        self.actualLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.actualLabel.textColor = .white
        self.actualLabel.backgroundColor = UIColor.init(rgb: 0x9169D4)
        self.actualLabel.textAlignment = .center
        self.actualLabel.numberOfLines = 1
        self.actualLabel.adjustsFontSizeToFitWidth = true
        
        self.excessShortLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.excessShortLabel.textColor = .white
        self.excessShortLabel.backgroundColor = .primaryColor()
        self.excessShortLabel.textAlignment = .center
        self.excessShortLabel.numberOfLines = 1
        self.excessShortLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = ""
        self.targetLabel.text = ""
        self.actualLabel.text = ""
        self.excessShortLabel.text = ""
        self.targetLabel.isHidden = true
        self.actualLabel.isHidden = true
        self.excessShortLabel.isHidden = true
    }
    
    func setup(data:DMSGetOrderListData){
        
    }
    
}
