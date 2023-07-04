//
//  ProductionSKUCollectionViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 26/10/22.
//

import UIKit
import MaterialComponents

class ProductionSKUCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var sizeTextField: MDCOutlinedTextField!{
        didSet { sizeTextField?.addDoneCancelToolbar() }
    }
    var basicInfoData: Basic?
    
    var colorId:String = "0"
    var colorName:String = "0"
    var sizeId:String = "0"
    var isView: Bool = false
    var sizeModel: SizeModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.backgroundColor = .clear

        self.sizeTextField.textAlignment = .left
        self.sizeTextField.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.sizeTextField.textColor = .customBlackColor()
        self.sizeTextField.keyboardType = .numberPad
   
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.sizeTextField.text = ""
        self.sizeTextField.backgroundColor = UIColor.white
    }
    
    func setContent(colorId: String, colorName: String, model: SizeModel, target: UIViewController?){
        target?.addDoneButtonOnKeyboard(textField: self.sizeTextField)
        self.setup(sizeTextField, placeholderLabel: "Size - \(model.sizeName)")
        if let hasCount = Int(model.skuQuantityOfSize), hasCount != 0{ // Dont show 0 in sizeTextField if it has 0 value
            self.sizeTextField.text = "\(hasCount)"
        }
        self.sizeTextField.isUserInteractionEnabled = isView ? false : true
        self.sizeTextField.backgroundColor = isView ? UIColor.lightText : UIColor.white
      
        self.sizeModel = model
        self.colorId = colorId
        self.colorName = colorName
        self.sizeId = model.sizeId
    }
    
}
