//
//  SubTaskUpdateContentTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 03/01/23.
//

import UIKit

class SubTaskUpdateContentTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var subTaskaskTableView: UITableView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.mainView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8.0)

        self.subTaskaskTableView.backgroundColor = .clear
        self.subTaskaskTableView.separatorStyle = .none
        self.subTaskaskTableView.isScrollEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.subTaskaskTableView.dataSource = nil
        self.subTaskaskTableView.reloadInputViews()
        self.subTaskaskTableView.reloadData()
    }
    
    func setContent(indexSection:Int, target:TaskUpdateVC?){
        self.subTaskaskTableView.tag = indexSection
        self.subTaskaskTableView.dataSource = target
        self.subTaskaskTableView.delegate = target
    }
}
