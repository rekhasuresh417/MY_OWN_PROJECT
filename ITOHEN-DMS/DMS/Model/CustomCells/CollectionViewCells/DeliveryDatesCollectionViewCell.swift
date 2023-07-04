//
//  DeliveryDatesCollectionViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 15/06/23.
//

import UIKit

class DeliveryDatesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabel.textAlignment = .left
        self.dateLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.dateLabel.textColor = .customBlackColor()
        self.dateLabel.layer.cornerRadius = self.dateLabel.frame.height/2
        self.dateLabel.clipsToBounds = true
        self.dateLabel.layer.borderColor = UIColor(rgb: 0x878787).cgColor
        self.dateLabel.layer.borderWidth = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = ""
        self.dateLabel.backgroundColor = UIColor.white
    }
    
    func setContent(date: DeliveryDates, target: UIViewController?){
        self.dateLabel.text = "   \(date.delivery_date ?? "")   "
    }
    
}
