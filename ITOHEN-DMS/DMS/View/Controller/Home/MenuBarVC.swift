//
//  MenuBarVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 02/08/22.
//

import UIKit

final class MenuBarVC: BottomSheetController {

    @IBOutlet var contentView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeViewButton: UIButton!
    @IBOutlet weak var swipeLabel: UILabel!
    
    var menuItems = [MenuItems](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var tabBarVC: TabBarVC?
    /// For transition
    /* -----------------------------------------------------------------------*/
    let defaultHeight: CGFloat = 400
    let dismissibleHeight: CGFloat = 300
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 400
    
    // Dynamic container constraint
    @IBOutlet var containerViewHConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewBConstraint: NSLayoutConstraint!
    
    let maxDimmedAlpha: CGFloat = 0.6
  
 /* -----------------------------------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.currentContainerHeight = 600 //self.containerViewHConstraint.constant
        self.setupUI()
        setupPanGesture()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // animateShowDimmedView()
      //  animatePresentContainer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMenuItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
    }

    func setupUI(){
    
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
      
        let tapGesture = UITapGestureRecognizer(target: self,
                action: #selector(handleTap))
        tapGesture.delegate = self
        self.contentView.addGestureRecognizer(tapGesture)
        
        self.swipeLabel.backgroundColor = .gray
        self.swipeLabel.layer.cornerRadius = self.swipeLabel.frame.size.height/2
        self.swipeLabel.clipsToBounds = true
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
   
        self.profileImageView.image = UIImage.init(named: Config.Images.userIcon)
        
        /// Update values
        self.profileNameLabel.text = "\(RMConfiguration.shared.userName) - \(RMConfiguration.shared.role)"
        self.emailLabel.text = RMConfiguration.shared.email
    
        self.closeViewButton.setTitle("", for: .normal)
        self.closeViewButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        self.closeViewButton.isHidden = false
        
        self.tableView.allowsSelection = true
        self.tableView.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
                
    }
  
    func loadMenuItems(){
        self.menuItems.removeAll()
    
       // self.menuItems.append(MenuItems(type: .home, title: LocalizationManager.shared.localizedString(key: "homeTitle"), iconName: Config.Images.homeIcon))
     
        
        // For Inquiry
        if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.factoryViewInquiry.rawValue) == true {
                // Allow permission to Inquiry
                self.menuItems.append(MenuItems(type: .inquiry, title: LocalizationManager.shared.localizedString(key: "inquiryText"), iconName: Config.Images.inquiryIcon))
            }
       
        }else { // For Buyer And PCU
            if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.buyerViewInquiry.rawValue) == true{
                // Allow permission to Inquiry
                self.menuItems.append(MenuItems(type: .inquiry, title: LocalizationManager.shared.localizedString(key: "inquiryText"), iconName: Config.Images.inquiryIcon))
            }
        }
        
        // For Fabric
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewFabricInquiry.rawValue) == true {
            self.menuItems.append(MenuItems(type: .fabric, title: LocalizationManager.shared.localizedString(key: "fabricText"), iconName: Config.Images.fabricIcon))
        }
        
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addTaskUpdates.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOthersTask.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewTaskUpdates.rawValue) == true{
            
            self.menuItems.append(MenuItems(type: .taskUpdate, title: LocalizationManager.shared.localizedString(key: "taskUpdateText"), iconName: Config.Images.menuTaskIcon))
        }
    
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addDataInput.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewDataInput.rawValue) == true || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editDataInput.rawValue) == true{
            self.menuItems.append(MenuItems(type: .dataInput, title: LocalizationManager.shared.localizedString(key: "dataInputTitleText"), iconName: Config.Images.menuDataInputIcon))
        }
        
        self.menuItems.append(MenuItems(type: .userSettings, title: LocalizationManager.shared.localizedString(key: "userSettingText"), iconName: Config.Images.menuUserSettingsIcon))
    
        self.menuItems.append(MenuItems(type: .language, title: LocalizationManager.shared.localizedString(key: "languageText"), iconName: Config.Images.languageIcon_menu))
        
        self.menuItems.append(MenuItems(type: .help, title: LocalizationManager.shared.localizedString(key: "helpText"), iconName: Config.Images.helpIcon_menu))
        
        self.menuItems.append(MenuItems(type: .logout, title: LocalizationManager.shared.localizedString(key: "logoutText"), iconName: Config.Images.logoutIcon))
                
        self.containerViewHConstraint.constant = CGFloat(self.menuItems.count * 60) + 100

    }

    func pushToLanguageVC(){
        if let vc = UIViewController.from(storyBoard: .main, withIdentifier: .language) as? LanguageSelectionVC {
            vc.uiFrom = "sidemenu"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
   
    func pushToInquiryVC(){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryDashboard) as? InquiryDashboardVC {
                let navVC = UINavigationController(rootViewController:vc)
                navVC.modalPresentationStyle = .overCurrentContext
                navVC.modalTransitionStyle = .crossDissolve
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func pushToFabricVC(){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .fabricDashboard) as? FabricDashboardVC {
                let navVC = UINavigationController(rootViewController:vc)
                navVC.modalPresentationStyle = .overCurrentContext
                navVC.modalTransitionStyle = .crossDissolve
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func pushToAppManualVC(){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .appManual) as? AppManualVC {
                let navVC = UINavigationController(rootViewController:vc)
                navVC.modalPresentationStyle = .overCurrentContext
                navVC.modalTransitionStyle = .crossDissolve
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func pushToTaskUpdateVC(type: HomeItemType){
        if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .orderFilter) as? OrderFilterVC {
            vc.target = self
            vc.type = type
            vc.tabBarVC = self.tabBarVC
            let navVC = UINavigationController(rootViewController:vc)
            navVC.modalPresentationStyle = .overCurrentContext
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    func pushToUserSettingsVC(){
        if let vc = UIViewController.from(storyBoard: .userManagement, withIdentifier: .userSettings) as? UserSettingsVC {
            let navVC = UINavigationController(rootViewController:vc)
            navVC.modalPresentationStyle = .overCurrentContext
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    
    func pushToHomeVC(){
        self.dismissVC()
    }
    
    //UserSettingsVC
    @objc func handleTap() {
        self.dismissVC()
    }
    
    func dismissVC(){
        self.dismiss(animated: true)
    }
    
    func logout() {
        self.showHud()
        RestCloudService.shared.userDelegate = self
        RestCloudService.shared.logoutUser()
    }
    
    func didSelectMenu(model: MenuItems) {
        
        switch model.type {
        case .home:
            print("Home Clicked")
            self.pushToHomeVC()
        case .inquiry:
            print("Home clicked")
            self.pushToInquiryVC()
        case .fabric:
            print("Home clicked")
            self.pushToFabricVC()
        case .taskUpdate:
            print("Task Update Clicked")
            self.pushToTaskUpdateVC(type: .task)
        case .dataInput:
            print("Data Input Clicked")
            self.pushToTaskUpdateVC(type: .dataInput)
        case .userSettings:
            print("User Setting Clicked")
            self.pushToUserSettingsVC()
        case .language:
            print("Language Clicked")
            self.pushToLanguageVC()
        case .help:
            self.pushToAppManualVC()
        case .logout:
            print("Logout Clicked")
            self.logout()
             
        }
    }
  
    @objc func dismissViewController(shouldReload:Bool = false){
        self.dismissVC()
    }
}

extension MenuBarVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(menuItems.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SortByTableviewCell
        cell.setContent(item: menuItems[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = menuItems[indexPath.row]
        self.didSelectMenu(model: menu)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension MenuBarVC: RCUserDelegate {
    
    /// OTP request delegates
    func didRequestLogoutSuccess(message: String) {
        self.hideHud()
        
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.appDelegate().performLogout()
                self.dismissViewController(shouldReload: true)
            }
        })
    }
    
    func didFailedToRequestLogout(errorMessage: String) {
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: errorMessage), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.appDelegate().performLogout()
                self.dismissViewController(shouldReload: true)
            }
        })
    }
}

class SortByTableviewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var languageTitleLabel: UILabel!
    @IBOutlet var rightArrowIcon: UIImageView!
    
      override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.titleLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.titleLabel.textColor = .black
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 0
        self.titleLabel.adjustsFontSizeToFitWidth = false
    }
    
    func setContent(item: MenuItems, index: Int){
        
        self.titleLabel.text = item.title
        self.iconImageView.image = item.image
        self.languageTitleLabel.text = RMConfiguration.shared.language.uppercased()
       
        self.languageTitleLabel.isHidden = item.title == LocalizationManager.shared.localizedString(key: "languageText") ? false : true
        self.rightArrowIcon.isHidden = item.title == LocalizationManager.shared.localizedString(key: "languageText") ? false : true
    }
 
}

// MARK: Drag dismiss function
extension MenuBarVC {
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        sectionView.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        sectionView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.sectionView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        //sectionView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.sectionView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: true)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
}

extension MenuBarVC: UIGestureRecognizerDelegate{
    // UIGestureRecognizerDelegate method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true {
            return false
        }
        return true
    }
}

struct MenuItems {
    var type: MenuType = .taskUpdate
    var title: String
    var iconName: String
   
    var image: UIImage?{
        return UIImage(named: iconName)
    }
}

enum MenuType {
    case home
    case inquiry
    case fabric
    case taskUpdate
    case dataInput
    case userSettings
    case language
    case help
    case logout
}
