//
//  Color.swift
//  MoomiSleepMonitor
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation
import UIKit

 extension UIColor{
    
    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

extension UIColor{
    
    class func primaryColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return (UIColor(named: "primaryColor") ?? .white).withAlphaComponent(withAlpha)
    }
    
    class func secondaryColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return (UIColor(named: "secondaryColor") ?? .white).withAlphaComponent(withAlpha)
    }
    
    class func customBlackColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x000000, alpha: withAlpha) //0x333333
    }
    
    class func cellCurrentDateBackgroundColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xFFFADC, alpha: withAlpha) //0x333333
    }
    
    class func snobChatDefaultColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x545454, alpha: withAlpha)
    }
    
    // Delayed Color
    class func delayedColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xEE335E, alpha: withAlpha) // old - FF3838
    }
    
    class func delyCompletionColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xE69020, alpha: withAlpha)
    }
    
    class func completedColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x26A69A, alpha: withAlpha)
    }
    
    class func snobChatDelyCompletionColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xFEC901, alpha: withAlpha)
    }
    
    class func snobChatCompletedColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x009688, alpha: withAlpha)
    }
    
    class func snobChatInitialColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xE5E5EA, alpha: withAlpha)
    }
    
    class func inProgressColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xC7D0DD, alpha: withAlpha)
    }
    
    class func yetToStartColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xE8EFF0, alpha: withAlpha)
    }
    
    class func targetTaskColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x458C41, alpha: withAlpha)// 016901
    }
    
    class func actualTaskColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x9CC450, alpha: withAlpha) // old 9BC34F
    }
    
    class func excessTaskColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xC4A950, alpha: withAlpha)
    }
    
    class func weekOffColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0x4C4848, alpha: withAlpha)
    }
    
    class func appBackgroundColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xF5F7FA, alpha: withAlpha)
    }
    
    class func appLightColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return UIColor.init(rgb: 0xE4E4E4, alpha: withAlpha)
    }
    
    // Inquiry
    class func inquiryPrimaryColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return (UIColor(named: "inquiryPrimaryColor") ?? .white).withAlphaComponent(withAlpha)
    }
    
    // Fabric
    class func fabricPrimaryColor(withAlpha:CGFloat = 1.0) -> UIColor{
        return (UIColor(named: "fabricPrimaryColor") ?? .white).withAlphaComponent(withAlpha)
    }
}

