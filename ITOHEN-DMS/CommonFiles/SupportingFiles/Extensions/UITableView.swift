//
//  UITableView.swift
//  IDAS iOS
//
//  Created by Divakar Murugesh on 27/08/21.
//

import UIKit

extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    /// Update EMpty row
    func updateNumberOfRow(_ count: Int) -> Int {
        if count == 0 {
            setEmptyView()
        } else {
            restore()
        }
        return count
    }
    
    func updateNoDataView(section1: Int, section2: Int) {
        if section1 == 0 && section2 == 0 {
            setEmptyView()
        } else {
            restore()
        }
    }
    
    func setEmptyView() {
        let contentView = UINib(nibName: "NoDataFoundView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? NoDataFoundView
        contentView?.lblTitleText = ""
        self.backgroundView = contentView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
