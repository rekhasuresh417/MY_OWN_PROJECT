//
//  LanguageSelectionVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class LanguageSelectionVC: UIViewController{
    
    @IBOutlet var topView:UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var preferLabel:UILabel!
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var continueButton:UIButton!
    
    var uiFrom: String = ""
    var selectedLanguageId: String = "1"
    
    var languages: [Languages]? = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var tabBarVC: TabBarVC{
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
    }
    
    var signInVC: SignInVC{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.userDelegate = self
        self.setupUI()
        self.getLanguages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupUI(){
        self.topView.applyTopViewStyle(radius: 40.0)
        self.iconImageView.image = Config.Images.shared.getImage(imageName: Config.Images.languageIcon)
        
        self.preferLabel.text = LocalizationManager.shared.localizedString(key: "preferLanguageText")
        self.preferLabel.numberOfLines = 0
        self.preferLabel.textColor = .white
        self.preferLabel.textAlignment = .left
        self.preferLabel.font = UIFont.appFont(ofSize: 24.0, weight: .bold)
        
        self.continueButton.backgroundColor = .primaryColor()
        self.continueButton.layer.cornerRadius = self.continueButton.frame.height / 2.0
        self.continueButton.setTitle(LocalizationManager.shared.localizedString(key: "continueButtonText"), for: .normal)
        self.continueButton.setTitleColor(.white, for: .normal)
        self.continueButton.titleLabel?.font = UIFont.appFont(ofSize: 16.0, weight: .bold)
        self.continueButton.addTarget(self, action: #selector(self.continueButtonTapped(_:)), for: .touchUpInside)
     
        /// setup defualt language
        appDelegate().selectedLanguage = "en"
        
        if self.uiFrom != "sidemenu"{
            RMConfiguration.shared.language = "en"
            RMConfiguration.shared.languageId = "1"
        }
        
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getLanguages(){
        self.showHud()
        let params: [String:String] = [ "company_id": RMConfiguration.shared.companyId,
                                       "workspace_id": RMConfiguration.shared.workspaceId,
                                       "user_id": RMConfiguration.shared.userId,
                                       "staff_id": RMConfiguration.shared.staffId
        ]
        print(params)
        RestCloudService.shared.getLanguages(params: params)
    }
    
    func updateLanguage(){
        self.showHud()
        let params: [String:String] = [ "companyId": RMConfiguration.shared.companyId,
                                       "workspaceId": RMConfiguration.shared.workspaceId,
                                       "userId": RMConfiguration.shared.userId,
                                       "staffId": RMConfiguration.shared.staffId,
                                       "languageId": self.selectedLanguageId
        ]
        print(params)
        RestCloudService.shared.updateLanguage(params: params)
    }
    
    @objc func continueButtonTapped(_ sender: UIButton){
      
        if self.uiFrom == "sidemenu"{
            self.updateLanguage()
        }else{
            /// you have to update in verifyOTP  screen when there is no selectedLanguageId
            self.appDelegate().selectedLanguageId = RMConfiguration.shared.languageId
            self.reDirectNextView()
        }
    }
    
    func reDirectNextView(){
        if self.uiFrom == "sidemenu"{
            self.navigationController?.popViewController(animated: true)
        }else{
            if self.appDelegate().hasUserSignedIn(){
                self.navigationController?.pushViewController(self.tabBarVC, animated: true)
            }else{
                UIApplication.firstTimeLaunched() // update launch flag
                self.navigationController?.pushViewController(self.signInVC, animated: true)
            }
        }
    }
}

extension LanguageSelectionVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LanguageTVCell
        if let langauage = self.languages?[indexPath.row], indexPath.row < self.languages?.count ?? 0{
            cell.setContent(language: langauage, index: indexPath.row, target: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.languages?.count ?? 0{
            self.selectedLanguageId = "\(self.languages?[indexPath.row].id ?? 1)"
            
            if self.uiFrom != "sidemenu"{
                appDelegate().selectedLanguage = "\(self.languages?[indexPath.row].lang_code ?? "en")"
            }
            
            RMConfiguration.shared.language = self.languages?[indexPath.row].lang_code ?? "en"
            RMConfiguration.shared.languageId = "\(self.languages?[indexPath.row].id ?? 1)"
            
            NotificationCenter.default.post(name: .reloadHomeItemsVC, object: nil)
            NotificationCenter.default.post(name: .reloadTabBarVC, object: nil)
            NotificationCenter.default.post(name: .reloadUserSettingsVC, object: nil)
            NotificationCenter.default.post(name: .reloadOrderFilterVC, object: nil)
            
            tableView.reloadData()
        }
       
    }
}

extension LanguageSelectionVC: RCUserDelegate {
    
    // Languages delegate
    @objc func didReceiveLanguages(language: [Languages]) {
        self.hideHud()
        self.languages = language//.filter( {$0.lang_code == "en" || $0.lang_code == "jp"})
    }
    
    func didFailedToReceiveLanguages(errorMessage: String) {
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
    
    /// Update language  delegates
    func didReceiveUpdateLanguage(message: String){
        self.hideHud()
        self.reDirectNextView()
    }
    
    func didFailedToReceiveUpdateLanguage(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
}
