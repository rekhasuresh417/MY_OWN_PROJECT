//
//  HolidaysListVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 17/09/21.
//

import UIKit

class HolidaysListVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var sectionTitle1Label:UILabel!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var applyButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
   
    @IBOutlet var compensateCollectionView: UICollectionView!
    @IBOutlet var holidayListCollectionView: UICollectionView!
    
    @IBOutlet var compensateTitleHConstraint: NSLayoutConstraint!
    @IBOutlet var holidayTitleHConstraint: NSLayoutConstraint!

    @IBOutlet weak var compensateCollectionLayout: UICollectionViewFlowLayout! {
        didSet {
            compensateCollectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var holidayCollectionLayout: UICollectionViewFlowLayout! {
        didSet {
            holidayCollectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet var collectionView1HConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView2HConstraint: NSLayoutConstraint!
    
    var selctedOrder: Int = 0
    var getHolidayList:[String] = []
    var getCompensateWorkingList:[String] = []
    var selectedHolidayIndex = [IndexPath]() // This is selected cell Index array
    var selectedCompensateIndex = [IndexPath]() // This is selected cell Index array
    var selectedCompensateList: [String] = []
    var selectedHolidayList = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.topView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.topView.addGestureRecognizer(tap)
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
    
        [sectionTitleLabel, sectionTitle1Label].forEach{ (theLabel) in
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .left
            theLabel?.font = UIFont.appFont(ofSize: 16.0, weight: .semibold)
        }
        sectionTitleLabel.text = "Compensate Working Days"
        sectionTitle1Label.text = "Holiday List"
  
        self.holidayListCollectionView.collectionViewLayout = holidayCollectionLayout
        self.holidayListCollectionView.contentInsetAdjustmentBehavior = .always
        
        self.holidayListCollectionView.delegate = self
        self.holidayListCollectionView.dataSource = self
        self.holidayListCollectionView.reloadData()
        
        self.compensateCollectionView.collectionViewLayout = compensateCollectionLayout
        self.compensateCollectionView.contentInsetAdjustmentBehavior = .always
        
        self.compensateCollectionView.delegate = self
        self.compensateCollectionView.dataSource = self
        self.compensateCollectionView.reloadData()
  
        self.holidayListCollectionView.allowsMultipleSelection = true
        self.compensateCollectionView.allowsMultipleSelection = true
     
        if self.getCompensateWorkingList.count>0 {
            self.collectionView1HConstraint.constant = self.compensateCollectionView.collectionViewLayout.collectionViewContentSize.height + 20
        }else{
            self.compensateTitleHConstraint.constant = 0
            self.collectionView1HConstraint.constant = 0
        }

        if self.getHolidayList.count>0 {
            self.collectionView2HConstraint.constant = self.holidayListCollectionView.collectionViewLayout.collectionViewContentSize.height + 20
        }else{
            self.holidayTitleHConstraint.constant = 0
            self.collectionView2HConstraint.constant = 0
        }
        
        self.view.layoutIfNeeded()
        
        self.cancelButton.backgroundColor = .white
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "closeButtonText"), for: .normal)
        self.cancelButton.setTitleColor(.primaryColor(), for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.cancelButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        
        self.applyButton.isUserInteractionEnabled = true
        self.applyButton.backgroundColor = .primaryColor()
        self.applyButton.layer.cornerRadius = self.applyButton.frame.height / 2.0
        self.applyButton.setTitle(LocalizationManager.shared.localizedString(key: "applyButtonText"), for: .normal)
        self.applyButton.setTitleColor(.white, for: .normal)
        self.applyButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.applyButton.addTarget(self, action: #selector(self.applyButtonTapped(_:)), for: .touchUpInside)
        
    }
  
    func fromJSON(string: String) throws -> [[String: Any]] {
        let data = string.data(using: .utf8)!
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else {
            throw NSError(domain: NSCocoaErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }
        return jsonObject.map { $0 as! [String: Any] }
    }
    
    @objc func applyButtonTapped(_ sender: UIButton) {
       print(selectedHolidayList, selectedCompensateList)
        for date in selectedHolidayList {
            getHolidayList =  getHolidayList.filter {$0 != date}
        }
        for date in selectedCompensateList {
            getCompensateWorkingList =  getCompensateWorkingList.filter {$0 != date}
        }
        
//        self.appDelegate().copyHolidaysList  = getHolidayList //[getHolidayList, getCompensateWorkingList].reduce([],+)
//        self.appDelegate().copyCompensateList  = getCompensateWorkingList
        self.dismissViewController(shouldReload: true)
    }
    
    @objc func dismissViewController(shouldReload:Bool = false) {
        self.dismiss(animated: true, completion: {
            if shouldReload{
               NotificationCenter.default.post(name: .reloadProductionVC, object: nil)
            }
        })
    }
    
}

extension HolidaysListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.holidayListCollectionView{
            return getHolidayList.count
        }else {
            return getCompensateWorkingList.count
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.holidayListCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HolidayListCollectionViewCell
            cell.holidayDateButton.setTitle("  \(self.getHolidayList[indexPath.row])  ", for: .normal)
        
            if selectedHolidayIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
                cell.backgroundColor = UIColor.gray
            }
            else {
                cell.backgroundColor = UIColor.primaryColor()
            }
            cell.layoutSubviews()
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CompensateCollectionViewCell
            cell.holidayDateButton.setTitle("  \(self.getCompensateWorkingList[indexPath.row])  ", for: .normal)

            if selectedCompensateIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
                cell.backgroundColor = UIColor.gray
            }
            else {
                cell.backgroundColor = UIColor.primaryColor()
            }
            cell.layoutSubviews()
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("You selected cell #\(indexPath.item)!")

        var strData: String?
        if collectionView == self.holidayListCollectionView{
            strData = getHolidayList[indexPath.item]
            if selectedHolidayIndex.contains(indexPath) {
                selectedHolidayIndex = selectedHolidayIndex.filter { $0 != indexPath}
                selectedHolidayList = selectedHolidayList.filter { $0 != strData}
            }
            else {
                selectedHolidayIndex.append(indexPath)
                selectedHolidayList.append(strData ?? "")
            }
        }else{
            strData = getCompensateWorkingList[indexPath.item]
            
            if selectedCompensateIndex.contains(indexPath) {
                selectedCompensateIndex = selectedCompensateIndex.filter { $0 != indexPath}
                selectedCompensateList = selectedCompensateList.filter { $0 != strData}
            }
            else {
                selectedCompensateIndex.append(indexPath)
                selectedCompensateList.append(strData ?? "")
            }
        }
   
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let indexPaths = collectionView.indexPathsForSelectedItems, indexPaths.contains(indexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        }

        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let text: String
        if collectionView == self.holidayListCollectionView{
            text = getHolidayList[indexPath.row]
        }else{
            text = getCompensateWorkingList[indexPath.row]
        }
       
        let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:17)]).width
        return CGSize(width: cellWidth, height: 40.0) // collectionView.frame.width/4
    }
}

class HolidayListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var holidayDateButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .primaryColor()
        self.layer.cornerRadius = self.frame.size.height / 2.0
        
        self.holidayDateButton.backgroundColor = .clear
        self.holidayDateButton.setTitleColor(.white, for: .normal)
        self.holidayDateButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        
        self.holidayDateButton.isUserInteractionEnabled = false
    }
}

class CompensateCollectionViewCell: UICollectionViewCell {
    @IBOutlet var holidayDateButton: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .primaryColor()
        self.layer.cornerRadius = self.frame.size.height / 2.0
        
        self.holidayDateButton.backgroundColor = .clear
        self.holidayDateButton.setTitleColor(.white, for: .normal)
        self.holidayDateButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.holidayDateButton.isUserInteractionEnabled = false
 
    }
}

class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int

    public init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
