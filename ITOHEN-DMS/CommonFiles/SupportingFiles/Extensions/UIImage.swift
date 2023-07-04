//
//  UIImage.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

extension UIImage {
    func redraw(size: CGSize?, tintColor: UIColor? = nil) -> UIImage{
        if size == nil{
            return self
        }
        let drawImage = UIGraphicsImageRenderer(size: size!).image { _ in
            self.draw(in: CGRect(x: 0, y: 0, width: size!.width, height: size!.height))
        }

        if tintColor != nil{
            if #available(iOS 13.0, *) {
                return drawImage.withTintColor(tintColor ?? .white)
            } else {
                // Fallback on earlier versions
                return drawImage
            }
        }else{
            return drawImage
        }
    }

}
