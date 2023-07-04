//
//  TaskUpdateInfoTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 20/01/21.
//

import UIKit

class TaskUpdateInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var buyerLabel:UILabel!
    @IBOutlet var buyerValueLabel:UILabel!
    @IBOutlet var factoryLabel:UILabel!
    @IBOutlet var factoryValueLabel:UILabel!
    @IBOutlet var pcuLabel:UILabel!
    @IBOutlet var pcuValueLabel:UILabel!
    @IBOutlet var orderNoLabel:UILabel!
    @IBOutlet var orderNoValueLabel:UILabel!
    @IBOutlet var styleNoLabel:UILabel!
    @IBOutlet var styleNoValueLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = .clear
        self.mainView.backgroundColor = .white
        self.roundCorners(corners: .allCorners, radius: 8.0)
        self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
        self.mainView.layer.borderWidth = 1.0
        self.mainView.layer.borderColor = UIColor.customBlackColor(withAlpha: 0.2).cgColor
    
        [buyerLabel,factoryLabel,pcuLabel,orderNoLabel,styleNoLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = .lightGray
            label?.textAlignment = .left
            label?.numberOfLines = 1
            
            if label == buyerLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "buyerText")
            }else if label == factoryLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "factoryText")
            }else if label == pcuLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "productionControlText")
            }else if label == orderNoLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "orderNoText")
            }else if label == styleNoLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "styleNoText")
            }
        }
        
        [buyerValueLabel,factoryValueLabel,pcuValueLabel,orderNoValueLabel,styleNoValueLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .left
            label?.numberOfLines = 1
        }
    }
    
    func setContent(model:Basic?){
        if let data = model{
            self.buyerValueLabel.text = data.buyerName
            self.factoryValueLabel.text = data.factoryName
            self.pcuValueLabel.text = data.pcuName
            self.orderNoValueLabel.text = data.orderNo
            self.styleNoValueLabel.text = data.styleNo
        }
    }
}
