//
//  ConcernedMembersTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 25/01/21.
//

import UIKit

class ConcernedMembersTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var tickMarkButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.nameLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
        
        self.tickMarkButton.backgroundColor = .clear
        self.tickMarkButton.setImage(nil, for: .normal)
        self.tickMarkButton.layer.borderWidth = 1.0
        self.tickMarkButton.layer.borderColor = UIColor.init(rgb: 0x434343, alpha: 1.0).cgColor
        self.tickMarkButton.layer.cornerRadius = 5.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContent(data:Contact,isSelectedRow:Bool){
        self.nameLabel.text = data.contactName
        self.tickMarkButton.tag = Int(data.id) ?? 0
        self.enableOrDisableTickMark(isEnable: isSelectedRow)
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
