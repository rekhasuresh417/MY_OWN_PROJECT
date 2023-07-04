//
//  TaskFileUploadTVCell.swift
//  IDAS iOS
//
//  Created by Dharma sheelan on 19/11/21.
//

import UIKit

class TaskFileUploadTVCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var target: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
//        self.mainView.layer.cornerRadius = 5
//        self.mainView.backgroundColor = UIColor.init(rgb: 0xE6E6E6)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.mainView.addGestureRecognizer(gesture)
        
        self.titleLabel.textColor = .black
        self.titleLabel.font = .appFont(ofSize: 13.0, weight: .regular)
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = LocalizationManager.shared.localizedString(key: "upload_file_title")
        
        self.iconImageView.image = UIImage.init(named: Config.Images.fileUploadIcon)
      
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
 
    }
    
    func setContent(target: UIViewController? = nil) {
        self.target = target
      
    }
   
    @objc func checkAction(sender : UITapGestureRecognizer) {
        if let vc = self.target as? TaskInputVC {
            vc.uploadFiles()
        }
    }
}
