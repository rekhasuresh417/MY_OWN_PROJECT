//
//  SKUQuantityCollectionViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 06/01/21.
//

import UIKit
import MaterialComponents

class SKUQuantityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var sizeTextField: MDCOutlinedTextField!{
        didSet { sizeTextField?.addDoneCancelToolbar() }
    }
  //  @IBOutlet var sizeLabel: UILabel!
    
    var colorId:String = "0"
    var sizeId:String = "0"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.backgroundColor = .clear
//        self.mainView.layer.borderWidth = 1.0
//        self.mainView.layer.borderColor = UIColor.customBlackColor().cgColor
//        self.mainView.layer.cornerRadius = 10.0
        
        self.sizeTextField.textAlignment = .left
        self.sizeTextField.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.sizeTextField.textColor = .customBlackColor()
        self.sizeTextField.keyboardType = .numberPad
        
   //     self.setup(sizeTextField, placeholderLabel: LocalizationManager.shared.localizedString(key1: "SKUAddQuantity", key2: "sizeText"))
        
//        sizeLabel.tag = 999
//        sizeLabel.text = LocalizationManager.shared.localizedString(key1: "SKUAddQuantity", key2: "sizeText")
//        sizeLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
//        sizeLabel.textColor = UIColor.init(rgb: 0x727272)
//        sizeLabel.textAlignment = .left
//        sizeLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.sizeTextField.text = ""
        //self.sizeLabel.text = ""
    }
    
    func setContent(colorId:String, model:SizeModel){
       // self.sizeLabel.text = model.sizeName
        self.setup(sizeTextField, placeholderLabel: "Size - \(model.sizeName)")
        if let hasCount = Int(model.skuQuantityOfSize), hasCount != 0{ // Dont show 0 in sizeTextField if it has 0 value
            self.sizeTextField.text = "\(hasCount)"
        }
        self.colorId = colorId
        self.sizeId = model.sizeId
    }
    
    
}
