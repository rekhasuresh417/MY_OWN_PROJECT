//
//  SKUDisplayCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 12/01/21.
//

import UIKit

class SKUDisplayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.init(rgb: 0xF6F6F6)
        [titleLabel,valueLabel].forEach { (label) in
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            if label == titleLabel{
                label?.numberOfLines = 0
                label?.textColor = .primaryColor()
                label?.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
            }else if label == valueLabel{
                label?.textColor = .customBlackColor()
                label?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.valueLabel.text = ""
    }
    
    func setContent(data:SizeAndColorDetails, type:SKUTypes){
        self.titleLabel.text = data.title
        self.valueLabel.text = "\(data.quantity)"
    }
}
