//
//  LanguageTVCell.swift
//  IDAS iOS
//
// Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class LanguageTVCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tickmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.mainView.layer.cornerRadius = 5.0
        self.mainView.backgroundColor = .primaryColor(withAlpha: 0.1)
        
        self.tickmarkImageView.tintColor = .primaryColor()
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainView.layer.borderWidth = 0.5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flagImageView.image = nil
        self.nameLabel.text = ""
        self.tickmarkImageView.image = nil
    }
    
    func setContent(language: Languages, index: Int, target: UIViewController) {
        self.flagImageView.image = UIImage.init(named: Config.AppLanguages[index].flag) //index == 0 || index == 1 ? UIImage.init(named: Config.AppLanguages[index].flag) : UIImage.init(named: "")
        self.nameLabel.text = language.name
    
        if language.lang_code == RMConfiguration.shared.language {
            self.tickmarkImageView.image = UIImage.init(named: "ic_checkmark")
            self.mainView.layer.borderColor = UIColor.primaryColor().cgColor
        } else {
            self.tickmarkImageView.image = nil
            self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        }
//
//        if index == 1{
//            self.flagImageView.addshadow(shadowRadius: 0.5,
//                                          shadowOpacity: 0.2)
//        }else{
//            self.flagImageView.layer.shadowOpacity = 0.0
//        }
    }
}
