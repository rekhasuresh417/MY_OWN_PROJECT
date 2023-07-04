//
//  SKUAddVC.swift
//  Itohen-dms
//
//  Created by Dharma on 05/01/21.
//

import UIKit

protocol AddedSKUProtocolDelegate{
    func GetAddedSKU(isColor: Bool, data: DMSAllColorSize)
}

class SKUAddVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var section1View:UIView!
    @IBOutlet var section2View:UIView!
    @IBOutlet var section1TitleLabel:UILabel!
    @IBOutlet var section2TitleLabel:UILabel!
    @IBOutlet var colorCollectionView:UICollectionView!
    @IBOutlet var sizeCollectionView:UICollectionView!
    @IBOutlet var addQuantityButton:UIButton!
    @IBOutlet var addNewColorButton:UIButton!
    @IBOutlet var addNewSizeButton:UIButton!
    
    var orderId:String = "0"
    var basicInfoData: Basic?
    
    // All colors of current workspace
    var allColors: [DMSAllColorSize] = []{
        didSet{
            self.colorCollectionView.reloadData()
            self.scrollToBottom(collectionView: self.colorCollectionView)
            self.addQuantityButtonStatus()
        }
    }
    
    // All sizes of current workspace
    var allSizes: [DMSAllColorSize] = []{
        didSet{
            self.sizeCollectionView.reloadData()
            self.scrollToBottom(collectionView: self.sizeCollectionView)
            self.addQuantityButtonStatus()
        }
    }

    // Sku data of current order
    var skuData:[OrderSKUData] = []
    var involvedColor: [String] = []
    var involvedSize: [String] = []
    var finalSkuData = [OrderSKUData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.orderInfoDelegate = self
        self.setupUI()
        self.getAllColorSize()
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.getAllColorSize),
                                               name: .reloadSKUAddVC, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.orderInfoDelegate = self
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "skuTitle")
    }
    
    func setupUI() {
        self.view.backgroundColor = .appBackgroundColor()
        self.contentView.backgroundColor = .clear
        self.colorCollectionView.dataSource = self
        self.colorCollectionView.delegate = self
        self.sizeCollectionView.dataSource = self
        self.sizeCollectionView.delegate = self
        [section1View, section2View].forEach { (theView) in
            theView?.backgroundColor = .white
            theView?.roundCorners(corners: .allCorners, radius: 8.0)
            theView?.layer.shadowOpacity = 0.2
            theView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            theView?.layer.shadowRadius = 5.0
            theView?.layer.shadowColor = UIColor.customBlackColor().cgColor
            theView?.layer.masksToBounds = false
        }
        
        [section1TitleLabel, section2TitleLabel].forEach { (theLabel) in
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .left
            theLabel?.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
            if theLabel == section1TitleLabel{
                theLabel?.text = LocalizationManager.shared.localizedString(key: "section1TitleText")
            }else if theLabel == section2TitleLabel{
                theLabel?.text = LocalizationManager.shared.localizedString(key: "section2TitleText")
            }
        }
        
        self.addNewColorButton.setTitle(LocalizationManager.shared.localizedString(key: "addNewColorButtonText"), for: .normal)
        self.addNewColorButton.setTitleColor(.primaryColor(), for: .normal)
        self.addNewColorButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.addNewColorButton.addTarget(self, action: #selector(self.addNewColorButtonTapped(_:)), for: .touchUpInside)
        
        self.addNewSizeButton.setTitle(LocalizationManager.shared.localizedString(key: "addNewSizeButtonText"), for: .normal)
        self.addNewSizeButton.setTitleColor(.primaryColor(), for: .normal)
        self.addNewSizeButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.addNewSizeButton.addTarget(self, action: #selector(self.addNewSizeButtonTapped(_:)), for: .touchUpInside)
        
        self.addQuantityButton.layer.cornerRadius = self.addQuantityButton.frame.height / 2.0
        self.addQuantityButton.setTitle(LocalizationManager.shared.localizedString(key: "addQuantityText"), for: .normal)
        self.addQuantityButton.setTitleColor(.white, for: .normal)
        self.addQuantityButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.addQuantityButton.addTarget(self, action: #selector(self.addQuantityButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func getAllColorSize() {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": self.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                   "staff_id": RMConfiguration.shared.staffId,
                                   "company_id": RMConfiguration.shared.companyId,
                                   "workspace_id": RMConfiguration.shared.workspaceId ]
        RestCloudService.shared.getOrderSKUs(params: params)
      
    }
    
    func selectedSKU(){
 
        // Update Colors & Sizes model boolean properties based on Sku data
        for i in 0..<self.allColors.count{
            if involvedColor.contains(self.allColors[i].id){
                self.allColors[i].isSelected = true
                self.allColors[i].isPreviouslySelected = true
            }
        }
        for i in 0..<self.allSizes.count{
            if involvedSize.contains(self.allSizes[i].id){
                self.allSizes[i].isSelected = true
                self.allSizes[i].isPreviouslySelected = true
            }
        }
        self.reloadCollectionView()
    }
  
    func reloadCollectionView(){
        self.sizeCollectionView.reloadData()
        self.colorCollectionView.reloadData()
        self.addQuantityButtonStatus()
    }
    
    func getOrderSKUData() {
    
     /*   let path:String = Config.API.apiOrderSKU + "/\(self.orderId)"
        
        let resource = Resource<DMSGetOrderSKU,
                                DMSError>(jsonDecoder: JSONDecoder(),
                                          path: path,
                                          method: .get,
                                          params: [:],
                                          headers: [:])
        
        Self.sharedWebClient.load(resource: resource) { [weak self] response in
            
            guard let controller = self else { return }
            
            DispatchQueue.main.async { [self] in
                controller.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                print(response.value as Any)
                if response.value?.code == 200{
                    if let skuData = response.value?.data.skuData{
                        self?.skuData = skuData
                    }
                    if let colorSizeActualValue = response.value?.data.colorSizeActualValue{
                        self?.colorSizeActualValue = colorSizeActualValue
                    }
                    if let involvedColor = response.value?.data.colorInvolved{
                        self?.involvedColor = involvedColor
                    }
                    if let involvedSize = response.value?.data.sizeInvolved{
                        self?.involvedSize = involvedSize
                    }
                    self?.loadExistingColorSize()
                    self?.addQuantityButtonStatus()
                }else if let error = response.error {
                    controller.handleError(error)
                }else{
                    self?.showAlert(message: LocalizationManager.shared.localizedString(key: "unknownErrorText"))
                }
            }
        }*/
    }

    func loadFinalSkuData() {
        
        // Get all selected colors
        let currentSelectedColors:[String] = self.allColors.compactMap { (data) -> String? in
            return (data.isSelected) ? data.id : nil
        }
        print(currentSelectedColors)
        
        // Get all selected sizes
        let currentSelectedSizes:[String] = self.allSizes.compactMap { (data) -> String? in
            return (data.isSelected) ? data.id : nil
        }
        print(currentSelectedSizes)
        
        self.finalSkuData.removeAll()
        
        // Add the same existing data based on the selected color & size
        for data in self.skuData {
            if currentSelectedColors.contains(data.colorID ?? "") && currentSelectedSizes.contains(data.sizeID ?? ""){
                self.finalSkuData.append(data)
            }
        }
        
        print(allColors, allSizes)
        
        // Add newly selected colors with all selected sizes
        for color in self.allColors {
            if color.isPreviouslySelected == false && color.isSelected{
                for size in self.allSizes {
                    if size.isSelected{
                        self.finalSkuData.append(OrderSKUData(colorID: color.id, sizeID: size.id, skuQuantity: "0", colorTitle: color.title, sizeTitle: size.title))
                    }
                }
            }
            
            // Add newly selected sizes to previously selected colors
            else if color.isPreviouslySelected == true && color.isSelected {
                for size in self.allSizes {
                    if size.isPreviouslySelected == false && size.isSelected{
                        self.finalSkuData.append(OrderSKUData(colorID: color.id, sizeID: size.id, skuQuantity: "0", colorTitle: color.title, sizeTitle: size.title))
                    }
                }
            }
        }
        print(self.finalSkuData)
    }
    
    func addQuantityButtonStatus() {
        let isColorSelected = self.allColors.filter {return $0.isSelected}
        let isSizeSelected = self.allSizes.filter {return $0.isSelected}
        if isColorSelected.count > 0 && isSizeSelected.count > 0{
            self.addQuantityButton.isUserInteractionEnabled = true
            self.addQuantityButton.backgroundColor = .primaryColor()
        }else{
            self.addQuantityButton.isUserInteractionEnabled = false
            self.addQuantityButton.backgroundColor = .lightGray
        }
    }
    
    func scrollToBottom(collectionView:UICollectionView) {
        let item = self.collectionView(collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
    }
    
    @objc func addQuantityButtonTapped(_ sender: UIButton) {
       self.loadFinalSkuData()
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addNewSKUQuantity) as? SKUAddQuantityVC {
            vc.orderId = self.orderId
            vc.finalSkuData = self.finalSkuData
            vc.basicInfoData = self.basicInfoData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNewColorButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addNewSKU) as? SKUAddNewColorOrSize {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.model = AddNewColorOrSize(type: .color)
            vc.getAllColors = self.allColors
            vc.skuDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func addNewSizeButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addNewSKU) as? SKUAddNewColorOrSize {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.model = AddNewColorOrSize(type: .size)
            vc.getAllSizes = self.allSizes
            vc.skuDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }

    func reloadSizeCollectionView(){
        self.sizeCollectionView.reloadData()
        self.scrollToBottom(collectionView: self.sizeCollectionView)
        self.addQuantityButtonStatus()
    }
   
    func reloadColorCollectionView(){
        self.colorCollectionView.reloadData()
        self.scrollToBottom(collectionView: self.colorCollectionView)
        self.addQuantityButtonStatus()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SKUAddVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colorCollectionView{
            return self.allColors.count
        }else{
            return self.allSizes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colorCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorcell", for: indexPath) as! SKUColorCollectionViewCell
            cell.setContent(item: allColors[indexPath.row], involvedColor: self.involvedColor)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizecell", for: indexPath) as! SKUSizeCollectionViewCell
            cell.setContent(item: allSizes[indexPath.row], involvedSize: self.involvedSize)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.colorCollectionView{
            self.allColors[indexPath.row].isSelected = !self.allColors[indexPath.row].isSelected
            if self.allColors[indexPath.row].isSelected{
                self.involvedColor.append(allColors[indexPath.row].id)
            }else{
                self.involvedColor = involvedColor.filter({$0 != allColors[indexPath.row].id})
            }
            self.reloadColorCollectionView()
        }else{
            self.allSizes[indexPath.row].isSelected = !self.allSizes[indexPath.row].isSelected
            if self.allSizes[indexPath.row].isSelected{
                self.involvedSize.append(allSizes[indexPath.row].id)
            }else{
                self.involvedSize = involvedSize.filter({$0 != allSizes[indexPath.row].id})
            }
            self.reloadSizeCollectionView()
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = (collectionView == self.colorCollectionView) ? 4 : 6
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing *   CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize.init(width: CGFloat(size), height: 40.0)
    }
}

extension SKUAddVC: RCOrderInfoDelegate {
   
    /// Get order SKUs  delegates
    func didReceiveOrderSKUs(data: DMSGetAllColorSizeData?){
        self.hideHud()
        self.allColors = data?.color ?? []
        self.allSizes = data?.size ?? []
   
        if involvedSize.count>0 || involvedColor.count>0{
            self.selectedSKU()
            return
        }
        self.reloadCollectionView()
    }
    
    func didFailedToReceiveOrderSKUs(errorMessage: String){
        self.hideHud()
    }
}

extension SKUAddVC: AddedSKUProtocolDelegate{
    func GetAddedSKU(isColor: Bool, data: DMSAllColorSize) {
        if isColor{
            self.allColors.append(data)
        }else{
            self.allSizes.append(data)
        }
    }
}
