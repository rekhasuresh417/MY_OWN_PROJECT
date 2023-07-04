//
//  WorkspaceTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 13/01/21.
//

import UIKit

class WorkspaceTableViewCell: UITableViewCell {

    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var userTypeLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userImageBgView: UIView!
    @IBOutlet var separatorLabel: UILabel!
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        self.userImageView.contentMode = .scaleAspectFit
        self.userImageView.tintColor = .white
        
        self.userImageBgView.layer.cornerRadius =  self.userImageBgView.frame.width / 2.0
        self.userImageBgView.backgroundColor = UIColor.init(rgb: 0x53536A)
        
        self.companyNameLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.companyNameLabel.textColor = .customBlackColor()
        self.companyNameLabel.textAlignment = .left
        self.companyNameLabel.numberOfLines = 1
        self.companyNameLabel.sizeToFit()
        
        self.userTypeLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.userTypeLabel.textColor = UIColor.init(rgb: 0x929292)
        self.userTypeLabel.textAlignment = .left
        self.userTypeLabel.numberOfLines = 1
        self.userTypeLabel.sizeToFit()
        
        self.countLabel.layer.cornerRadius =  self.countLabel.frame.width / 2.0
        self.countLabel.layer.masksToBounds = true
        self.countLabel.font = UIFont.appFont(ofSize: 10.0, weight: .regular)
        self.countLabel.backgroundColor = UIColor.init(rgb: 0x929292)
        self.countLabel.textColor = .white
        self.countLabel.textAlignment = .center
        self.countLabel.numberOfLines = 1
       // self.countLabel.isHidden = true // Later
        
        self.separatorLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyNameLabel.text = nil
        self.companyNameLabel.attributedText = nil
    }
    
    func setContent(data:DMSWorkspaceData, row:Int, target:WorkspaceVC?){
       self.separatorLabel.isHidden = false // row == 0 ? false : true
        self.companyNameLabel.text = data.workspaceTitle.capitalizedFirstLetter//.capitalized
        
        self.companyNameLabel.textColor =  self.appDelegate().userDetails.currentWorkspace?.workspaceTitle == data.workspaceTitle ? .primaryColor() : .customBlackColor()
        self.userTypeLabel.text = target?.getUserRoleForId(id: data.contactRole)
        if data.notifyCount.count>1 {
            self.countLabel.text = data.notifyCount
        }else {
            self.countLabel.text = "0\(data.notifyCount)"
        }
        
        if data.workspaceType == "1"{
            self.userImageView.image = Config.Images.shared.getImage(imageName: Config.Images.buyerIcon)
        }else if data.workspaceType == "3"{
            self.userImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
        }else if data.workspaceType == "2"{
            self.userImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
        }
    }
}
