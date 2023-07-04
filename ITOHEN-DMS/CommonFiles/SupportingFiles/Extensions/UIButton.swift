//
//  UIButton.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

extension UIButton{
    
    func toRoundedWithShadow(){
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
    
    func UnderlineTextButton(title: String) {
        
        let attributedString = NSAttributedString(string: NSLocalizedString(title, comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.appFont(ofSize: 15.0, weight: .medium),
            NSAttributedString.Key.foregroundColor : UIColor.primaryColor(),
            NSAttributedString.Key.underlineStyle:1.0
        ])
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
