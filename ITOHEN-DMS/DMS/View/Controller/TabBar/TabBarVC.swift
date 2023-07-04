//
//  TabBarVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class TabBarVC: UIViewController {
    
    @IBOutlet var containerView:UIView!
    @IBOutlet var tabBarView:UIView!
    @IBOutlet var addOrderBackgroundView:UIView!
    @IBOutlet var newOrderLabel:UILabel!
    @IBOutlet var newOrderButton:UIButton!
    @IBOutlet var homeButton:UIButton!
    @IBOutlet var orderListButton:UIButton!
    @IBOutlet var pendingButton:UIButton!
    @IBOutlet var orderStatusButton:UIButton!
    @IBOutlet var tabBarItems:[CustomTabBarItem]!
    
    ///New Design
    @IBOutlet var bottomView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var view1: UIView!
    @IBOutlet var label1: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var view2: UIView!
    @IBOutlet var label2: UILabel!
    @IBOutlet var button2: UIButton!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var view3: UIView!
    @IBOutlet var label3: UILabel!
    @IBOutlet var button3: UIButton!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var view4: UIView!
    @IBOutlet var label4: UILabel!
    @IBOutlet var button4: UIButton!
    @IBOutlet var imageView4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadText),
                                               name: .reloadTabBarVC, object: nil)
    }
    
    func setupUI(){
        self.loadText()
        bottomView.layer.borderWidth = 0.3
        bottomView.layer.borderColor = UIColor.lightGray.cgColor
        self.bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
        self.stackView.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
        
        button1.tag = 1
        button2.tag = 2
        button3.tag = 3
        button4.tag = 4
        [label1, label2, label3, label4].forEach { (theLabel) in
            theLabel?.textAlignment = .center
            theLabel?.font = UIFont.appFont(ofSize: 10.0, weight: .regular)
            theLabel?.textColor = UIColor.init(rgb: 0x7E919B)
            
            if theLabel == label1{
                theLabel?.textColor = .primaryColor()
            }
        }
        
        [button1, button2, button3, button4].forEach { (theButton) in
            theButton?.setTitle("", for: .normal)
            if theButton != button1{
                theButton?.isUserInteractionEnabled = true
            }
        }
        
        [imageView1, imageView2, imageView3, imageView4].forEach { (theImageView) in
            theImageView?.tintColor =  UIColor.init(rgb: 0x7E919B)
            
            if theImageView == imageView1{
                theImageView?.tintColor =  .primaryColor()
            }
        }
        
        self.tabBarButtonTapped(self.button1)
        
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addTaskUpdates.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewTaskUpdates.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOthersTask.rawValue) == true{
            self.button2.isUserInteractionEnabled = true
        }else{
            self.button2.isUserInteractionEnabled = false
        }
        
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addDataInput.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewDataInput.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editDataInput.rawValue) == true{
            self.button3.isUserInteractionEnabled = true
        }else{
            self.button3.isUserInteractionEnabled = false
        }
        
    }
    
    @objc func loadText(){
        label1.text = LocalizationManager.shared.localizedString(key: "homeTitle")
        label2.text = LocalizationManager.shared.localizedString(key: "taskUpdateText")
        label3.text = LocalizationManager.shared.localizedString(key: "dataInputTitleText")
        label4.text = LocalizationManager.shared.localizedString(key: "userSettingText")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.showNavigationBar()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        [label1, label2, label3, label4].forEach { (theLabel) in
            theLabel?.textColor = UIColor.init(rgb: 0x7E919B)
        }
        
        [imageView1, imageView2, imageView3, imageView4].forEach { (theImageView) in
            theImageView?.tintColor =  UIColor.init(rgb: 0x7E919B)
        }
        if sender == view1{
            label1.textColor = .primaryColor()
            imageView1.tintColor =  .primaryColor()
        }else if sender == view2{
            label2.textColor = .primaryColor()
            imageView2.tintColor =  .primaryColor()
        }else if sender == view3{
            label3.textColor = .primaryColor()
            imageView3.tintColor =  .primaryColor()
        }else if sender == view4{
            label4.textColor = .primaryColor()
            imageView4.tintColor =  .primaryColor()
        }
    }
    
    @IBAction func tabBarButtonTapped(_ sender: UIButton){
        [label1, label2, label3, label4].forEach { (theLabel) in
            theLabel?.textColor = UIColor.init(rgb: 0x7E919B)
        }
        
        [imageView1, imageView2, imageView3, imageView4].forEach { (theImageView) in
            theImageView?.tintColor =  UIColor.init(rgb: 0x7E919B)
        }
        
        switch sender.tag {
        case 1:
            label1.textColor = .primaryColor()
            imageView1.tintColor =  .primaryColor()
            ViewEmbedder.embed(
                withIdentifier: "HomeVC", storyBoard: .home, // Storyboard ID
                parent: self,
                container: self.containerView){ vc in
                    // do things when embed complete
                }
        case 2:
            label2.textColor = .primaryColor()
            imageView2.tintColor =  .primaryColor()
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addTaskUpdates.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOthersTask.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewTaskUpdates.rawValue) == true{
                
                ViewEmbedder.embed(
                    withIdentifier: "OrderFilterVC", storyBoard: .home, // Storyboard ID
                    parent: self,
                    container: self.containerView){ vc in
                        if let vcs = vc as? OrderFilterVC{
                            vcs.type = .task
                            vcs.isFromTabBar = true
                            vcs.target = vcs.self
                        }
                    }
            }
        case 3:
            label3.textColor = .primaryColor()
            imageView3.tintColor =  .primaryColor()
            
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addDataInput.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewDataInput.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editDataInput.rawValue) == true{
                
                ViewEmbedder.embed(
                    withIdentifier: "OrderFilterVC", storyBoard: .home, // Storyboard ID
                    parent: self,
                    container: self.containerView){ vc in
                        // do things when embed complete
                        
                        if let vcs = vc as? OrderFilterVC{
                            vcs.type = .dataInput
                            vcs.isFromTabBar = true
                            vcs.target = vcs.self
                        }
                    }
            }
            
        case 4:
            label4.textColor = .primaryColor()
            imageView4.tintColor =  .primaryColor()
            ViewEmbedder.embed(
                withIdentifier: "UserSettingsVC", storyBoard: .userManagement, // Storyboard ID
                parent: self,
                container: self.containerView){ vc in
                    // do things when embed complete
                    if let vcs = vc as? UserSettingsVC{
                        vcs.isFromTabBar = true
                    }
                }
        default:
            return
        }
        
    }
}
