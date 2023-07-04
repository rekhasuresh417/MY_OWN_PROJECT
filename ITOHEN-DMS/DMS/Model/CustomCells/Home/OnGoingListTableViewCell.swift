//
//  OnGoingListTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 11/01/21.
//

import UIKit

class OnGoingListTableViewCell: UITableViewCell {
    
    @IBOutlet var firstImageBackgrondView:UIView!
    @IBOutlet var firstLabel:UILabel!
    @IBOutlet var secondLabel:UILabel!
    @IBOutlet var orderNoLabel:UILabel!
    @IBOutlet var firstImageView:UIImageView!
    @IBOutlet var secondImageView:UIImageView!
    @IBOutlet var rightArrowImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.firstImageBackgrondView.layer.cornerRadius =  self.firstImageBackgrondView.frame.width / 2.0
        self.firstImageBackgrondView.backgroundColor = UIColor.init(rgb: 0xE2DFFF)
        
        self.firstImageView.tintColor = UIColor.init(rgb: 0x7C71F8)
        self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
        self.firstImageView.contentMode = .scaleAspectFit
        
        self.secondImageView.contentMode = .scaleAspectFit
        self.secondImageView.tintColor = UIColor.init(rgb: 0x7B7B7B)
        self.secondImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
        
        self.rightArrowImageView.tintColor = UIColor.init(rgb: 0x9A9CB8)
        self.rightArrowImageView.contentMode = .scaleAspectFit
        self.rightArrowImageView.image = Config.Images.shared.getImage(imageName: Config.Images.rightArrowIcon)
        
        self.firstLabel.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
        self.firstLabel.textColor = .customBlackColor()
        self.firstLabel.textAlignment = .left
        self.firstLabel.numberOfLines = 1
        self.firstLabel.sizeToFit()
        
        self.secondLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.secondLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.secondLabel.textAlignment = .left
        self.secondLabel.numberOfLines = 1
        self.secondLabel.sizeToFit()
        
        self.orderNoLabel.font = UIFont.appFont(ofSize: 10.0, weight: .regular)
        self.orderNoLabel.textColor = UIColor.init(rgb: 0x7B7B7B)
        self.orderNoLabel.textAlignment = .left
        self.orderNoLabel.numberOfLines = 1
        self.orderNoLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstLabel.text = ""
        self.secondLabel.text = ""
        self.orderNoLabel.text = ""
        self.firstImageView.image = nil
        self.secondImageView.image = nil
        self.firstImageBackgrondView.backgroundColor = .clear
    }
    
    func setContent(data:DMSGetOrderListData, target:UIViewController?){
        self.orderNoLabel.text = data.orderNo
        
        if target?.appDelegate().userDetails.userType == .buyer{
            
            self.firstLabel.text = data.factoryName
            self.firstImageBackgrondView.backgroundColor = UIColor.init(rgb: 0xE2DFFF)
            self.firstImageView.tintColor = UIColor.init(rgb: 0x7C71F8)
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
            
            if (data.pcuName ?? "").isEmptyOrWhitespace(){
                self.secondLabel.isHidden = true
                self.secondImageView.isHidden = true
            }else{
                self.secondLabel.isHidden = false
                self.secondImageView.isHidden = false
                self.secondLabel.text = data.pcuName ?? ""
                self.secondImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
                self.secondImageView.tintColor = UIColor.init(rgb: 0x7B7B7B)
            }
        }else if target?.appDelegate().userDetails.userType == .factory{
            self.firstLabel.text = data.buyerName
            self.firstImageBackgrondView.backgroundColor = UIColor.init(rgb: 0x53536A)
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.buyerIcon)
            self.firstImageView.tintColor = .white
            
            if (data.pcuName ?? "").isEmptyOrWhitespace(){
                self.secondLabel.isHidden = true
                self.secondImageView.isHidden = true
            }else{
                self.secondLabel.isHidden = false
                self.secondImageView.isHidden = false
                self.secondLabel.text = data.pcuName ?? ""
                self.secondImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
                self.secondImageView.tintColor = UIColor.init(rgb: 0x7B7B7B)
            }
            
        }else if target?.appDelegate().userDetails.userType == .pcu{
            
            self.firstLabel.text = data.buyerName
            self.firstImageBackgrondView.backgroundColor = UIColor.init(rgb: 0x53536A)
            self.firstImageView.image = Config.Images.shared.getImage(imageName: Config.Images.buyerIcon)
            self.firstImageView.tintColor = .white
            
            self.secondLabel.text = data.factoryName
            self.secondImageView.tintColor = UIColor.init(rgb: 0x7B7B7B)
            self.secondImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
       
        }
    }
}
