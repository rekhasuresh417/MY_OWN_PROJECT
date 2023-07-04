//
//  ProfileTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 21/01/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var subTitleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white

        
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        subTitleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        subTitleLabel.textColor = .primaryColor()
        subTitleLabel.textAlignment = .right
        subTitleLabel.numberOfLines = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.subTitleLabel.text = ""
    }
    
    func setContent(target: UIViewController? = nil, data:ProfileItems){
        self.titleLabel.text = data.title
        self.accessoryType =  data.type == .language ? .disclosureIndicator : .none
        if data.type == .language{
            self.subTitleLabel.text = "EN"
            let id = target?.appDelegate().defaults.integer(forKey: Config.Text.preferredLanguageKey)
            if id ?? 0 > 0{
               // self.subTitleLabel.text = LocalizationManager.shared.shortLanguageNames[id - 1]
            }
        }else{
            self.subTitleLabel.text = ""
        }
    }
}
