//
//  SKUQuantityHeaderTableViewCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class SKUQuantityHeaderTableViewCell: UITableViewCell {

    @IBOutlet var colorNameLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var toggleImageView: UIImageView!
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var mainView: UIView!
    
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        
        self.mainView.backgroundColor = .white
        self.mainView.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        
        self.colorNameLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.colorNameLabel.textColor = .customBlackColor()
        self.colorNameLabel.textAlignment = .left
        self.colorNameLabel.numberOfLines = 1
        self.colorNameLabel.sizeToFit()
        
        self.countLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.countLabel.textColor = .customBlackColor()
        self.countLabel.textAlignment = .right
        self.countLabel.numberOfLines = 1
        self.countLabel.sizeToFit()
        
        self.toggleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.downArrowIcon)
        self.toggleImageView.tintColor = .customBlackColor()
        self.toggleImageView.contentMode = .scaleAspectFit
    }
    
    func setContent(section:Section){
        self.colorNameLabel.text = section.colorName
        self.countLabel.text = "\(section.totalSkuQuantityOfSection)"
        if section.collapsed{
            self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
            self.toggleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.downArrowIcon)
        }else{
            self.toggleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon)
            self.mainView.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        }
    }
}
