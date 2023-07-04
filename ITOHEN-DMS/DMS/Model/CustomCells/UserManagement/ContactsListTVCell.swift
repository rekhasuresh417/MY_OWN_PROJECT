//
//  ContactsListTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 09/02/21.
//

import UIKit

class ContactsListTVCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var arrowButton:UIButton!
    @IBOutlet var factoryEditButton: UIButton!
    @IBOutlet var pcuEditButton: UIButton!
    var userManagementStoryBoard: UIStoryboard {
        return UIStoryboard(name: "UserManagement", bundle: nil)
    }
    var userManagementVC:UserManagementVC?
    var selectedType: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.nameLabel.font = .appFont(ofSize: 14.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        
        self.arrowButton.tintColor = .customBlackColor()
        self.arrowButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.rightArrowIcon), for: .normal)
        self.arrowButton.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
    }
    
    func setContent(data:ContactsData, target:UserManagementVC?){
        self.arrowButton.addTarget(target, action: #selector(target?.arrowButtonTapped(_:)), for: .touchUpInside)
        self.nameLabel.text = data.companyTitle
        self.arrowButton.tag = Int(data.id) ?? 0
     }
}
