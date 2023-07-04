
import UIKit

/// RestCloudService is base class for all rest API calls
/// The different delegates created based on category wise to share the Parse API data
/// A common function  `handleParseError` used to handle all the Parse API errors
/// These error functions are handling Session invalid and Plan expiration process.

public class RestCloudService {
    
    public init() { }
    
    public static let shared = RestCloudService()
    
    var userDelegate: RCUserDelegate? = nil
    var dashboardDelegate: RCDashboardDelegate? = nil
    var taskDelegate: RCTaskDelegate? = nil
    var taskUpdateDelegate: RCTaskUpdateDelegate? = nil
    var productionDelegate: RCProductionDelegate? = nil
    var settingsDelegate: RCSettingsDelegate? = nil
    var inquiryDelegate: RCInquiryDelegate? = nil
    var fabricDelegate: RCFabricDelegate? = nil
    var factoryContactDelegate: RCFactoryContactDelegate? = nil
    var purchaseOrderDelegate: RCPurchaseOrderDelegate? = nil
    var materialsAndLabelDelegate: RCMaterialsAndLabelDelegate? = nil
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /// A common function to handle parse errors from Parse API calls
    func handleRestError(error: NSError){
       if error.code == Config.ErrorCode.UN_AUTHENTICATED {
            self.appDelegate.performLogout()
        }
    }
}
