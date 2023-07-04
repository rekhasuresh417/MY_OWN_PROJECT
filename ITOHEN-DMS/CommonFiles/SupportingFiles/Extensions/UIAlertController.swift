//
//  UIAlertController.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation
import UIKit

var alertWindows = [UIAlertController:UIWindow]()

extension UIAlertController {
    
    /// Present alert in top window
    func presentInNewWindow(animated: Bool,
                            completion: (() -> Void)?) {
        
        if alertWindows.count > 0{
            return // alert already presented
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        alertWindows[self] = window // Map window with UIAlertController
        
        window.rootViewController = UIViewController()
        window.windowLevel = .alert + 1
        window.makeKeyAndVisible()
        window.rootViewController!.present(self, animated: animated, completion: completion)
    }
    
    static func showAlert(title:String? = "",
                          message: String,
                          target:UIViewController?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(key: "okButtonText"), style: .cancel, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlertWithCompletionHandler(title:String? = "",
                                               message: String,
                                               target:UIViewController?,
                                               alertCompletionHandler: @escaping (Bool) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationManager.shared.localizedString(key: "okButtonText"), style: .default) { (alert) in
            alertCompletionHandler(true)
        })
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlertWithCompletionHandler(title: String? = nil,
                                               message: String? = nil,
                                               preferredStyle: UIAlertController.Style = .alert,
                                               sourceView: UIView? = nil,
                                               firstButtonTitle: String,
                                               secondButtonTitle: String,
                                               firstButtonStyle: UIAlertAction.Style = .default,
                                               secondButtonStyle: UIAlertAction.Style = .default,
                                               target: UIViewController?,
                                               alertCompletionHandler: @escaping (Int) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: firstButtonTitle, style: firstButtonStyle) { (alert) in
            alertCompletionHandler(0)
        })
        alert.addAction(UIAlertAction(title: secondButtonTitle, style: secondButtonStyle) { (alert) in
            alertCompletionHandler(1)
        })
        
        if preferredStyle == .actionSheet {
            alert.addAction(UIAlertAction(title: LocalizationManager.shared.localizedString(key: "okButtonText"), style: .cancel) { (alert) in
                alertCompletionHandler(2)
            })
        }
        
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popoverPresentationController = alert.popoverPresentationController, sourceView != nil{
                    popoverPresentationController.sourceView = sourceView
                    popoverPresentationController.sourceRect = CGRect(origin: sourceView!.center, size: CGSize(width: 200, height: 200))
                    popoverPresentationController.permittedArrowDirections = [.down]
                }
            }
            target?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlert(title:String? = "", message: String, firstButtonTitle:String, secondButtonTitle:String, target: UIViewController?, alertCompletionHandler: @escaping (Bool) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: firstButtonTitle, style: .default) { (alert) in
            alertCompletionHandler(false)
        })
        
        alert.addAction(UIAlertAction(title: secondButtonTitle, style: .destructive) { (alert) in
            alertCompletionHandler(true)
        })
        
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
}
