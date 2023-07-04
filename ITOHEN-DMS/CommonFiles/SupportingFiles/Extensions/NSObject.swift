
import Foundation

extension NSObject {
    
    @objc var logTag: String {
        return String(describing: type(of: self))
    }
    
    func showHud(title: String = "",
                 subTitle: String = "") {
        
        self.hideHud()
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(.light)
        
        var status: String = title
        if subTitle.count > 0 {
            if status.count > 0 {
                status = status + "\n" + subTitle
            }else {
                status = subTitle
            }
        }
        
        DispatchQueue.main.async {
            if status.count > 0 {
                SVProgressHUD.show(withStatus: status)
            }else {
                SVProgressHUD.show()
            }
        }
    }
    
   func hideHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func hideHudWithMessage(title: String,
                            detailText: String) {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "\(title) \n \(detailText)")
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setDefaultStyle(.light)
            SVProgressHUD.dismiss(withDelay: 5.0)
        }
    }
}

extension Notification{
    static let reSyncGroup = Notification.Name("reSyncGroup")
    static let reloadFavouriteUsers = Notification.Name("reloadFavouriteUsers")
    static let reloadGroupInputFields = Notification.Name("reloadGroupInputFields")
    static let reSyncStyle = Notification.Name("reSyncStyle")
    static let reloadStyleInputFields = Notification.Name("reloadStyleInputFields")
    static let reloadInspectionInputFields = Notification.Name("reloadInspectionInputFields")
    static let reloadInlineInspection = Notification.Name("reloadInlineInspection")
    static let reloadMeasurementFormats = Notification.Name("reloadMeasurementFormats")
    static let reloadMeasurementInspections = Notification.Name("reloadMeasurementInspections")
    static let reloadSummaryReport = Notification.Name("reloadSummaryReport")
    static let reloadSummaryContentVC = Notification.Name("reloadSummaryContentVC")
}
