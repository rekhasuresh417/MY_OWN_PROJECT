//
//  ViewEmbedder.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class ViewEmbedder: NSObject {
    class func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
        
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        child.willMove(toParent: parent)
        
        UIView.transition(with: container, duration: 0.2, options: .showHideTransitionViews, animations: {
            parent.addChild(child)
            container.addSubview(child.view)
            child.didMove(toParent: parent)
        }, completion: nil)
        
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    class func embed(withIdentifier id:String, storyBoard: UIStoryboard?, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        
        let vc = storyBoard?.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc!,
            previous: parent.children.first
        )
        completion?(vc!)
    }
}
