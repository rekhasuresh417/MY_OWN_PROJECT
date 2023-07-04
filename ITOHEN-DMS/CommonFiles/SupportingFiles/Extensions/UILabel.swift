//
//  UILabel.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 07/02/23.
//

import Foundation

extension UILabel {

    func startBlink() {
        UIView.animate(withDuration: 0.8,
              delay:0.0,
              options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
              animations: { self.alpha = 0 },
              completion: nil)
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
