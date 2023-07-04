//
//  SKUSizeCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 05/01/21.
//

import UIKit

class SKUSizeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.layer.cornerRadius = nameLabel.frame.size.width/2.0
        self.nameLabel.layer.masksToBounds = true
        self.nameLabel.backgroundColor = .lightGray
        self.nameLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .center
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
    }
    
    func setContent(item: DMSAllSize, involvedSize: [Int]){
        self.nameLabel.text = item.sizeTitle
        self.nameLabel.backgroundColor = (item.isSelected) ? .primaryColor() : UIColor.init(rgb: 0xE6E6E6)
        self.nameLabel.textColor = (item.isSelected) ? .white : .customBlackColor()
        self.isUserInteractionEnabled = involvedSize.contains(Int(item.id) ?? 0) ? false : true
        self.nameLabel.alpha = involvedSize.contains(Int(item.id) ?? 0) ? 0.3 : 1.0
        self.nameLabel.isUserInteractionEnabled = involvedSize.contains(Int(item.id) ?? 0) ? false : true
    }
}
