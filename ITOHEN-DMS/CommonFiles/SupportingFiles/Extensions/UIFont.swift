//
//  UIFont.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation
import UIKit

extension UIFont{
    
    class func appFont(ofSize fontSize: CGFloat) -> UIFont{
        if let customFont = UIFont.init(name: Config.Font.appFontMedium, size: fontSize){
            return customFont
        }
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func appFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont{
        var fontWeight:String = Config.Font.appFontRegular
        if weight == .medium{
            fontWeight = Config.Font.appFontMedium
        }else if weight == .bold{
            fontWeight = Config.Font.appFontSemiBold
        }
        if let customFont = UIFont.init(name: fontWeight, size: fontSize){
            return customFont
        }
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}

