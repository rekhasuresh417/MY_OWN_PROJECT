//
//  HomeCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 30/12/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var descriptionLabel:UILabel!
    @IBOutlet var infoButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.init(rgb: 0xF3F3F3)
        
        self.iconImageView.contentMode = .scaleAspectFit
            
        self.titleLabel.font = UIFont.appFont(ofSize: 14.0, weight: .bold)
        self.titleLabel.textColor = .customBlackColor()
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 1
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
        self.descriptionLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.descriptionLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.descriptionLabel.textAlignment = .left
        self.descriptionLabel.numberOfLines = 2
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
        //self.descriptionLabel.lineBreakMode = .byCharWrapping
        
        self.infoButton.isHidden = true // later, setted H&W constraints to zero in layouts
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.iconImageView.image = nil
    }
    
    func setContent(item: HomeItems){
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        self.iconImageView.image = item.image
        self.infoButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.infoIcon), for: .normal)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
           return layoutAttributes
       }
}
