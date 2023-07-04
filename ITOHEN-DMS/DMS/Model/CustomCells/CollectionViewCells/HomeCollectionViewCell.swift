//
//  HomeCollectionViewCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var totalCountLabel:UILabel!
    @IBOutlet var lastupdatedDateLabel: UILabel!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet weak var updatedTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.contentView.backgroundColor = .white
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.init(rgb: 0xB7B7B7, alpha: 0.5).cgColor
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = 8.0
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 8.0
        ).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.totalCountLabel.text = ""
        self.lastupdatedDateLabel.text = ""
        self.iconImageView.image = nil
    }
    
    func setContent(item: HomeItems){
        self.titleLabel.text = item.title
        self.totalCountLabel.text = "\(item.totalCount)"
        self.lastupdatedDateLabel.text = DateTime.convertDateFormater(item.updatedDate, currentFormat: Date.simpleDateFormatUI, newFormat: RMConfiguration.shared.dateFormat)//item.updatedDate
        self.iconImageView.image = item.image
        self.updatedTextLabel.text = LocalizationManager.shared.localizedString(key: "updatedText")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
           return layoutAttributes
       }
}
