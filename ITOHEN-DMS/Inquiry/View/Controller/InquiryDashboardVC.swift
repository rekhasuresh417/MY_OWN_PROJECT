//
//  InquiryDashboardVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 20/01/23.
//

import UIKit

class InquiryDashboardVC: UIViewController {

    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var logoImageView:UIImageView!
    @IBOutlet var logoBgView:UIView!
    
    @IBOutlet var inquiryMenuButton: UIButton!
    @IBOutlet var inquiryNotificationButton: UIButton!
    @IBOutlet var screenTittleLabel: UILabel!
    @IBOutlet var notificationCountLabel: UILabel!
    
    @IBOutlet var viewInquiryLabel:UILabel!
    @IBOutlet var imageView1:UIImageView!
    @IBOutlet var viewInquiryButton:UIButton!
    @IBOutlet var viewInquiryBottomLabel:UILabel!
    
    @IBOutlet var factoryResponseLabel:UILabel!
    @IBOutlet var imageView2:UIImageView!
    @IBOutlet var factoryResponseButton:UIButton!
    @IBOutlet var factoryResponseBottomLabel:UILabel!
    
    // Purchase Order
    @IBOutlet var purchaseOrderLabel:UILabel!
    @IBOutlet var imageView3:UIImageView!
    @IBOutlet var purchaseOrderButton:UIButton!
    @IBOutlet var purchaseOrderBottomLabel:UILabel!
   
    // Bill of Material
    @IBOutlet var materialLabel:UILabel!
    @IBOutlet var imageView4:UIImageView!
    @IBOutlet var materialButton:UIButton!
    @IBOutlet var materialBottomLabel:UILabel!
    
    @IBOutlet var view1:UIView!
    @IBOutlet var view2:UIView!
    @IBOutlet var view3:UIView!
    @IBOutlet var view4:UIView!
    @IBOutlet var view1HConstraint: NSLayoutConstraint!
    @IBOutlet var view2HConstraint: NSLayoutConstraint!
    @IBOutlet var view3HConstraint: NSLayoutConstraint!
    @IBOutlet var view4HConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.inquiryDelegate = self
        self.setupUI()

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.inquiryDelegate = self
        self.getNotificationCount()
        self.hideNavigationBar()
        self.notificationCountLabel.startBlink()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
        self.notificationCountLabel.stopBlink()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI(){
        
        self.topView.backgroundColor = .inquiryPrimaryColor()
        self.topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 20.0)
        self.logoBgView.layer.cornerRadius = self.logoBgView.frame.size.width / 2.0
    
        self.view1.applyLightShadow()
        self.view2.applyLightShadow()
        self.view3.applyLightShadow()
        self.view4.applyLightShadow()
        self.callTypeBasedFunc()
        
        self.viewInquiryButton.setTitle("", for: .normal)
        self.factoryResponseButton.setTitle("", for: .normal)
        self.purchaseOrderButton.setTitle("", for: .normal)
        self.materialButton.setTitle("", for: .normal)

        self.screenTittleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryText")
        self.inquiryMenuButton.addTarget(self, action: #selector(toggleHomeMenu(_:)), for: .touchUpInside)
                
        self.notificationCountLabel.backgroundColor = .delayedColor()
        
        [viewInquiryLabel, factoryResponseLabel, purchaseOrderLabel, materialLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .left
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [viewInquiryBottomLabel, factoryResponseBottomLabel, purchaseOrderBottomLabel, materialBottomLabel].forEach{ (theLabel) in
            theLabel?.text = ""
            theLabel?.backgroundColor = .inquiryPrimaryColor()
            theLabel?.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
            theLabel?.clipsToBounds = true
        }
        
        self.view1.roundCorners(corners: .allCorners, radius: 10.0)
        self.view2.roundCorners(corners: .allCorners, radius: 10.0)
        self.view3.roundCorners(corners: .allCorners, radius: 10.0)
        self.view4.roundCorners(corners: .allCorners, radius: 10.0)
        
        [view1, view2, view3, view4].forEach{ (theView) in
            theView?.layer.shadowOpacity = 0.3
            theView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            theView?.layer.shadowRadius = 5.0
            theView?.layer.shadowColor = UIColor.customBlackColor().cgColor
            theView?.layer.masksToBounds = false
            theView?.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
            theView?.layer.borderWidth = 1.5
            theView?.backgroundColor = .white
        }
    }
   
    func callTypeBasedFunc(){
        
        self.imageView3.image = UIImage.init(named: Config.Images.viewPOIcon)
        self.purchaseOrderLabel.text = LocalizationManager.shared.localizedString(key:"viewPOText")
        
        self.imageView4.image = UIImage.init(named: Config.Images.materialLabelsIcon)
        self.materialLabel.text = LocalizationManager.shared.localizedString(key:"materialAndLabelText")
        
        self.purchaseOrderButton.addTarget(self, action: #selector(self.purchaseOrderButtonTapped(_:)), for: .touchUpInside)
        self.materialButton.addTarget(self, action: #selector(self.materialButtonTapped(_:)), for: .touchUpInside)
       
        // Purchase order staff permission
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewPO.rawValue) == true {
            self.view3.isHidden = false
            self.view3HConstraint.constant = 100
        }else{
            self.view3.isHidden = true
            self.view3HConstraint.constant = 0
        }
        
        // Materials & Label Staff permission
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewMaterialsAndLabels.rawValue) == true {
            self.view4.isHidden = false
            self.view4HConstraint.constant = 100
        }else{
            self.view4.isHidden = true
            self.view4HConstraint.constant = 0
        }
    
        if RMConfiguration.shared.workspaceType == Config.Text.factory{
            self.imageView1.image = UIImage.init(named: Config.Images.inquiryStatusIcon)
            self.imageView2.image = UIImage.init(named: Config.Images.sendQuoteIcon)
            self.viewInquiryLabel.text = LocalizationManager.shared.localizedString(key:"inquiryStatusText")
            self.factoryResponseLabel.text = LocalizationManager.shared.localizedString(key:"sendQuoteText")
            
            self.viewInquiryButton.addTarget(self, action: #selector(self.inquiryStatusButtonTapped(_:)), for: .touchUpInside)
            self.inquiryNotificationButton.addTarget(self, action: #selector(self.inquiryStatusButtonTapped(_:)), for: .touchUpInside)
            self.factoryResponseButton.addTarget(self, action: #selector(self.sendQuoteButtonTapped(_:)), for: .touchUpInside)
            
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.factoryViewInquiry.rawValue) == true{
                self.view1.isHidden = false
                self.view1HConstraint.constant = 100
            }else{
                self.view1.isHidden = true
                self.view1HConstraint.constant = 0
            }
            
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.factoryAddResponse.rawValue) == true{
                self.view2.isHidden = false
                self.view2HConstraint.constant = 80
            }else{
                self.view2.isHidden = true
                self.view2HConstraint.constant = 0
            }
            
        }else{
            self.imageView1.image = UIImage.init(named: Config.Images.viewInquiryIcon)
            self.imageView2.image = UIImage.init(named: Config.Images.sendQuoteIcon)
            self.viewInquiryLabel.text = LocalizationManager.shared.localizedString(key:"viewInquiryText")
            self.factoryResponseLabel.text = LocalizationManager.shared.localizedString(key:"factoyResponseText")
            
            self.viewInquiryButton.addTarget(self, action: #selector(self.viewInquiryButtonTapped(_:)), for: .touchUpInside)
            self.inquiryNotificationButton.addTarget(self, action: #selector(self.viewInquiryButtonTapped(_:)), for: .touchUpInside)
            self.factoryResponseButton.addTarget(self, action: #selector(self.factoryResponseButtonTapped(_:)), for: .touchUpInside)
      
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.buyerViewInquiry.rawValue) == true{
                self.view1.isHidden = false
                self.view1HConstraint.constant = 100
            }else{
                self.view1.isHidden = true
                self.view1HConstraint.constant = 0
            }
            
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.buyerViewResponse.rawValue) == true{
                self.view2.isHidden = false
                self.view2HConstraint.constant = 80
            }else{
                self.view2.isHidden = true
                self.view2HConstraint.constant = 0
            }
        }
        
    }
   
    func getNotificationCount() {
        self.showHud()
        let params: [String:Any] =  [ "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.checkInquiryNotification(params: params)
    }
  
    // For Buyer
    @objc func viewInquiryButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryList) as? InquiryListVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func factoryResponseButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .factoryResponse) as? FactoryResponseVC {
            vc.isFromDashboard = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
  
    // For Factory
    @objc func inquiryStatusButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryStatus) as? InquiryStatusVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func sendQuoteButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .sendQuotation) as? SendQuotationVC {
            vc.isFromDashboard = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func purchaseOrderButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .purchaseOrderList) as? PurchaseOrderListVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func materialButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .materialsAndLabelsList) as? MaterialsAndLabelsListVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func toggleHomeMenu(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

extension InquiryDashboardVC: RCInquiryDelegate{
   
    /// Get Inquiry Notification Response
    func didReceiveInquiryNotificationResponse(message: String){
        self.hideHud()
        self.notificationCountLabel.text = message.count == 1 ? "0\(message)" : message
        self.notificationCountLabel.isHidden = message == "0" ? true : false
    }
    
    func didFailedToInquiryNotificationResponse(errorMessage: String){
        self.hideHud()
    }

}
