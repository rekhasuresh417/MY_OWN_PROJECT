//
//  UITextView.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 09/08/22.
//

import UIKit

extension UITextView {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                            style: .plain,
                            target: onCancel.target,
                            action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: self,
                            action: nil),
            UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                            style: .done,
                            target: onDone.target,
                            action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    
}
