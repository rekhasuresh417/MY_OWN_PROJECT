//
//  FabricDashboardVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 15/03/23.
//

import UIKit

class FabricDashboardVC: UIViewController {
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var logoImageView:UIImageView!
    @IBOutlet var logoBgView:UIView!
    
    @IBOutlet var fabricMenuButton: UIButton!
    @IBOutlet var screenTittleLabel: UILabel!
    
    @IBOutlet var viewFabricLabel:UILabel!
    @IBOutlet var imageView1:UIImageView!
    @IBOutlet var viewFabricButton:UIButton!
    @IBOutlet var viewFabricBottomLabel:UILabel!
    
    @IBOutlet var factoryResponseLabel:UILabel!
    @IBOutlet var imageView2:UIImageView!
    @IBOutlet var factoryResponseButton:UIButton!
    @IBOutlet var factoryResponseBottomLabel:UILabel!
    
    @IBOutlet var view1:UIView!
    @IBOutlet var view2:UIView!
    @IBOutlet var view1HConstraint: NSLayoutConstraint!
    @IBOutlet var view2HConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI(){
        
        self.topView.backgroundColor = .fabricPrimaryColor()
        self.topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 20.0)
        self.logoBgView.layer.cornerRadius = self.logoBgView.frame.size.width / 2.0
    
        self.view1.applyLightShadow()
        self.view2.applyLightShadow()
        self.callTypeBasedFunc()
        
        self.viewFabricButton.setTitle("", for: .normal)
        self.factoryResponseButton.setTitle("", for: .normal)

        self.screenTittleLabel.text = LocalizationManager.shared.localizedString(key: "fabricText")
        self.fabricMenuButton.addTarget(self, action: #selector(toggleHomeMenu(_:)), for: .touchUpInside)
                        
        [viewFabricLabel, factoryResponseLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .left
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [viewFabricBottomLabel, factoryResponseBottomLabel].forEach{ (theLabel) in
            theLabel?.text = ""
            theLabel?.backgroundColor = .fabricPrimaryColor()
            theLabel?.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
            theLabel?.clipsToBounds = true
        }
        
        self.view1.roundCorners(corners: .allCorners, radius: 10.0)
        self.view2.roundCorners(corners: .allCorners, radius: 10.0)
        
        [view1, view2].forEach{ (theView) in
            theView?.layer.shadowOpacity = 0.3
            theView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            theView?.layer.shadowRadius = 5.0
            theView?.layer.shadowColor = UIColor.customBlackColor().cgColor
            theView?.layer.masksToBounds = false
            theView?.layer.borderColor = UIColor.fabricPrimaryColor().cgColor
            theView?.layer.borderWidth = 1.5
            theView?.backgroundColor = .white
        }
    }
   
    func callTypeBasedFunc(){
        self.imageView1.image = UIImage.init(named: Config.Images.fabricInquiryIcon)
        self.imageView2.image = UIImage.init(named: Config.Images.sendQuoteIcon)
        self.viewFabricLabel.text = LocalizationManager.shared.localizedString(key:"inquiriesText")
        self.factoryResponseLabel.text = LocalizationManager.shared.localizedString(key:"suppliersResponseText")
        
        self.viewFabricButton.addTarget(self, action: #selector(self.viewFabricButtonTapped(_:)), for: .touchUpInside)
        self.factoryResponseButton.addTarget(self, action: #selector(self.factoryResponseButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func viewFabricButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .fabricInquiryList) as? FabricInquiryListVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func factoryResponseButtonTapped(_ sender: UIButton){
        if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .suppliersResponse) as? SuppliersResponseVC {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
 
    @objc func toggleHomeMenu(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
