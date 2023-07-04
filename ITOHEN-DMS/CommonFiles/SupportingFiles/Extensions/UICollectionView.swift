//
//  UICollectionView.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 19/08/22.
//

import UIKit
import MaterialComponents

extension UICollectionViewCell {
    func setup(_ textField: MDCOutlinedTextField, placeholderLabel: String) {
        
        textField.label.text = placeholderLabel
        textField.placeholder = ""
        
        textField.tintColor = .primaryColor()
        
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.primaryColor(), for: .editing)
        
        textField.setFloatingLabelColor(.lightGray, for: .normal)
        textField.setFloatingLabelColor(.primaryColor(), for: .editing)
        
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.primaryColor(), for: .editing)
        
        textField.setTextColor(.customBlackColor(), for: .normal)
        textField.setTextColor(.customBlackColor(), for: .editing)
    }
}
