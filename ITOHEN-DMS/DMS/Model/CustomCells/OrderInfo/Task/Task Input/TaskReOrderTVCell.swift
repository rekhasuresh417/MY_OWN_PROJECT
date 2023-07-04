//
//  TaskReOrderTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 29/03/21.
//

import UIKit

class TaskReOrderTVCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var reOrderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.mainView.backgroundColor = .clear
        self.reOrderButton.tintColor = .customBlackColor()
        self.reOrderButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.reOrderIcon), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContent(target:TaskInputVC?){
        self.reOrderButton.addTarget(target, action: #selector(target?.categoryAlignmentButtonTapped(_:)), for: .touchUpInside)
    }
}
