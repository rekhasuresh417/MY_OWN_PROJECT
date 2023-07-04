//
//  TaskAddCategoryTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 23/01/21.
//

import UIKit

class TaskAddCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var addCategoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.mainView.backgroundColor = .clear
        
        self.addCategoryButton.backgroundColor = .primaryColor(withAlpha: 0.3)
        self.addCategoryButton.layer.cornerRadius = self.addCategoryButton.frame.height / 2.0
        self.addCategoryButton.setTitle(LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "addNewCategoryText"), for: .normal)
        self.addCategoryButton.setTitleColor(.primaryColor(), for: .normal)
        self.addCategoryButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContent(target:TaskInputVC?){
        self.addCategoryButton.addTarget(target, action: #selector(target?.addNewCategoryButtonTapped(_:)), for: .touchUpInside)
    }
}
