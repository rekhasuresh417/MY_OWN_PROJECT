//
//  AppDelegate.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 21/07/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaults = UserDefaults.standard
    let realmSchemaVersion: UInt64 = 0
    var workspaceDetails: WorkspaceDetails = WorkspaceDetails.init()
    var selectedLanguage, selectedLanguageId: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        ///Initialize realm database
        self.createRealmDatabase()
        
        ///Load localizable strings
        LocalizationManager.loadLocalizableStrings()
        
        ///Set Root View Controller
        self.setRootViewController()
        
        /// Get workspace list if staff loginned
        if RMConfiguration.shared.loginType == Config.Text.staff{
            self.getWorkspaceList()
        }
        
        ///  Set baseURL based on login type (ADMIN and STAFF)
        UIViewController.sharedWebClient.baseUrl = RMConfiguration.shared.loginType == Config.Text.user ? Config.baseURL : "\(Config.baseURL)staff/"
        
       // window?.overrideUserInterfaceStyle = .light

        // Set the status bar style globally
        UIApplication.shared.statusBarStyle = .lightContent // or .default for dark text color
        
        return true
    }

}

extension AppDelegate{
    
    /// Get workspace list
    func getWorkspaceList() {
        //getting workspace from the object if available
        let workspaceList :  [DMSWorkspaceList]? = UserDefaults.standard.retrieveCodable(for: "workspace")
        let currentWorkspace :  DMSWorkspaceList? = UserDefaults.standard.retrieveCodable(for: "currentWorkspace")
        
        if let list = workspaceList {
            self.workspaceDetails.workspaceList = list
            self.workspaceDetails.currentWorkspace = currentWorkspace
        }
        if let workspace = currentWorkspace{
            RMConfiguration.shared.role = workspace.role ?? ""
            RMConfiguration.shared.companyId = "\(workspace.companyId ?? "0")"
            RMConfiguration.shared.workspaceName = workspace.workspaceName ?? ""
            RMConfiguration.shared.workspaceType = workspace.workspaceType ?? ""
            RMConfiguration.shared.workspaceId = "\(workspace.workspaceId ?? "0")"
            RMConfiguration.shared.roleId = "\(workspace.roleId ?? "0")"
            RMConfiguration.shared.role = workspace.role ?? ""
        }
        
    }
 
    /// Set rootview controller
    func setRootViewController() {
        
        var rootVC: UIViewController? = nil
     
        if UIApplication.isFirstLaunch(){
            rootVC = UIViewController.from(storyBoard: .main, withIdentifier: .language)
        }else if hasUserSignedIn(){
            rootVC = UIViewController.from(storyBoard: .tabBar, withIdentifier: .tabBar)
        }else{
           rootVC = UIViewController.from(storyBoard: .main, withIdentifier: .signIn)
        }
    
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: rootVC!)
    }
   
    /// Checking user has been loggined In
    func hasUserSignedIn() -> Bool {
        let hasToken = RMConfiguration.shared.accessToken
        
        print("Access token:- \(hasToken)")
        if hasToken.count == 0 && hasToken.isEmpty {
            return false
        }
        return true
    }
 
    /// Display alert to intimate session in expired.
    func invalidSession(){
        let alert = UIAlertController(title: LocalizationManager.shared.localizedString(key: ""), message: LocalizationManager.shared.localizedString(key: "session_expiry_message"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(key: ""), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            alertWindows[alert] = nil // Dismiss alert window
            self.performLogout()
        })
        alert.addAction(okAction)
        DispatchQueue.main.async {
            alert.presentInNewWindow(animated: true, completion: nil)
        }
    }
  
    /// This function perform to delete/unpin all the Realm obects, local data and storages for the user.
    /// Also re-initializing selected language with Realm `ROConfiguration` object
    /// Finnaly will reset app state to sign-in and reset root viewcontroller
    func performLogout() {
        
        /// Clear all local data
        let currentLanguageId = RMConfiguration.shared.language
        RMConfiguration.shared.deleteAllRealmObjects()
        
        /// Re-initialize with existing language Id
        RMConfiguration.shared.language = currentLanguageId
  
        /// set default login type
        RMConfiguration.shared.loginType = Config.Text.staff
        UIViewController.sharedWebClient.baseUrl = Config.baseURL

        /// Update app state to sign-in and reset root view controller
        self.setRootViewController()
        
    }
 
}


extension AppDelegate{
    
    /// Create realm database with Configuration
    func createRealmDatabase(){
        Realm.Configuration.defaultConfiguration = self.configForRealm() // new configuration object for the default Realm
        do {
            _ = try Realm()
            print("Database created successfully @\(Realm.Configuration.defaultConfiguration.fileURL!)")
        } catch let error as NSError {
            print("Error to create database - \(error)")
        }
    }
    
    /// Configuration for Relam
    func configForRealm() -> Realm.Configuration{
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: self.realmSchemaVersion,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < self.realmSchemaVersion) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        
        return config
    }
}

extension AppDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      print(url)
      // Take decision according to URL
      return true
    }
}

