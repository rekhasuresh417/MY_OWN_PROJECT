//
//  LanguageCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 28/12/20.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var iconBackgroundView:UIView!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var ticIconBackgroundView: UIView!
    @IBOutlet var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        self.iconBackgroundView.layer.cornerRadius = 0.5 * self.iconBackgroundView.bounds.size.width
        self.iconBackgroundView.layer.borderWidth = 2.0
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.nameLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.nameLabel.textColor = UIColor.init(rgb: 0x595960)
        self.nameLabel.numberOfLines = 1
    }
    
    func setContent(row: Int, id: Int){
        self.ticIconBackgroundView.layer.cornerRadius = self.ticIconBackgroundView.frame.height / 2.0
        
        if id == Config.AppLanguages[row].id{
            self.contentView.layer.borderWidth = 2.0
            self.contentView.layer.borderColor = UIColor.primaryColor().cgColor
            self.iconBackgroundView.layer.borderColor = UIColor.primaryColor().cgColor
            self.iconBackgroundView.backgroundColor = .white
            self.ticIconBackgroundView.backgroundColor = .primaryColor()
            self.tickImageView.backgroundColor = .primaryColor()
            self.tickImageView.image = Config.Images.shared.getImage(imageName: Config.Images.tickIcon)
            self.nameLabel.font = UIFont.appFont(ofSize: 14.0, weight: .semibold)
            self.nameLabel.textColor = .customBlackColor()
        }else{
            self.contentView.layer.borderWidth = 2.0
            self.contentView.layer.borderColor = UIColor.lightGray.cgColor
            self.iconBackgroundView.layer.borderColor = UIColor.init(rgb: 0xC4C4C4).cgColor
            self.iconBackgroundView.backgroundColor = .clear
            self.tickImageView.image = nil
            self.ticIconBackgroundView.backgroundColor = .white
            self.tickImageView.backgroundColor = .white
            self.nameLabel.font = UIFont.appFont(ofSize: 14.0, weight: .regular)
            self.nameLabel.textColor = UIColor.init(rgb: 0x595960)
            
        }
        self.iconImageView.image = Config.Images.shared.getImage(imageName: Config.AppLanguages[row].flag)
        self.iconImageView.contentMode = .scaleAspectFit
        self.nameLabel.text = Config.AppLanguages[row].name
    }
}
