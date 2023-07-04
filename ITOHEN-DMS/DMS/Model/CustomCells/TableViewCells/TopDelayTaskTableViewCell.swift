//
//  TopDelayTaskTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class TopDelayTaskTableViewCell: UITableViewCell {
  
    @IBOutlet var orderNoTitleLabel: UILabel!
    @IBOutlet var orderNoLabel: UILabel!
    @IBOutlet var noOfDelayTitleLabel: UILabel!
    @IBOutlet var noOfDelayLabel: UILabel!
    @IBOutlet var taskNameTitleLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var picTitleLabel: UILabel!
    @IBOutlet var picLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        noOfDelayLabel.textColor = .delayedColor()
        orderNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "orderAndStyleNoText")
        noOfDelayTitleLabel.text = LocalizationManager.shared.localizedString(key: "noOfDaysDelayedText")
        taskNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "taskNameText")
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
      
    }
    
    func setTaskContent(data: DMSTopTaskDelay){
        orderNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "orderAndStyleNoText")
        noOfDelayTitleLabel.text = LocalizationManager.shared.localizedString(key: "noOfDaysDelayedText")
        taskNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "taskNameText")
        picTitleLabel.text = LocalizationManager.shared.localizedString(key: "picTitle")
        
        orderNoLabel.text = "\(data.orderNo ?? "") / \(data.styleNo ?? "")"
        noOfDelayLabel.text = "\(abs(data.noOfDays ?? 0))"
        taskNameLabel.text = data.taskTitle
        picLabel.text = "\(data.staffName ?? "")"
    }
    
    func setProdContent(data: DMSTopProdDelay){
        orderNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "orderAndStyleNoText")
        noOfDelayTitleLabel.text = LocalizationManager.shared.localizedString(key: "noOfDaysDelayedText")
        taskNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "taskNameText")
        
        orderNoLabel.text = "\(data.orderNo ?? "") / \(data.styleNo ?? "")"
        noOfDelayLabel.text = "\(abs(data.delay ?? 0))"
        if data.typeOfProduction == Config.Text.cut{
            taskNameLabel.text = LocalizationManager.shared.localizedString(key: "cuttingText")
        }else if data.typeOfProduction == Config.Text.sew{
            taskNameLabel.text = LocalizationManager.shared.localizedString(key: "sewingText")
        }else{
            taskNameLabel.text = LocalizationManager.shared.localizedString(key: "packingText")
        }
    }
}
