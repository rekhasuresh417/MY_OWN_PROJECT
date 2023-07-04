//
//  UserListTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 09/02/21.
//

import UIKit

class UserListTVCell: UITableViewCell {
    
    @IBOutlet var thumbLabel:UILabel!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var roleLabel:UILabel!
    @IBOutlet var statusLabel:UILabel!
    @IBOutlet var editButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.thumbLabel.layer.cornerRadius =  self.thumbLabel.frame.width / 2.0
        self.thumbLabel.layer.masksToBounds = true
        self.thumbLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.thumbLabel.backgroundColor = UIColor.init(rgb: 0xFF6363, alpha: 0.2)
        self.thumbLabel.textColor = UIColor.init(rgb: 0xFF6363, alpha: 1.0)
        self.thumbLabel.textAlignment = .center
        self.thumbLabel.numberOfLines = 1
        self.thumbLabel.adjustsFontSizeToFitWidth = true
        
        self.nameLabel.font = .appFont(ofSize: 14.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        self.roleLabel.font = .appFont(ofSize: 12.0, weight: .regular)
        self.roleLabel.textColor = UIColor.init(rgb: 0x727272)
        self.roleLabel.textAlignment = .left
        self.roleLabel.numberOfLines = 1
        
        self.statusLabel.font = .appFont(ofSize: 10.0, weight: .regular)
        self.statusLabel.textAlignment = .center
        self.statusLabel.numberOfLines = 1
        self.statusLabel.backgroundColor = .clear
        self.statusLabel.layer.cornerRadius = self.statusLabel.frame.height / 2.0
        self.statusLabel.layer.borderWidth = 1.0
        self.statusLabel.adjustsFontSizeToFitWidth = true
        
        self.editButton.tintColor = .lightGray
        self.editButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.editIcon), for: .normal)
        self.editButton.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbLabel.text = ""
        self.nameLabel.text = ""
        self.roleLabel.text = ""
        self.statusLabel.text = ""
    }
    
    func setContent(data:PartnerContactsData, target:UserManagementVC?){
        self.editButton.tag = Int(data.id) ?? 0
        self.editButton.addTarget(target, action: #selector(target?.editButtonTapped(_:)), for: .touchUpInside)
        self.nameLabel.text = data.contactName
        self.thumbLabel.text = self.getThumbName(name: data.contactName)
        self.roleLabel.text = target?.getUserRoleForId(id: data.contactRole)
        if data.contactInactive == "0"{
            self.statusLabel.text = LocalizationManager.shared.localizedString(key1: "UserManagement", key2: "activeStatusText")
            self.statusLabel.textColor = UIColor.init(rgb: 0x4FB463)
            self.statusLabel.layer.borderColor = UIColor.init(rgb: 0x4FB463).cgColor
        }else{
            self.statusLabel.text = LocalizationManager.shared.localizedString(key1: "UserManagement", key2: "inActiveStatusText")
            self.statusLabel.textColor = UIColor.init(rgb: 0xFF6363)
            self.statusLabel.layer.borderColor = UIColor.init(rgb: 0xFF6363).cgColor
        }
    }
}
