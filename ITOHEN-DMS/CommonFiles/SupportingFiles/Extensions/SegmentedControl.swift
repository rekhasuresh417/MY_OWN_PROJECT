//
//  SegmentedControl.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 11/01/22.
//

import UIKit

extension UISegmentedControl {
    
    /// Tint color doesn't have any effect on iOS 13.
    func applySegmentStyle() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.white
            self.layer.borderColor = UIColor.primaryColor().cgColor
            self.selectedSegmentTintColor = .primaryColor()
            self.layer.borderWidth = 1
            
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor()]
            self.setTitleTextAttributes(titleTextAttributes, for:.normal)
            
            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        } else {
            // Fallback on earlier versions
        }
    }
}
