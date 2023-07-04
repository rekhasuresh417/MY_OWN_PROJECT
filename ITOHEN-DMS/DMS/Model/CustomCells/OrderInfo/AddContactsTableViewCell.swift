//
//  AddContactsTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class AddContactsTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var addContactImageView:UIImageView!
    @IBOutlet var addContactButton:UIButton!
    
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
        
        titleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "contactTitleText")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        
        self.addContactImageView.image = Config.Images.shared.getImage(imageName: Config.Images.addContactIcon)
        self.addContactImageView.contentMode = .scaleAspectFit
        
        self.addContactButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "addContactText"), for: .normal)
        self.addContactButton.backgroundColor = .clear
        self.addContactButton.setTitleColor(.primaryColor(), for: .normal)
        self.addContactButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
    }
    
    func setContet(model:ContactModel, target:OrderInfoVC?){
        self.addContactButton.tag = target!.editTag // edit/add contacts
        self.addContactButton.addTarget(target, action: #selector(target?.addOrViewContactButtonTapped(_:)), for: .touchUpInside)
        
        self.mainView.isUserInteractionEnabled = model.isSectionEnabled
        self.mainView.layer.opacity = model.isSectionEnabled ? 1.0 : 0.3
    }
}
