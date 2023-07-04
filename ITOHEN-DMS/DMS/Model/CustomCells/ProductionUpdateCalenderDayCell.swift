//
//  ProductionUpdateCalenderDayCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import JTAppleCalendar

class ProductionUpdateCalenderDayCell: JTACDayCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var actualLabel: UILabel!
    @IBOutlet var excessShortLabel: UILabel!
    @IBOutlet var delayLabel: UILabel!
    
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
        self.targetLabel.textAlignment = .center
        self.targetLabel.numberOfLines = 0
        self.targetLabel.adjustsFontSizeToFitWidth = true
        
        self.actualLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.actualLabel.textColor = .white
        self.actualLabel.textAlignment = .center
        self.actualLabel.numberOfLines = 1
        self.actualLabel.adjustsFontSizeToFitWidth = true
        
        self.excessShortLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.excessShortLabel.textColor = .white
        self.excessShortLabel.textAlignment = .center
        self.excessShortLabel.numberOfLines = 1
        self.excessShortLabel.adjustsFontSizeToFitWidth = true
        
        self.delayLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
        self.delayLabel.textColor = .white
        self.delayLabel.textAlignment = .center
        self.delayLabel.numberOfLines = 0
        self.delayLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = ""
        self.targetLabel.text = ""
        self.delayLabel.text = ""
        self.actualLabel.text = ""
        self.excessShortLabel.text = ""
       // self.targetLabel.isHidden = true
        self.actualLabel.isHidden = true
       // self.delayLabel.isHidden = true
        //self.excessShortLabel.isHidden = true
        
        self.labelDefaultBackColor()
    }
    
    func setup(data:DMSGetOrderListData){
        
    }
    
    func labelDefaultBackColor(){
        self.targetLabel.backgroundColor = .targetTaskColor()
        self.actualLabel.backgroundColor = .actualTaskColor()
        self.excessShortLabel.backgroundColor = .excessTaskColor()
        self.delayLabel.backgroundColor = .weekOffColor()
    }
    
    func enableText(){
        self.dateLabel.textColor = .delayedColor()
        self.targetLabel.textColor = .white

        self.isUserInteractionEnabled = false
        self.targetLabel.isHidden = false
        self.excessShortLabel.isHidden = false
        self.actualLabel.isHidden = false
    }
    
    func disableText(){
       // self.targetLabel.isHidden = true
        self.actualLabel.isHidden = true
        self.excessShortLabel.isHidden = true
        self.backgroundColor = .lightText
        self.isUserInteractionEnabled = false
    }
    
    func visibleLabel(){
        self.labelDefaultBackColor()
        self.targetLabel.isHidden = false
        self.actualLabel.isHidden = false
        self.excessShortLabel.isHidden = false
        self.delayLabel.isHidden = true
    }
    
    func hideLabel(){
        self.targetLabel.backgroundColor = .clear
        self.actualLabel.backgroundColor = .clear
        self.excessShortLabel.backgroundColor = .clear
        self.delayLabel.backgroundColor = .clear
    }

}
