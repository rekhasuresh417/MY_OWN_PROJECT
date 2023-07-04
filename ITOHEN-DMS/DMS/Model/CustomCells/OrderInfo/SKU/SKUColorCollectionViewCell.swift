//
//  SKUColorCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 05/01/21.
//

import UIKit

class SKUColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.layer.cornerRadius = nameLabel.frame.size.height/2.0
        self.nameLabel.layer.masksToBounds = true
        self.nameLabel.backgroundColor = .lightGray
        self.nameLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .center
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
    }
    
    func setContent(item: DMSAllColor, involvedColor: [Int]){
        self.nameLabel.text = item.colorTitle
        self.nameLabel.backgroundColor = (item.isSelected) ? .primaryColor() : UIColor.init(rgb: 0xE6E6E6)
        self.nameLabel.textColor = (item.isSelected) ? .white : .customBlackColor()
        self.isUserInteractionEnabled = involvedColor.contains(Int(item.id) ?? 0) ? false : true
        self.nameLabel.alpha = involvedColor.contains(Int(item.id) ?? 0) ? 0.3 : 1.0
        self.nameLabel.isUserInteractionEnabled = involvedColor.contains(Int(item.id) ?? 0) ? false : true
    }
}
