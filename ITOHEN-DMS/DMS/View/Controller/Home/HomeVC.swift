//
//  HomeVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

class HomeVC: UIViewController, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var topView:UIView!
    @IBOutlet var profileButton:UIButton!
    @IBOutlet var notificationButton:UIButton!
    @IBOutlet var workspaceDownArrowImageView:UIImageView!
    @IBOutlet var workspaceButton:UIButton!
    @IBOutlet var workspaceLabel:UILabel!
    @IBOutlet var userTypeLabel:UILabel!
    @IBOutlet var logoImageView:UIImageView!
    @IBOutlet var logoBgView:UIView!
    @IBOutlet var firstView:UIView!
    @IBOutlet var ongoingListView:UIView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var seeAllButton:UIButton!
    @IBOutlet var dashBoardLabel: UILabel!
    @IBOutlet var onGoingListHeaderLabel:UILabel!
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var collectionViewHConstraint: NSLayoutConstraint!
    @IBOutlet var firstViewHConstraint:NSLayoutConstraint!
    @IBOutlet var ongoingListViewHConstraint:NSLayoutConstraint!
    @IBOutlet var ongoingListButton: UIButton!
    @IBOutlet var ongoingArrowImageView: UIImageView!
    @IBOutlet var orderStatusArrowImageView: UIImageView!
    @IBOutlet var delayTaskArrowImageView: UIImageView!
    @IBOutlet var delayProdArrowImageView: UIImageView!
    
    @IBOutlet var ongoingListBottomLabel: UILabel!
    @IBOutlet var orderStatusBottomLabel: UILabel!
    @IBOutlet var delayedTaskBottomLabel: UILabel!
    @IBOutlet var delayedProdBottomLabel: UILabel!
    @IBOutlet var orderStatusImageView: UIImageView!
    @IBOutlet var delayedTaskImageView: UIImageView!
    @IBOutlet var delayedProdImageView: UIImageView!
    @IBOutlet var ongoingListImageView: UIImageView!
    @IBOutlet var seeMoreOngoingListButton: UIButton!
    @IBOutlet var seeMoreOngoingListBtnHConstraint: NSLayoutConstraint!
    
    @IBOutlet var viewUserSettingsButton: UIButton!
    
    @IBOutlet var orderStatusView: UIView!
    @IBOutlet var orderStatusViewHConstraint:NSLayoutConstraint!
    @IBOutlet var orderStatusTextView: UIView!
    @IBOutlet var orderStatusButton: UIButton!
    @IBOutlet var orderStatusTitleLabel: UILabel!
    @IBOutlet var orderNoTextField: MDCOutlinedTextField!
    @IBOutlet var orderStatusNoDataView: UIView!
    @IBOutlet var orderStatusDataView: UIView!
    @IBOutlet var orderStatusTextFieldView: UIView!
    
    @IBOutlet var totalTaskStatusTitleLabel: UILabel!
    @IBOutlet var totalTaskStatusLabel: UILabel!
    
    @IBOutlet var completionBackLabel: UILabel!
    @IBOutlet var delyCompletionBackLabel: UILabel!
    @IBOutlet var delayBackLabel: UILabel!
    @IBOutlet var inProgressBackLabel: UILabel!
    @IBOutlet var yetToStartBackLabel: UILabel!
    
    @IBOutlet var generalTaskTitleLabel: UILabel!
    @IBOutlet var completionTitleLabel: UILabel!
    @IBOutlet var dlyCompletionTitleLabel: UILabel!
    @IBOutlet var delayTitleLabel: UILabel!
    @IBOutlet var inProgressTitleLabel: UILabel!
    @IBOutlet var yetToStartTitleLabel: UILabel!
    @IBOutlet var completionLabel: UILabel!
    @IBOutlet var dlyCompletionLabel: UILabel!
    @IBOutlet var delayLabel: UILabel!
    @IBOutlet var inProgressLabel: UILabel!
    @IBOutlet var yetToStartLabel: UILabel!
    
    @IBOutlet var productionStatusTitleLabel: UILabel!
    @IBOutlet var prodTotalTitleLabel: UILabel!
    @IBOutlet var prodTotalLabel: UILabel!
    
    @IBOutlet var prodCutTitleLabel: UILabel!
    @IBOutlet var prodCutPercTitleLabel: UILabel!
    @IBOutlet var prodCutDelyLabel: UILabel!
    @IBOutlet var prodCutImageView: UIImageView!
    @IBOutlet var prodCutDateLabel: UILabel!
    @IBOutlet var prodCutCompletedTitleLabel: UILabel!
    @IBOutlet var prodCutPendingTitlelLabel: UILabel!
    @IBOutlet var prodCutPerDayTitlelLabel: UILabel!
    @IBOutlet var prodCutCompletedLabel: UILabel!
    @IBOutlet var prodCutPendinglLabel: UILabel!
    @IBOutlet var prodCutPerDaylLabel: UILabel!
    
    @IBOutlet var prodSewTitleLabel: UILabel!
    @IBOutlet var prodSewPercTitleLabel: UILabel!
    @IBOutlet var prodSewDelyLabel: UILabel!
    @IBOutlet var prodSewImageView: UIImageView!
    @IBOutlet var prodSewDateLabel: UILabel!
    @IBOutlet var prodSewCompletedTitleLabel: UILabel!
    @IBOutlet var prodSewPendingTitlelLabel: UILabel!
    @IBOutlet var prodSewPerDayTitlelLabel: UILabel!
    @IBOutlet var prodSewCompletedLabel: UILabel!
    @IBOutlet var prodSewPendinglLabel: UILabel!
    @IBOutlet var prodSewPerDaylLabel: UILabel!
    
    @IBOutlet var prodPackTitleLabel: UILabel!
    @IBOutlet var prodPackPercTitleLabel: UILabel!
    @IBOutlet var prodPackDelyLabel: UILabel!
    @IBOutlet var prodPackImageView: UIImageView!
    @IBOutlet var prodPackDateLabel: UILabel!
    @IBOutlet var prodPackCompletedTitleLabel: UILabel!
    @IBOutlet var prodPackPendingTitlelLabel: UILabel!
    @IBOutlet var prodPackPerDayTitlelLabel: UILabel!
    @IBOutlet var prodPackCompletedLabel: UILabel!
    @IBOutlet var prodPackPendinglLabel: UILabel!
    @IBOutlet var prodPackPerDaylLabel: UILabel!
    
    @IBOutlet var delayedTaskView: UIView!
    @IBOutlet var topDelayedTaskTitleLabel: UILabel!
    @IBOutlet var delayedTaskViewHConstraint: NSLayoutConstraint!
    @IBOutlet var delayTaskTableView: UITableView!
    @IBOutlet var delayedTaskButton: UIButton!
    
    @IBOutlet var delayedProdView: UIView!
    @IBOutlet var topDelayedProdTitleLabel: UILabel!
    @IBOutlet var delayedProdViewHConstraint: NSLayoutConstraint!
    @IBOutlet var delayProdTableView: UITableView!
    @IBOutlet var delayedProdButton: UIButton!
    @IBOutlet var ongoingSeperatorLineLabel: UILabel!
    @IBOutlet var orderStatusSeperatorLineLabel: UILabel!
    @IBOutlet var delayTaskSeperatorLineLabel: UILabel!
    @IBOutlet var delayProdSeperatorLineLabel: UILabel!
    
    @IBOutlet var noResultLabel: UILabel!
    @IBOutlet var welcomeTextLabel: UILabel!
    @IBOutlet var setupTextLabel: UILabel!
    @IBOutlet var step1TextLabel: UILabel!
    @IBOutlet var dashboardDescriptionTextLabel: UILabel!
    
    var dashboardWidgetsData: DMSDashboardWidgetsData?
    var newDashboardWidgetsData: DMSNewDashboardWidgetsData?
    var isOngoingExpand = false
    var isOrderStatusExpand = false
    var isDelayTaskExpand = false
    var isDelayProdExpand = false
    
    var dashboardWidgets: [String] = []
    var orderStatusData: DMSOrderStatus?
    
    var homeItems = [HomeItems](){
        didSet{
            self.collectionView.reloadData()
        }
    }
    var onGoingList:[DMSGetOrderListData] = []{
        didSet{
            self.tableView.reloadData()
            if onGoingList.count>0{
                self.ongoingListHeightCall()
            }
        }
    }
    
    var topDelayedTaskList:[DMSTopTaskDelay] = []{
        didSet{
            self.delayTaskTableView.reloadData()
            if topDelayedTaskList.count>0{
                self.delayTaskHeightCall()
            }
        }
    }
    
    var topDelayedProdList:[DMSTopProdDelay] = []{
        didSet{
            self.delayProdTableView.reloadData()
            if topDelayedProdList.count>0{
                self.delayProdHeightCall()
            }
        }
    }
    
    var onGoingListCount: Int = 0{
        didSet{
            onGoingListCount = (self.onGoingList.count < 5) ? self.onGoingList.count : 5
        }
    }
    
    var tabBarVC: TabBarVC?{
        self.parent as? TabBarVC
    }
    
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var styleData: [DMSStyleData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    
    var badgeCountLabel = UILabel()
    var blurView = UIVisualEffectView()
    let firstViewContentCellHeight: CGFloat = 360.0
    let onGoingListContentCellHeight: CGFloat = 55.0
    let onGoingListTopContentHeight: CGFloat = 60.0 // top + bottom space
    let delayTopContentHeight: CGFloat = 90.0 // top + bottom space
    let topDelayTaskContentCellHeight: CGFloat = 140.0
    let orderStatusContentHeight: CGFloat = 720.0
    let orderStatusNoContentHeight: CGFloat = 420.0
    
    var orderType, filterType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.dashboardDelegate = self
        RestCloudService.shared.taskDelegate = self
        
        self.setupUI()
        self.workspaceDidChangeNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(self.workspaceDidChangeNotification),
                                               name: .reloadHomeVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadHomeItems),
                                               name: .reloadHomeItemsVC, object: nil)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onBoardHeight()
    }
    
    private func setupUI(){
        
        self.topView.applyTopViewStyle()
        self.hideKeyboardWhenTappedAround()
        
        self.logoBgView.layer.cornerRadius = self.logoBgView.frame.size.width / 2.0
        self.firstView.roundCorners(corners: .allCorners, radius: 10.0)
        self.ongoingListView.roundCorners(corners: .allCorners, radius: 10.0)
        self.delayedTaskView.roundCorners(corners: .allCorners, radius: 10.0)
        self.delayedProdView.roundCorners(corners: .allCorners, radius: 10.0)
        self.orderStatusView.roundCorners(corners: .allCorners, radius: 10.0)
        
        orderNoTextField.delegate = self
        
        [firstView, ongoingListView, delayedTaskView, delayedProdView, orderStatusView].forEach{ (theView) in
            theView?.layer.shadowOpacity = 0.3
            theView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            theView?.layer.shadowRadius = 5.0
            theView?.layer.shadowColor = UIColor.customBlackColor().cgColor
            theView?.layer.masksToBounds = false
            theView?.layer.borderColor = UIColor.primaryColor().cgColor
            theView?.layer.borderWidth = 1.5
            theView?.backgroundColor = UIColor.init(rgb: 0xE5F4F3, alpha: 1.0)
        }
        
        [ongoingListBottomLabel, orderStatusBottomLabel, delayedTaskBottomLabel, delayedProdBottomLabel].forEach{ (theLabel) in
            theLabel?.text = ""
            theLabel?.backgroundColor = .primaryColor()
            theLabel?.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
            theLabel?.clipsToBounds = true
        }
        
        self.orderStatusButton.setTitle("", for: .normal)
        self.ongoingListButton.setTitle("", for: .normal)
        self.delayedTaskButton.setTitle("", for: .normal)
        self.delayedProdButton.setTitle("", for: .normal)
        self.ongoingListButton.addTarget(self, action: #selector(self.onGoingExpandViewButtonTapped(_:)), for: .touchUpInside)
        self.delayedTaskButton.addTarget(self, action: #selector(self.delayTaskExpandViewButtonTapped(_:)), for: .touchUpInside)
        self.delayedProdButton.addTarget(self, action: #selector(self.delayProdExpandViewButtonTapped(_:)), for: .touchUpInside)
        self.orderStatusButton.addTarget(self, action: #selector(self.orderStatusExpandViewButtonTapped(_:)), for: .touchUpInside)
        
        self.viewUserSettingsButton.addTarget(self, action: #selector(self.gotoUserSettingButtonTapped(_:)), for: .touchUpInside)
        
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
        
        self.delayTaskTableView.allowsSelection = false
        self.delayTaskTableView.separatorStyle = .none
        
        self.delayProdTableView.allowsSelection = false
        self.delayProdTableView.separatorStyle = .none
        
        [welcomeTextLabel, setupTextLabel, step1TextLabel, dashboardDescriptionTextLabel].forEach { (theLabel) in
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .center
            theLabel?.numberOfLines = 0
            if theLabel == welcomeTextLabel{
                theLabel?.font = UIFont.appFont(ofSize: 22.0, weight: .medium)
            }else if theLabel == setupTextLabel{
                theLabel?.textColor = .primaryColor()
                theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
            }else{
                theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            }
        }
        
        [viewUserSettingsButton].forEach { (theButton) in
            theButton?.backgroundColor = .primaryColor()
            theButton?.setTitleColor(.white, for: .normal)
            theButton?.layer.borderWidth  = 1.0
            theButton?.layer.cornerRadius = viewUserSettingsButton.frame.height / 2.0
            theButton?.layer.borderColor = UIColor.primaryColor().cgColor
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        }
        
        self.badgeCountLabel = UILabel(frame: CGRect(x: 8, y: -5, width: 20, height: 20))
        self.badgeCountLabel.layer.borderColor = UIColor.clear.cgColor
        self.badgeCountLabel.layer.borderWidth = 2
        self.badgeCountLabel.layer.cornerRadius = self.badgeCountLabel.bounds.size.height / 2
        self.badgeCountLabel.textAlignment = .center
        self.badgeCountLabel.layer.masksToBounds = true
        self.badgeCountLabel.textColor = .white
        self.badgeCountLabel.font = self.badgeCountLabel.font.withSize(12)
        self.badgeCountLabel.backgroundColor = .red
        
        self.notificationButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.bellIcon),for: UIControl.State.normal)
        self.notificationButton.addTarget(self, action: #selector(self.onBtnNotification(_:)), for: .touchUpInside)
        self.notificationButton.addSubview(self.badgeCountLabel)
        
        self.profileButton.addTarget(self, action: #selector(self.onBtnProfile(_:)), for: .touchUpInside)
        self.profileButton.tintColor = .white
        // self.profileButton.setImage(UIImage.init(named: Config.Images.menuIcon)?.redraw(size: CGSize(width: 25.0, height: 25.0), tintColor: .white), for: .normal)
        
        self.workspaceDownArrowImageView.image = nil
        self.workspaceLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.workspaceLabel.textColor = .white
        self.workspaceLabel.textAlignment = .center
        self.workspaceLabel.numberOfLines = 1
        self.workspaceLabel.sizeToFit()
        self.userTypeLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.userTypeLabel.textColor = .white
        self.userTypeLabel.textAlignment = .center
        self.userTypeLabel.numberOfLines = 1
        self.userTypeLabel.sizeToFit()
        
        self.workspaceButton.addTarget(self, action: #selector(self.onBtnWorkspace(_:)), for: .touchUpInside)
        
        [onGoingListHeaderLabel, orderStatusTitleLabel, topDelayedTaskTitleLabel, topDelayedProdTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .left
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
        
        [prodCutDelyLabel, prodSewDelyLabel, prodPackDelyLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 11.0, weight: .medium)
            theLabel?.textColor = .completedColor()
            theLabel?.textAlignment = .left
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
        
        self.seeMoreOngoingListButton.setTitleColor(.primaryColor(), for: .normal)
        self.seeMoreOngoingListButton.titleLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        self.seeMoreOngoingListButton.addTarget(self, action: #selector(self.onBtnOnGoingList(_:)), for: .touchUpInside)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.isScrollEnabled = false
        
        self.delayTaskTableView.dataSource = self
        self.delayTaskTableView.delegate = self
        self.delayTaskTableView.isScrollEnabled = false
        
        self.delayProdTableView.dataSource = self
        self.delayProdTableView.delegate = self
        self.delayProdTableView.isScrollEnabled = false
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isScrollEnabled = false
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = 4.0
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        
        self.workspaceDownArrowImageView.isHidden = RMConfiguration.shared.loginType == Config.Text.user ? true : false
        self.workspaceButton.isUserInteractionEnabled = RMConfiguration.shared.loginType == Config.Text.user ? false : true
      
        // To hide see more ongoing list button
        self.seeMoreOngoingListButton.isHidden = true
        self.seeMoreOngoingListBtnHConstraint.constant = 0.0
        
        // hide when loading
        self.orderStatusView.isHidden = true
        self.orderStatusViewHConstraint.constant = 0.0
        
        // Default Ongoing order list calling so that firstview always hide
        self.ongoingListHeightCall()
        self.firstView.isHidden = true
        self.firstViewHConstraint.constant = 0.0
     
       // self.orderStatusImageView.image = UIImage.gif(name: "test")
        
    }
    
    @objc func gotoUserSettingButtonTapped(_ sender: UIButton) {
        
        if let vc = UIViewController.from(storyBoard: .userManagement, withIdentifier: .userSettings) as? UserSettingsVC {
            let navVC = UINavigationController(rootViewController:vc)
            navVC.modalPresentationStyle = .overCurrentContext
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    /// Order status Expand button action
    @objc func orderStatusExpandViewButtonTapped(_ sender: UIButton) {
        self.setup(orderNoTextField!, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "orderAndStyleNoText")) *")
        isOrderStatusExpand = !isOrderStatusExpand
        self.orderStatusHeightCall()
    }
    
    /// Ongoing list Expand button action
    @objc func onGoingExpandViewButtonTapped(_ sender: UIButton) {
        isOngoingExpand = !isOngoingExpand
        self.ongoingListHeightCall()
    }
    
    /// Delayed task Expand button action
    @objc func delayTaskExpandViewButtonTapped(_ sender: UIButton) {
        isDelayTaskExpand = !isDelayTaskExpand
        self.delayTaskHeightCall()
    }
    
    /// Delayed production Expand button action
    @objc func delayProdExpandViewButtonTapped(_ sender: UIButton) {
        isDelayProdExpand = !isDelayProdExpand
        self.delayProdHeightCall()
    }
    
    // Default view height
    private func onBoardHeight(){
        self.orderStatusHeightCall()
        self.ongoingListHeightCall()
        self.delayTaskHeightCall()
        self.delayProdHeightCall()
    }
    
    // Order status view height call
    private func orderStatusHeightCall(){
        if isOrderStatusExpand {
            self.orderStatusArrowImageView.image = UIImage.init(named: Config.Images.upArrowIcon)
            self.orderStatusHeight()
            self.orderStatusTextFieldView.isHidden = false
            self.orderStatusSeperatorLineLabel.isHidden = false
        } else {
            self.orderStatusViewHConstraint.constant = onGoingListTopContentHeight + 30
            self.orderStatusSeperatorLineLabel.isHidden = true
            self.orderStatusTextFieldView.isHidden = true
            self.orderStatusDataView.isHidden = true
            self.orderStatusNoDataView.isHidden = true
            self.orderStatusArrowImageView.image = UIImage.init(named: Config.Images.downArrowIcon)
        }
    }
    
    // Ongoing list view height call
    private func ongoingListHeightCall(){
      
        self.ongoingListView.isHidden = false
        if isOngoingExpand {
            self.ongoingArrowImageView.image = UIImage.init(named: Config.Images.upArrowIcon)
            self.tableView.isHidden = false
            self.ongoingSeperatorLineLabel.isHidden = false
            
            self.seeMoreOngoingListButton.isHidden = self.onGoingList.count > 5 ? false : true
            self.seeMoreOngoingListBtnHConstraint.constant = self.onGoingList.count > 5 ? 35 : 0.0
            self.ongoingOrderListHeight()
        } else {
            self.seeMoreOngoingListButton.isHidden = true
           self.seeMoreOngoingListBtnHConstraint.constant = 0.0
            self.ongoingListViewHConstraint.constant = onGoingListTopContentHeight + 30
            self.ongoingSeperatorLineLabel.isHidden = true
            self.tableView.isHidden = true
            self.ongoingArrowImageView.image = UIImage.init(named: Config.Images.downArrowIcon)
        }
        
        /*   self.seeMoreOngoingListButton.isHidden = true
        self.seeMoreOngoingListBtnHConstraint.constant = 0.0
        
        if dashboardWidgets.contains(DashBoardWidgets.ongoingList.rawValue){
            self.ongoingListView.isHidden = false
            if isOngoingExpand {
                self.ongoingArrowImageView.image = UIImage.init(named: Config.Images.upArrowIcon)
                self.tableView.isHidden = false
                self.ongoingSeperatorLineLabel.isHidden = false
                
                self.seeMoreOngoingListButton.isHidden = self.onGoingList.count > 5 ? false : true
                self.seeMoreOngoingListBtnHConstraint.constant = self.onGoingList.count > 5 ? 35 : 0.0
                
                self.ongoingOrderListHeight()
            } else {
                self.ongoingListViewHConstraint.constant = onGoingListTopContentHeight + 30
                self.ongoingSeperatorLineLabel.isHidden = true
                self.tableView.isHidden = true
                self.ongoingArrowImageView.image = UIImage.init(named: Config.Images.downArrowIcon)
            }
        }else{
            self.ongoingListView.isHidden = true
            self.ongoingListViewHConstraint.constant = 0.0
        }*/
        
    }
    
    // Delayed task view height
    private func delayTaskHeightCall(){
        if dashboardWidgets.contains(DashBoardWidgets.top5DelayedTask.rawValue){
            self.delayedTaskView.isHidden = false
            if isDelayTaskExpand {
                self.delayTaskArrowImageView.image = UIImage.init(named: Config.Images.upArrowIcon)
                self.delayTaskViewHeight()
                self.delayTaskTableView.isHidden = false
                self.delayTaskSeperatorLineLabel.isHidden = false
            } else {
                self.delayedTaskViewHConstraint.constant = onGoingListTopContentHeight + 30
                self.delayTaskSeperatorLineLabel.isHidden = true
                self.delayTaskTableView.isHidden = true
                self.delayTaskArrowImageView.image = UIImage.init(named: Config.Images.downArrowIcon)
            }
        }else{
            self.delayedTaskView.isHidden = true
            self.delayedTaskViewHConstraint.constant = 0.0
        }
        
    }
    
    // Delayed prodcution view height
    private func delayProdHeightCall(){
        if dashboardWidgets.contains(DashBoardWidgets.top5DelayedProduction.rawValue){
            self.delayedProdView.isHidden = false
            if isDelayProdExpand {
                self.delayProdArrowImageView.image = UIImage.init(named: Config.Images.upArrowIcon)
                self.delayProdViewHeight()
                self.delayProdTableView.isHidden = false
                self.delayProdSeperatorLineLabel.isHidden = false
            } else {
                self.delayedProdViewHConstraint.constant = onGoingListTopContentHeight + 30
                self.delayProdSeperatorLineLabel.isHidden = true
                self.delayProdTableView.isHidden = true
                self.delayProdArrowImageView.image = UIImage.init(named: Config.Images.downArrowIcon)
            }
        }else{
            self.delayedProdView.isHidden = true
            self.delayedProdViewHConstraint.constant = 0.0
        }
    }
    
    // Order status view height
    private func orderStatusHeight(){
        if orderNoTextField.text?.isEmptyOrWhitespace() == false{
            self.orderStatusViewHConstraint.constant = orderStatusContentHeight
            self.orderStatusNoDataView.isHidden = true
            self.orderStatusDataView.isHidden = false
        }else{
            self.orderStatusViewHConstraint.constant = orderStatusNoContentHeight
            self.orderStatusNoDataView.isHidden = false
            self.orderStatusDataView.isHidden = true
        }
    }
    
    private func ongoingOrderListHeight(){
        if self.onGoingList.count == 0{
            self.ongoingListViewHConstraint.constant = delayTopContentHeight + (5.0 * onGoingListContentCellHeight)
        }else{
            let count = ((self.onGoingList.count > 5) ? 5 : self.onGoingList.count)
            let height = count >= 5 ? (CGFloat(count) * onGoingListContentCellHeight) + 35 : (CGFloat(count) * onGoingListContentCellHeight)
            self.ongoingListViewHConstraint.constant = onGoingList.count == 0 ? delayTopContentHeight + (5 * onGoingListContentCellHeight) : delayTopContentHeight + height - 5
        }
    }
    
    private func delayTaskViewHeight(){
        if self.topDelayedTaskList.count == 0{
            self.delayedTaskViewHConstraint.constant = delayTopContentHeight + (5.0 * onGoingListTopContentHeight)
        }else{
            self.delayedTaskViewHConstraint.constant = delayTopContentHeight + (CGFloat(topDelayedTaskList.count) * topDelayTaskContentCellHeight) - 5
        }
    }
    
    func delayProdViewHeight(){
        if self.topDelayedProdList.count == 0{
            self.delayedProdViewHConstraint.constant = delayTopContentHeight + (5.0 * onGoingListTopContentHeight)
        }else{
            self.delayedProdViewHConstraint.constant = delayTopContentHeight + (CGFloat(topDelayedProdList.count) * topDelayTaskContentCellHeight) - 5
        }
    }
    
    @objc func onBtnWorkspace(_ sender: UIButton){
        
        if let popController = UIViewController.from(storyBoard: .home, withIdentifier: .workspace) as? WorkspaceVC{
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender
            popController.popoverPresentationController?.sourceRect = sender.bounds
            
            let height = ((self.appDelegate().workspaceDetails.workspaceList.count * 100) + 50)
            popController.preferredContentSize = height>500 ? CGSize(width: 300.0,  height: 500) : CGSize(width: 300.0,  height: CGFloat((self.appDelegate().workspaceDetails.workspaceList.count * 100) + 50))
            
            popController.target = self
            popController.tabBarVC = tabBarVC
            present(popController, animated: true, completion:{
                self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
                self.blurView.contentView.backgroundColor = .customBlackColor()
                self.blurView.layer.opacity = 0.4
                self.blurView.frame = self.tabBarVC?.view.bounds ?? self.view.bounds
                self.tabBarVC?.view.addSubview(self.blurView)
            })
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.blurView.removeFromSuperview()
    }
    
    @objc func onBtnOnGoingList(_ sender: AnyObject){
        if  RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewAllOrder.rawValue) == true{
            DispatchQueue.main.async {
                if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .onGoingList) as? OnGoingListVC {
                    vc.target = self
                    vc.onGoingList = self.onGoingList
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }else{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText") , message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"), target: self)
        }
    }
    
    @objc func onBtnNotification(_ sender: AnyObject){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .notification) as? NotificationVC {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func onBtnProfile(_ sender: AnyObject){
        DispatchQueue.main.async {
            
            if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .menuBar) as? MenuBarVC {
                vc.preferredSheetSizing = .large
                vc.tabBarVC = self.tabBarVC
                let navVC = UINavigationController(rootViewController:vc)
                navVC.isNavigationBarHidden = true
                navVC.modalPresentationStyle = .overCurrentContext
                navVC.modalTransitionStyle = .crossDissolve
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func loadHomeItems(){
        // for language changes
        self.orderNoTextField.delegate = self
        self.setup(orderNoTextField!, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "orderAndStyleNoText")) *")
        self.setupPickerViewWithToolBar(textField: orderNoTextField,
                                        target: self,
                                        thePicker: thePicker,
                                        isCancelButtonNeeded: true)
        self.onGoingListHeaderLabel.text = LocalizationManager.shared.localizedString(key: "onGoingListHeaderText")
        self.seeMoreOngoingListButton.setTitle(LocalizationManager.shared.localizedString(key: "seeAllButtonText"), for: .normal)
        self.dashBoardLabel.text = LocalizationManager.shared.localizedString(key: "dashboardText")
        self.welcomeTextLabel.text = LocalizationManager.shared.localizedString(key: "dashBoardWelcomeText")
        
        self.topDelayedTaskTitleLabel.text = LocalizationManager.shared.localizedString(key: "topDelayedTaskText")
        self.topDelayedProdTitleLabel.text = LocalizationManager.shared.localizedString(key: "topDelayedProdText")
        self.orderStatusTitleLabel.text = LocalizationManager.shared.localizedString(key: "orderStatusTitleText")
        self.noResultLabel.text = LocalizationManager.shared.localizedString(key: "noResultText")
        
        let text: String = "\(LocalizationManager.shared.localizedString(key: "menu")) > \(LocalizationManager.shared.localizedString(key: "userSettingText")) > \(LocalizationManager.shared.localizedString(key: "dashboardText"))"
        
        let attText1: NSMutableAttributedString =  self.getAttributedText(firstString: "\(LocalizationManager.shared.localizedString(key: "step")): ",
                                                                          firstFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                          firstColor: .customBlackColor(),
                                                                          secondString: text,
                                                                          secondFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                          secondColor: .primaryColor())
        
        self.step1TextLabel.attributedText = attText1
        self.setupTextLabel.text = LocalizationManager.shared.localizedString(key: "customizeyourDashboard")
        self.dashboardDescriptionTextLabel.text = LocalizationManager.shared.localizedString(key: "widgetstobedisplayedinthedashboard")
        
        self.viewUserSettingsButton.setTitle("  \(LocalizationManager.shared.localizedString(key: "nextText")) ", for: .normal)
        
        // Order Status Text
        self.generalTaskTitleLabel.text = LocalizationManager.shared.localizedString(key: "generalTaskText")
        self.completionTitleLabel.text = LocalizationManager.shared.localizedString(key: "completed")
        self.dlyCompletionTitleLabel.text = LocalizationManager.shared.localizedString(key: "delCompletion")
        self.delayTitleLabel.text = LocalizationManager.shared.localizedString(key: "delay")
        self.totalTaskStatusTitleLabel.text = LocalizationManager.shared.localizedString(key: "totalText")
        self.inProgressTitleLabel.text = LocalizationManager.shared.localizedString(key: "inProgress")
        self.yetToStartTitleLabel.text = LocalizationManager.shared.localizedString(key: "yetToStart")
        
        self.productionStatusTitleLabel.text = LocalizationManager.shared.localizedString(key: "productionTask")
        self.prodTotalTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "totalText")): "
        
       // self.prodCutTitleLabel.text = LocalizationManager.shared.localizedString(key: "cuttingText")
        self.prodCutCompletedTitleLabel.text = LocalizationManager.shared.localizedString(key: "completed")
        self.prodCutPendingTitlelLabel.text = LocalizationManager.shared.localizedString(key: "pendingText")
        self.prodCutPerDayTitlelLabel.text = LocalizationManager.shared.localizedString(key: "reqQtyText") // requiredQtyText
        
        //self.prodSewTitleLabel.text = LocalizationManager.shared.localizedString(key: "sewingText")
        self.prodSewCompletedTitleLabel.text = LocalizationManager.shared.localizedString(key: "completed")
        self.prodSewPendingTitlelLabel.text = LocalizationManager.shared.localizedString(key: "pendingText")
        self.prodSewPerDayTitlelLabel.text = LocalizationManager.shared.localizedString(key: "reqQtyText") // requiredQtyText
        
        //self.prodPackTitleLabel.text = LocalizationManager.shared.localizedString(key: "packingText")
        self.prodPackCompletedTitleLabel.text = LocalizationManager.shared.localizedString(key: "completed")
        self.prodPackPendingTitlelLabel.text = LocalizationManager.shared.localizedString(key: "pendingText")
        self.prodPackPerDayTitlelLabel.text = LocalizationManager.shared.localizedString(key: "reqQtyText") // requiredQtyText
        
        if self.orderStatusData != nil{
            self.bindOrderStatusView()
        }
        self.delayTaskTableView.reloadData()
        self.delayProdTableView.reloadData()
    }
    
    @objc func loadHomeWidgets(){
        dashboardWidgets = self.newDashboardWidgetsData?.dashboardWidgets ?? []
        
        self.firstView.isHidden = true
        self.firstViewHConstraint.constant = 0.0
        
        if let widgets = self.newDashboardWidgetsData?.dashboardWidgets, widgets.count>0{
//            self.firstView.isHidden = true
//            self.firstViewHConstraint.constant = 0.0
            
            if widgets.contains(DashBoardWidgets.orderStatus.rawValue){
                self.orderStatusView.isHidden = false
                self.orderStatusHeightCall()
            }else{
                self.orderStatusView.isHidden = true
                self.orderStatusViewHConstraint.constant = 0.0
            }
            
            self.ongoingListHeightCall()
            
           /* if widgets.contains(DashBoardWidgets.ongoingList.rawValue){
                self.ongoingListView.isHidden = false
                self.ongoingListHeightCall()
            }else{
                self.ongoingListView.isHidden = true
                self.ongoingListViewHConstraint.constant = 0.0
            }*/
            
            // Notification Always show
            self.notificationButton.isHidden = false
            self.notificationButton.isUserInteractionEnabled = true
            
            /*if widgets.contains(DashBoardWidgets.notifications.rawValue){
                self.notificationButton.isHidden = false
                self.notificationButton.isUserInteractionEnabled = true
                
            }else{
                self.notificationButton.isHidden = true
                self.notificationButton.isUserInteractionEnabled = false
            }*/
            
            if widgets.contains(DashBoardWidgets.top5DelayedTask.rawValue){
                self.delayedTaskView.isHidden = false
                self.delayTaskHeightCall()
            }else{
                self.delayedTaskView.isHidden = true
                self.delayedTaskViewHConstraint.constant = 0.0
            }
            
            if widgets.contains(DashBoardWidgets.top5DelayedProduction.rawValue){
                self.delayedProdView.isHidden = false
                self.delayProdHeightCall()
            }else{
                self.delayedProdView.isHidden = true
                self.delayedProdViewHConstraint.constant = 0.0
            }
            
            /// Only Notifications selected
            if !widgets.contains(DashBoardWidgets.ongoingList.rawValue) && !widgets.contains(DashBoardWidgets.top5DelayedTask.rawValue) && !widgets.contains(DashBoardWidgets.top5DelayedProduction.rawValue) && !widgets.contains(DashBoardWidgets.orderStatus.rawValue){
//                self.firstView.isHidden = false
//                self.firstViewHConstraint.constant = self.firstViewContentCellHeight
            }
        }else{
//            self.firstView.isHidden = false
//            self.firstViewHConstraint.constant = self.firstViewContentCellHeight
            
//            self.notificationButton.isHidden = true
//            self.notificationButton.isUserInteractionEnabled = false
            
            // Notification Always show
            self.notificationButton.isHidden = false
            self.notificationButton.isUserInteractionEnabled = true
          
            // Ongoing List Always show
            self.ongoingListHeightCall()
            
//            self.ongoingListView.isHidden = false
//            self.ongoingListViewHConstraint.constant = 0.0
            
            self.orderStatusView.isHidden = true
            self.orderStatusViewHConstraint.constant = 0.0
            
            self.delayedTaskView.isHidden = true
            self.delayedTaskViewHConstraint.constant = 0.0
            
            self.delayedProdView.isHidden = true
            self.delayedProdViewHConstraint.constant = 0.0
        }
        
    }
    
    private func bindOrderStatusView(){
        
        self.orderStatusHeightCall()
        
        let data = self.orderStatusData
        
        self.completionLabel.text = "\(data?.taskCount?[0].completed ?? 0)"
        self.dlyCompletionLabel.text = "\(data?.taskCount?[0].delayedCompleted ?? 0)"
        self.delayLabel.text = "\(data?.taskCount?[0].delay ?? 0)"
        self.inProgressLabel.text = "\(data?.taskCount?[0].inProgress ?? 0)"
        self.yetToStartLabel.text = "\(data?.taskCount?[0].yetToStart ?? 0)"
        self.totalTaskStatusLabel.text = "\(data?.taskCount?[0].total ?? 0)"
        
        self.prodCutImageView.image = UIImage.init(named: Config.Images.cuttingIcon)
        self.prodSewImageView.image = UIImage.init(named: Config.Images.sewingIcon)
        self.prodPackImageView.image = UIImage.init(named: Config.Images.packingIcon)
        
        self.completionBackLabel.backgroundColor = .completedColor()
        self.delyCompletionBackLabel.backgroundColor = .delyCompletionColor()
        self.delayBackLabel.backgroundColor = .delayedColor()
        self.inProgressBackLabel.backgroundColor = .inProgressColor()
        self.yetToStartBackLabel.backgroundColor = .yetToStartColor()
        
        /// Cutting percentage
        let cutText = "\(LocalizationManager.shared.localizedString(key: "cuttingText")) - \(Int(data?.prodData?[0].cutPercentage ?? 0))%"
        var cutPerc: String = ""
        var cutColor: UIColor = .primaryColor()
        
        self.prodCutDelyLabel.text = data?.prodData?[0].cutStatus
        self.prodSewDelyLabel.text = data?.prodData?[0].sewStatus
        self.prodPackDelyLabel.text = data?.prodData?[0].packStatus
        
        if (data?.prodData?[0].cutStatus == Config.OrderStatus.delayed ){
            self.prodCutImageView.tintColor = .delayedColor()
            self.prodCutDelyLabel.textColor = .delayedColor()
            self.prodCutDelyLabel.text = LocalizationManager.shared.localizedString(key: "delayedTitleText")
        }else if ( data?.prodData?[0].cutStatus == Config.OrderStatus.delayedCompletion ){
            self.prodCutImageView.tintColor = .delyCompletionColor()
            self.prodCutDelyLabel.textColor = .delyCompletionColor()
            self.prodCutDelyLabel.text = LocalizationManager.shared.localizedString(key: "delayedCompletionTitleText")
        }else if (data?.prodData?[0].cutStatus == Config.OrderStatus.completed){
            self.prodCutImageView.tintColor = .completedColor()
            self.prodCutDelyLabel.textColor = .completedColor()
            self.prodCutDelyLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
        }else if (data?.prodData?[0].cutStatus == Config.OrderStatus.inProgress){
            self.prodCutImageView.tintColor = .completedColor()
            self.prodCutDelyLabel.textColor = .completedColor()
            self.prodCutDelyLabel.text = ""
          //  self.prodCutDelyLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
        }else{
            self.prodCutImageView.tintColor = .lightGray
            self.prodCutDelyLabel.textColor = .lightGray
            self.prodCutDelyLabel.text = ""
        }
        
        if data?.prodData?[0].cutTargets ?? 0 >= 0  && (data?.prodData?[0].cutStatus == Config.OrderStatus.completed || data?.prodData?[0].cutStatus == Config.OrderStatus.inProgress){
            cutPerc = "(↑\(abs(Int(data?.prodData?[0].cutTargets ?? 0)))%)"
            cutColor = .completedColor()
        }else if data?.prodData?[0].cutTargets ?? 0 <= 0  && (data?.prodData?[0].cutStatus == Config.OrderStatus.delayedCompletion ){
            cutPerc = "(↓\(abs(Int(data?.prodData?[0].cutTargets ?? 0)))%)"
            cutColor = .delyCompletionColor()
        }else if data?.prodData?[0].cutTargets ?? 0 <= 0  && (data?.prodData?[0].cutStatus == Config.OrderStatus.delayed ){
            cutPerc = "(↓\(abs(Int(data?.prodData?[0].cutTargets ?? 0)))%)"
            cutColor = .delayedColor()
        }else if (data?.prodData?[0].cutTargets ?? 0 < 0  && (data?.prodData?[0].cutStatus == Config.OrderStatus.inProgress)){
            cutPerc = "(↓\(abs(Int(data?.prodData?[0].cutTargets ?? 0)))%)"
            cutColor = .delayedColor()
        }else{
            cutPerc = ""
            cutColor = .customBlackColor()
        }
      
        self.prodCutTitleLabel.text = cutText
        self.prodCutTitleLabel.textColor = .customBlackColor()
        self.prodCutPercTitleLabel.text = cutPerc
        self.prodCutPercTitleLabel.textColor = cutColor
        
        /// Sewing percentage
        let sewText = "\(LocalizationManager.shared.localizedString(key: "sewingText")) - \(Int(data?.prodData?[0].sewPercentage ?? 0))%"
        var sewPerc: String = ""
        var sewColor: UIColor = .primaryColor()
        
        if (data?.prodData?[0].sewStatus == Config.OrderStatus.delayed ){
            self.prodSewImageView.tintColor = .delayedColor()
            self.prodSewDelyLabel.textColor = .delayedColor()
            self.prodSewDelyLabel.text = LocalizationManager.shared.localizedString(key: "delayedTitleText")
        }else if (data?.prodData?[0].sewStatus == Config.OrderStatus.delayedCompletion ){
            self.prodSewImageView.tintColor = .delyCompletionColor()
            self.prodSewDelyLabel.textColor = .delyCompletionColor()
            self.prodSewDelyLabel.text = LocalizationManager.shared.localizedString(key: "delayedCompletionTitleText")
        }else if (data?.prodData?[0].sewStatus == Config.OrderStatus.completed){
            self.prodSewImageView.tintColor = .completedColor()
            self.prodSewDelyLabel.textColor = .completedColor()
            self.prodSewDelyLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
        }else if (data?.prodData?[0].sewStatus == Config.OrderStatus.inProgress){
            self.prodSewImageView.tintColor = .completedColor()
            self.prodSewDelyLabel.textColor = .completedColor()
            self.prodSewDelyLabel.text = ""
           // self.prodSewDelyLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
        }else{
            self.prodSewImageView.tintColor = .lightGray
            self.prodSewDelyLabel.textColor = .lightGray
            self.prodSewDelyLabel.text = ""
        }
        
        if data?.prodData?[0].sewTargets ?? 0 >= 0  && (data?.prodData?[0].sewStatus == Config.OrderStatus.completed || data?.prodData?[0].sewStatus == Config.OrderStatus.inProgress){
            sewPerc = "(↑\(abs(Int(data?.prodData?[0].sewTargets ?? 0)))%)"
            sewColor = .completedColor()
        }else if data?.prodData?[0].sewTargets ?? 0 <= 0  && (data?.prodData?[0].sewStatus == Config.OrderStatus.delayedCompletion ){
            sewPerc = "(↓\(abs(Int(data?.prodData?[0].sewTargets ?? 0)))%)"
            sewColor = .delyCompletionColor()
        }else if data?.prodData?[0].sewTargets ?? 0 <= 0  && (data?.prodData?[0].sewStatus == Config.OrderStatus.delayed ){
            sewPerc = "(↓\(abs(Int(data?.prodData?[0].sewTargets ?? 0)))%)"
            sewColor = .delayedColor()
        }else if (data?.prodData?[0].sewTargets ?? 0 < 0  && (data?.prodData?[0].sewStatus == Config.OrderStatus.inProgress)){
            sewPerc = "(↓\(abs(Int(data?.prodData?[0].sewTargets ?? 0)))%)"
            sewColor = .delayedColor()
        }else{
            sewPerc = ""
            sewColor = .customBlackColor()
        }
        
        self.prodSewTitleLabel.text = sewText
        self.prodSewTitleLabel.textColor = .customBlackColor()
        self.prodSewPercTitleLabel.text = sewPerc
        self.prodSewPercTitleLabel.textColor = sewColor
        
        /// Packing percentage
        let packText = "\(LocalizationManager.shared.localizedString(key: "packingText")) - \(Int(data?.prodData?[0].packPercentage ?? 0))%"
        var packPerc: String = ""
        var packColor: UIColor = .primaryColor()
        
        if (data?.prodData?[0].packStatus == Config.OrderStatus.delayed ){
            self.prodPackImageView.tintColor = .delayedColor()
            self.prodPackDelyLabel.textColor = .delayedColor()
            self.prodPackDelyLabel.text = LocalizationManager.shared.localizedString(key: "delayedTitleText")
        }else if (data?.prodData?[0].packStatus == Config.OrderStatus.delayedCompletion){
            self.prodPackImageView.tintColor = .delyCompletionColor()
            self.prodPackDelyLabel.textColor = .delyCompletionColor()
            self.prodPackDelyLabel.text = LocalizationManager.shared.localizedString(key: "delayedCompletionTitleText")
        }else if (data?.prodData?[0].packStatus == Config.OrderStatus.completed){
            self.prodPackImageView.tintColor = .completedColor()
            self.prodPackDelyLabel.textColor = .completedColor()
            self.prodPackDelyLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
        }else if (data?.prodData?[0].packStatus == Config.OrderStatus.inProgress){
            self.prodPackImageView.tintColor = .completedColor()
            self.prodPackDelyLabel.textColor = .completedColor()
            self.prodPackDelyLabel.text = ""
        //    self.prodPackDelyLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
        }else{
            self.prodPackImageView.tintColor = .lightGray
            self.prodPackDelyLabel.textColor = .lightGray
            self.prodPackDelyLabel.text = ""
        }
        
        if data?.prodData?[0].packTargets ?? 0 >= 0  && (data?.prodData?[0].packStatus == Config.OrderStatus.completed || data?.prodData?[0].packStatus == Config.OrderStatus.inProgress){
            packPerc = "(↑\(abs(Int(data?.prodData?[0].packTargets ?? 0)))%)"
            packColor = .completedColor()
        }else if data?.prodData?[0].packTargets ?? 0 <= 0  && (data?.prodData?[0].packStatus == Config.OrderStatus.delayedCompletion){
            packPerc = "(↓\(abs(Int(data?.prodData?[0].packTargets ?? 0)))%)"
            packColor = .delyCompletionColor()
        }else if data?.prodData?[0].packTargets ?? 0 <= 0  && (data?.prodData?[0].packStatus == Config.OrderStatus.delayed ){
            packPerc = "(↓\(abs(Int(data?.prodData?[0].packTargets ?? 0)))%)"
            packColor = .delayedColor()
        }else if (data?.prodData?[0].packTargets ?? 0 < 0  && (data?.prodData?[0].packStatus == Config.OrderStatus.inProgress) ){
            packPerc = "(↓\(abs(Int(data?.prodData?[0].packTargets ?? 0)))%)"
            packColor = .delayedColor()
        }else{
            packPerc = ""
            packColor = .customBlackColor()
        }
        
        self.prodPackTitleLabel.text = packText
        self.prodPackTitleLabel.textColor = .customBlackColor()
        self.prodPackPercTitleLabel.text = packPerc
        self.prodPackPercTitleLabel.textColor = packColor
        
        self.prodTotalLabel.text = "\(data?.prodData?[0].total ?? 0)"
        self.prodCutDateLabel.text = DateTime.convertDateFormater("\(data?.prodData?[0].cutEndDate ?? "")", currentFormat: Date.simpleDateFormat, newFormat: RMConfiguration.shared.dateFormat)
        
        self.prodCutCompletedLabel.text = "\(data?.prodData?[0].cutCompleted ?? 0)"
        self.prodCutPendinglLabel.text = "\((data?.prodData?[0].total ?? 0) - (data?.prodData?[0].cutCompleted ?? 0))"
        self.prodCutPerDaylLabel.text = "\(data?.prodData?[0].cutPerDay ?? 0)"
        
        self.prodSewDateLabel.text = DateTime.convertDateFormater("\(data?.prodData?[0].sewEndDate ?? "")", currentFormat: Date.simpleDateFormat, newFormat: RMConfiguration.shared.dateFormat)
        
        self.prodSewCompletedLabel.text = "\(data?.prodData?[0].sewCompleted ?? 0)"
        self.prodSewPendinglLabel.text = "\((data?.prodData?[0].total ?? 0) - (data?.prodData?[0].sewCompleted ?? 0))"
        self.prodSewPerDaylLabel.text = "\(data?.prodData?[0].sewPerDay ?? 0)"
        
        self.prodPackDateLabel.text = DateTime.convertDateFormater("\(data?.prodData?[0].packEndDate ?? "")", currentFormat: Date.simpleDateFormat, newFormat: RMConfiguration.shared.dateFormat)
        
        self.prodPackCompletedLabel.text = "\(data?.prodData?[0].packCompleted ?? 0)"
        self.prodPackPendinglLabel.text = "\((data?.prodData?[0].total ?? 0) - (data?.prodData?[0].packCompleted ?? 0))"
        self.prodPackPerDaylLabel.text = "\(data?.prodData?[0].packPerDay ?? 0)"
        
    }
    
    override func doneButtonTapped(_ sender: AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if styleData.count == 0 { //returns -1 if nothing selected
            self.view.endEditing(true)
            thePicker.endEditing(true)
            return
        }
        
        if activeField == self.orderNoTextField{
            self.orderNoTextField.text = "\(styleData[row].style_no ?? "") ( \(styleData[row].order_no ?? "") )"
            self.getOrderStatus(orderId: "\(styleData[row].id ?? 0)")
        }
        self.orderStatusNoDataView.isHidden = true
        self.orderStatusDataView.isHidden = false
        
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }
    
    override func cancelPickerButtonTapped(_ sender: UIButton){
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }
    
    // Load top 5 delayed task and production
    private func loadTopDelayList(data: DMSGetTopDelayData){
        self.topDelayedTaskList = data.top5taskdelayed ?? []
        self.topDelayedProdList = data.top5proddelayed ?? []
    }
    
    // Workspace notification observer
    @objc func workspaceDidChangeNotification(){
        if RMConfiguration.shared.notifyCount == "0"{
            self.badgeCountLabel.text = ""
            self.badgeCountLabel.isHidden = true
        }else{
            self.badgeCountLabel.isHidden = false
            self.badgeCountLabel.text = RMConfiguration.shared.notifyCount
        }
        
        RestCloudService.shared.dashboardDelegate = self
        RestCloudService.shared.taskDelegate = self
        
        if styleData.count == 0{
            self.getOrderList()
        }
        
        self.loadWorkspaceTopUI()
        self.getNewDashboardWidget()
        self.getTopDelay()
        self.getOngoingList()
        self.loadHomeItems()
        if  RMConfiguration.shared.loginType == Config.Text.staff{
            self.getPermissions()
        }
    }
    
    // Load workspace title on top view
    @objc func loadWorkspaceTopUI(){
        self.userTypeLabel.text = RMConfiguration.shared.role
        self.workspaceLabel.text = RMConfiguration.shared.workspaceName
        self.workspaceDownArrowImageView.image = Config.Images.shared.getImage(imageName: Config.Images.downArrowFillIcon)
    }
   
    // Get dashboard widgets API call
    private func getDashboardWidget(){
        let params:[String:String] = ["company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "user_id": RMConfiguration.shared.userId,
                                      "staff_id": RMConfiguration.shared.staffId
        ]
        print(params)
        RestCloudService.shared.getDashboardWidget(params: params)
    }
    
    // Get new dashboard widgets API call
    private func getNewDashboardWidget(){
        var params:[String:String] = ["company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId
        ]
        if RMConfiguration.shared.loginType == Config.Text.staff{
            params["staff_id"] = RMConfiguration.shared.staffId
        }else{
            params["user_id"] = RMConfiguration.shared.userId
        }
        print(params)
        
        RestCloudService.shared.getNewDashboardWidget(params: params)
    }
    
    // Get ongoing list API call
    private func getOngoingList(){
        let params:[String:String] = ["company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "workspaceType": RMConfiguration.shared.workspaceType,
                                      "user_id": RMConfiguration.shared.userId,
                                      "staff_id": RMConfiguration.shared.staffId
        ]
        print(params)
        RestCloudService.shared.getOngoingList(params: params)
    }
    
    private func getTopDelay(){
        let params: [String:String] = ["company_id": RMConfiguration.shared.companyId,
                                       "workspace_id": RMConfiguration.shared.workspaceId,
                                       "user_id": RMConfiguration.shared.userId,
                                       "staff_id": RMConfiguration.shared.staffId
        ]
        print(params)
        RestCloudService.shared.getTopDelay(params: params)
    }
    
    // Get staff permission API call
    private func getPermissions(){
        let params:[String:String] = ["company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "user_id": RMConfiguration.shared.userId,
                                      "staff_id": RMConfiguration.shared.staffId
        ]
        print(params)
        RestCloudService.shared.getPermissions(params: params)
    }
    
    // Get order List details API call
    private func getOrderList(){
        RestCloudService.shared.taskDelegate = self
        self.showHud()
        let params:[String:Any] = [ "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getTaskFilterData(params: params)
    }
    
    // Get order status details API call
    private func getOrderStatus(orderId: String){
        self.showHud()
        let params:[String:Any] = [ "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "order_id": orderId]
        print(params)
        RestCloudService.shared.getOrderStatus(params: params)
    }
}

extension HomeVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        thePicker.selectRow(0, inComponent: 0, animated: true)
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return styleData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == orderNoTextField && row < styleData.count{
            return "\(styleData[row].style_no ?? "") ( \(styleData[row].order_no ?? "") )"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.orderNoTextField.text = "\(styleData[row].order_no ?? "") / \(styleData[row].style_no ?? "")"
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return homeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        cell.setContent(item: self.homeItems[indexPath.row])
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension HomeVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return (tableView.updateNumberOfRow(self.onGoingList.count) < 5) ? tableView.updateNumberOfRow( self.onGoingList.count) : 5 //tableView.updateNumberOfRow( self.onGoingList.count) //
        }else if tableView == self.delayTaskTableView{
            return tableView.updateNumberOfRow( self.topDelayedTaskList.count)
        }else{
            return tableView.updateNumberOfRow( self.topDelayedProdList.count)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OnGoingListTableViewCell
            cell.isUserInteractionEnabled = true
            cell.setContent(data: self.onGoingList[indexPath.row], target: self)
            return cell
        }else if tableView == self.delayTaskTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TopDelayTaskTableViewCell
            cell.setTaskContent(data: self.topDelayedTaskList[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TopDelayTaskTableViewCell
            cell.setProdContent(data: self.topDelayedProdList[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.pushToOrderInfo(id: self.onGoingList[indexPath.row].id ?? "")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            return onGoingListContentCellHeight
        }else{
            return topDelayTaskContentCellHeight
        }
    }

}

extension HomeVC: RCDashboardDelegate {
   
    /// DashboardWidgets
    func didReceiveDashboard(dashboardWidgets: DMSDashboardWidgetsData?) {
        self.hideHud()
        dashboardWidgetsData = dashboardWidgets
        self.loadHomeItems()
    }
    
    func didFailedToReceiveDashboardWidgets(errorMessage: String) {
        self.hideHud()
    }
  
    /// New DashboardWidgets
    func didReceiveNewDashboard(dashboardWidgets: DMSNewDashboardWidgetsData?){
        self.hideHud()
        newDashboardWidgetsData = dashboardWidgets
        self.loadHomeWidgets()
    }
    
    func didFailedToReceiveNewDashboardWidgets(errorMessage: String){
        self.hideHud()
    }
    
    ///OngoingList
    func didReceiveOngoingList(ongoingList: [DMSGetOrderListData]){
        self.hideHud()
       self.onGoingList = ongoingList
    }
    
    func didFailedToReceiveOngoingList(errorMessage: String){
        self.hideHud()
    }
  
    /// Top Delay list
    func didReceiveTopDelayList(topDelayList: DMSGetTopDelayData?){
        self.hideHud()
        if let topDelayData = topDelayList{
            self.loadTopDelayList(data: topDelayData)
        }
    }
    
    func didFailedToReceiveTopDelayList(errorMessage: String){
        self.hideHud()
    }
    
    /// Get permissions  delegates
    func didReceiveGetStaffPermission(data: DMSWorkspaceList?){
        self.hideHud()
    }
    
    func didFailedToReceiveStaffPermission(errorMessage: String){
        self.hideHud()
    }
    
    /// Get order status  delegates
    func didReceiveGetOrderStatus(data: DMSOrderStatus?){
        self.hideHud()
        if let orderStatusData = data{
            self.orderStatusData = orderStatusData
            self.bindOrderStatusView()
        }
    }
    
    func didFailedToReceiveOrderStatus(errorMessage: String){
        self.hideHud()
    }
    
}

extension HomeVC: RCTaskDelegate{
    func didReceiveStylesFilter(data: DMSGetFilterTaskData?){
        self.hideHud()
        if let styleData = data{
            self.styleData = styleData.style?.filter{$0.step_level == Config.stepLevel && $0.status == "1"} ?? []
            self.orderStatusHeightCall()
        }
    }
    
    func didFailedToReceiveStylesFilter(errorMessage: String){
        self.hideHud()
    }
  
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct HomeItems {
    var title: String
    var totalCount: Int
    var updatedDate: String
    var iconName: String
            
    var image: UIImage?{
        return UIImage(named: iconName)
    }
}
