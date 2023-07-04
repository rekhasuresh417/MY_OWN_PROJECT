//
//  UIApplication.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//


import Foundation
import UIKit

extension UIApplication {

    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? ""
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? ""
    }
    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "MinimumOSVersion") as! String? ?? ""
    }
    class func isFirstLaunch() -> Bool {
        if UserDefaults.standard.bool(forKey: Config.Text.hasLaunchedKey) {
            return false
        }
        return true
    }
    
    class func firstTimeLaunched() {
        UserDefaults.standard.set(true, forKey: Config.Text.hasLaunchedKey)
    }

}

