//
//  DetailsFabricInquiryVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 21/03/23.
//

import UIKit

class DetailsFabricInquiryVC: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var inquiryNoTitleLabel: UILabel!
    @IBOutlet var inquiryTitleLabel: UILabel!
    
    @IBOutlet var yarnCountTitleLabel: UILabel!
    @IBOutlet var yarnCountLabel: UILabel!
    @IBOutlet var yarnQuantityTitleLabel: UILabel!
    @IBOutlet var yarnQuantityLabel: UILabel!
    @IBOutlet var yarnQualityTitleLabel: UILabel!
    @IBOutlet var yarnQualityLabel: UILabel!
    @IBOutlet var materialTitleLabel: UILabel!
    @IBOutlet var materialLabel: UILabel!
    @IBOutlet var compositionTitleLabel: UILabel!
    @IBOutlet var compositionLabel: UILabel!
    @IBOutlet var inquiryRefTitleLabel: UILabel!
    @IBOutlet var inquiryRefLabel: UILabel!
    @IBOutlet var deliveryDateTitleLabel: UILabel!
    @IBOutlet var deliveryDateLabel: UILabel!
    @IBOutlet var inhouseDateTitleLabel: UILabel!
    @IBOutlet var inhouseDateLabel: UILabel!

    // External data
    var inquiryId: String?
    var fabricData: [FabricInquityDetailsData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
        self.getFabricInquiryDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.fabricDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .fabric)
        self.title = LocalizationManager.shared.localizedString(key:"viewFabricInquiryText")
    }
    
    func setupUI(){
        
        self.contentView.backgroundColor = UIColor(rgb: 0xF2F4F3)
        self.mainView.backgroundColor = .white
        self.mainView.applyLightShadow()
        
        [inquiryNoTitleLabel, yarnCountTitleLabel, yarnQuantityTitleLabel, yarnQualityTitleLabel, materialTitleLabel, compositionTitleLabel, inquiryRefTitleLabel, deliveryDateTitleLabel, inhouseDateTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            theLabel?.textColor = UIColor(rgb: 0x838B8B)
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [inquiryTitleLabel, yarnCountLabel, yarnQuantityLabel, yarnQualityLabel, materialLabel, compositionLabel, inquiryRefLabel, deliveryDateLabel, inhouseDateLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
            theLabel?.textColor = UIColor(rgb: 0x31444A)
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
        
        self.inquiryNoTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "inquiryNoText")):"
        self.yarnCountTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "yarnCountText"))"
        self.yarnQuantityTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "yarnQuantityText"))"
        self.yarnQualityTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "yarnQualityText"))"
        self.materialTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "materialText"))"
        self.compositionTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "compositionText"))"
        self.inquiryRefTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "inquiryReferenceText"))"
        self.deliveryDateTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "deliveryDateText"))"
        self.inhouseDateTitleLabel.text = "  \(LocalizationManager.shared.localizedString(key: "inhouseDateText"))"
        
    }

    private func getFabricInquiryDetails(){
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": self.inquiryId ?? ""]
        print(params)
        RestCloudService.shared.getFabricInquiryDetails(params: params)
    }
    
    private func bindData(){
        self.inquiryTitleLabel.text = "IN-\(inquiryId ?? "")"
        self.yarnCountLabel.text = "\(self.fabricData?[0].yarn_count ?? "")"
        self.yarnQuantityLabel.text = "\(self.fabricData?[0].yarn_quantity ?? "")"
        self.yarnQualityLabel.text = "\(self.fabricData?[0].yarn_quality ?? "")"
        self.materialLabel.text = "\(self.fabricData?[0].meterial ?? "")"
        self.compositionLabel.text = "\(self.fabricData?[0].composition ?? "")"
        self.inquiryRefLabel.text = "\(self.fabricData?[0].reference_inquiry ?? 0)"
        self.deliveryDateLabel.text = "\(self.fabricData?[0].delivery_date ?? "")"
        self.inhouseDateLabel.text = "\(self.fabricData?[0].inhouse_date ?? "")"
    }
}

extension DetailsFabricInquiryVC: RCFabricDelegate{
   
    /// Get fabric  inquiry details
    func didReceiveFabricInquiryDetails(data: [FabricInquityDetailsData]?) {
        self.hideHud()
        self.fabricData = data
        self.bindData()
    }
    func didFailedToReceiveFabricInquiryDetails(errorMessage: String){
        self.hideHud()
    }
}
