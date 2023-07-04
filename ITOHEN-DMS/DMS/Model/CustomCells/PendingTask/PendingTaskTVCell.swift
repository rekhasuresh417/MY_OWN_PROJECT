//
//  PendingTaskTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 15/02/21.
//

import UIKit

class PendingTaskTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var headerView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var titleImageView:UIImageView!
    @IBOutlet var tableView:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.mainView.backgroundColor = .white
        self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
        self.headerView.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        headerView.backgroundColor = .primaryColor()
        self.mainView.layer.borderWidth = 1.0
        self.mainView.layer.borderColor = UIColor.init(rgb: 0x707070, alpha: 0.2).cgColor
        self.tableView.isScrollEnabled = false
        
        titleLabel.font = .appFont(ofSize: 14.0, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleImageView.tintColor = .white
        titleImageView.contentMode = .scaleAspectFit
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        titleImageView.image = nil
        tableView.dataSource = nil
        tableView.reloadInputViews()
        tableView.reloadData()
    }
    
    func setContent(data:DMSGetPendingTasksData, indexSection:Int, target:PendingTaskVC?){
        self.tableView.tag = indexSection
        self.tableView.dataSource = target
        self.tableView.delegate = target
        
        titleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
        titleLabel.text = data.factory
    }
}
