//
//  NoDataFoundView.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 11/03/23.
//

import UIKit

class NoDataFoundView: UIView {
    
    @IBOutlet var noResultImageView: UIImageView!
    @IBOutlet var noResultLabel: UILabel!
    
    @IBInspectable var lblTitleText : String?{
        get{
            return noResultLabel.text
        }
        set(lblTitleText)
        {
            noResultLabel.text = LocalizationManager.shared.localizedString(key: "noResultFoundText")
        }
    }
}
