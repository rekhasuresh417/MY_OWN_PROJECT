//
//  ContactListTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet var thumbLabel:UILabel!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet var tickMarkButton:UIButton!
    
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
        self.thumbLabel.sizeToFit()
        
        self.nameLabel.font = UIFont.appFont(ofSize: 14.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
        
        self.companyNameLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.companyNameLabel.textColor = .gray
        self.companyNameLabel.textAlignment = .left
        self.companyNameLabel.numberOfLines = 1
        self.companyNameLabel.sizeToFit()
        
        self.tickMarkButton.backgroundColor = .clear
        self.tickMarkButton.setImage(nil, for: .normal)
        self.tickMarkButton.layer.borderWidth = 1.0
        self.tickMarkButton.layer.borderColor = UIColor.init(rgb: 0x434343, alpha: 1.0).cgColor
        self.tickMarkButton.layer.cornerRadius = 5.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContent(data:Contact,displayType:ContactDisplayType, isSelectedRow:Bool){
        
        self.tickMarkButton.isHidden = displayType == .view ? true : false
        self.nameLabel.text = data.contactName
        self.companyNameLabel.text = data.partnerTitle
        self.thumbLabel.text = self.getThumbName(name: data.contactName)
        self.tickMarkButton.tag = Int(data.id) ?? 0
        self.enableOrDisableTickMark(isEnable: isSelectedRow)
        self.tickMarkButton.isUserInteractionEnabled = data.contactRole == "1" ? false : true
        if data.contactRole == "1" {
            self.tickMarkButton.backgroundColor = .gray
            self.tickMarkButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.tickIcon), for: .normal)
            self.tickMarkButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        
    }
    
    func enableOrDisableTickMark(isEnable:Bool){
        if isEnable{
            self.tickMarkButton.layer.borderColor = UIColor.clear.cgColor
            self.tickMarkButton.backgroundColor = .primaryColor()
            self.tickMarkButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.tickIcon), for: .normal)
            self.tickMarkButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }else{
            self.tickMarkButton.layer.borderColor = UIColor.init(rgb: 0x434343, alpha: 1.0).cgColor
            self.tickMarkButton.backgroundColor = .clear
            self.tickMarkButton.setImage(nil, for: .normal)
        }
    }
}
