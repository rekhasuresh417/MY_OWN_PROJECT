//
//  WorkspaceTableViewCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
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
        self.countLabel.isHidden = true // Later
        
        self.separatorLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyNameLabel.text = nil
        self.companyNameLabel.attributedText = nil
    }
    
    func setContent(data: DMSWorkspaceList, row:Int, target:WorkspaceVC?){
       self.separatorLabel.isHidden = false // row == 0 ? false : true
        self.companyNameLabel.text = data.workspaceName ?? ""

        self.companyNameLabel.textColor =  RMConfiguration.shared.workspaceName == data.workspaceName ? .primaryColor() : .customBlackColor()
        self.userTypeLabel.text = data.role
//        if data.notifyCount.count>1 {
//            self.countLabel.text = data.notifyCount
//        }else {
//            self.countLabel.text = "0\(data.notifyCount)"
//        }
        
        if data.workspaceType == Config.Text.buyer{
            self.userImageView.image = Config.Images.shared.getImage(imageName: Config.Images.buyerIcon)
        }else if data.workspaceType == Config.Text.factory{
            self.userImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
        }else if data.workspaceType == Config.Text.pcu{
            self.userImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
        }
    }
}
