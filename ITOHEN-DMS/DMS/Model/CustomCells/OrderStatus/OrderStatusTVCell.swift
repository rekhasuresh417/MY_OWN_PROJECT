//
//  OrderStatusTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 15/02/21.
//

import UIKit

class OrderStatusTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var headerView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var titleImageView:UIImageView!
    @IBOutlet var titleView:UIView!
    @IBOutlet var styleLabel:UILabel!
    @IBOutlet var delayedTaskLabel:UILabel!
    @IBOutlet var viewLabel:UILabel!
    @IBOutlet var tableView:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.mainView.backgroundColor = .clear
        self.mainView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        self.headerView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        headerView.backgroundColor = .primaryColor()
        self.titleView.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
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
        
        styleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderStatusVC", key2: "style")
        delayedTaskLabel.text = LocalizationManager.shared.localizedString(key1: "OrderStatusVC", key2: "delayedTask")
        viewLabel.text = LocalizationManager.shared.localizedString(key1: "OrderStatusVC", key2: "view")
        [styleLabel,delayedTaskLabel,viewLabel].forEach { (label) in
            label?.font = .appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
        }
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        titleImageView.image = nil
        tableView.dataSource = nil
        tableView.reloadData()
    }
    
    func setContent(data:DMSGetOrderStatusData, indexSection:Int, target:OrderStatusVC?){
        titleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
        titleLabel.text = data.factoryName
        
        self.tableView.tag = indexSection
        self.tableView.dataSource = target
        self.tableView.delegate = target
    }
}
