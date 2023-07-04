//
//  AddProductionTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class AddProductionTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var addProductionImageView:UIImageView!
    @IBOutlet var addProductionButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        
        self.mainView.backgroundColor = .white
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.mainView.layer.shadowRadius = 3.0
        self.mainView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.mainView.layer.masksToBounds = false
        self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
        
        titleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "productionTitleText")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        
        self.addProductionImageView.image = Config.Images.shared.getImage(imageName: Config.Images.addProductionIcon)
        self.addProductionImageView.contentMode = .scaleAspectFit
        
        self.addProductionButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "addProductionText"), for: .normal)
        self.addProductionButton.backgroundColor = .clear
        self.addProductionButton.setTitleColor(.primaryColor(), for: .normal)
        self.addProductionButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
    }
    
    func setContet(model:ProductionModel, target:OrderInfoVC?){
        self.addProductionButton.addTarget(target, action: #selector(target?.addProductionButtonTapped(_:)), for: .touchUpInside)

        self.mainView.isUserInteractionEnabled = model.isSectionEnabled
        self.mainView.layer.opacity = model.isSectionEnabled ? 1.0 : 0.3
    }
}
