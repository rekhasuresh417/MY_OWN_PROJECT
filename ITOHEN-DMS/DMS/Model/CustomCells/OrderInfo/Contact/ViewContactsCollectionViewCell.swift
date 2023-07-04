//
//  ViewContactsCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class ViewContactsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var thumbLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbLabel.layer.cornerRadius =  self.thumbLabel.frame.width / 2.0
        self.thumbLabel.layer.masksToBounds = true
        self.thumbLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.thumbLabel.backgroundColor = UIColor.init(rgb: 0xFF6363, alpha: 0.2)
        self.thumbLabel.textColor = UIColor.init(rgb: 0xFF6363, alpha: 1.0)
        self.thumbLabel.textAlignment = .center
        self.thumbLabel.numberOfLines = 1
        self.thumbLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbLabel.text = ""
    }
    
    func setContent(data:Contact){
        self.thumbLabel.text = self.getThumbName(name: data.contactName)
    }
}
