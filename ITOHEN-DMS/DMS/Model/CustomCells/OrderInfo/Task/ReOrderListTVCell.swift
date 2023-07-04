//
//  ReOrderListTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 29/03/21.
//

import UIKit

class ReOrderListTVCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .appBackgroundColor()
        
        self.nameLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
    }
    
    func setContent(data:TaskTemplateStructure){
        self.nameLabel.text = data.categoryTitle
    }
    
    func setContent(data:TaskTemplateStructureDatum){
        self.nameLabel.text = data.taskTitle
    }
}
