//
//  CustomTableView.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

/// This class used for tableview inside tableview cells functionality.
/// This helps to load dynamic cells height without calculating heightForRow in main class.

import UIKit

class CustomTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
