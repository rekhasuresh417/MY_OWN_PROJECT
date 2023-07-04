//
//  UIStoryboard.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation
import UIKit

extension UIStoryboard{
    
    static var main: UIStoryboard {
        return UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    }
    
    static var home: UIStoryboard {
        return UIStoryboard(name: StoryboardName.home.rawValue, bundle: nil)
    }
    
    static var tabBar: UIStoryboard {
        return UIStoryboard(name: StoryboardName.tabBar.rawValue, bundle: nil)
    }
    
    static var orderInfo: UIStoryboard {
        return UIStoryboard(name: StoryboardName.orderInfo.rawValue, bundle: nil)
    }
    
    static var orderList: UIStoryboard {
        return UIStoryboard(name: StoryboardName.orderList.rawValue, bundle: nil)
    }
    
    static var orderStatus: UIStoryboard {
        return UIStoryboard(name: StoryboardName.orderStatus.rawValue, bundle: nil)
    }
    
    static var pendingTask: UIStoryboard {
        return UIStoryboard(name: StoryboardName.pendingTask.rawValue, bundle: nil)
    }
    
    static var userManagement: UIStoryboard {
        return UIStoryboard(name: StoryboardName.userManagement.rawValue, bundle: nil)
    }
    
    static var inquiry: UIStoryboard {
        return UIStoryboard(name: StoryboardName.inquiry.rawValue, bundle: nil)
    }
    
    static var fabric: UIStoryboard {
        return UIStoryboard(name: StoryboardName.fabric.rawValue, bundle: nil)
    }
}

enum StoryboardName: String{
    case main = "Main"
    case home = "Home"
    case tabBar = "TabBar"
    case orderInfo = "OrderInfo"
    case orderList = "OrderList"
    case orderStatus = "OrderStatus"
    case pendingTask = "PendingTask"
    case userManagement = "UserManagement"
    
    case inquiry = "Inquiry"
    case fabric = "Fabric"
    
}
