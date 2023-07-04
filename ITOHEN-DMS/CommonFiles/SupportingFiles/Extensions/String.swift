//
//  String.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

extension String {
    
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    func trimCharacters() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isKindOfVersion: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }
    
    func isValidUserID() -> Bool {
        let emailRegex = "^[a-zA-Z0-9\\-\\.\\_]{6,32}$"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        if valid {
            valid = !self.contains("..")
        }
        return valid
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        if valid {
            valid = !self.contains("..")
        }
        return valid
    }
    
    func checkCharactersSetNumbersOnly(string:String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return string == filtered
    }
    
    func isValidUsername() -> Bool {
        return !self.isEmptyOrWhitespace() && self.count <= 50
    }
    
    func isValidPassword() -> Bool {
        return !self.isEmptyOrWhitespace() && self.count >= 8
    }
    
    func isNumbersOnly() -> Bool{
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = self.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return self == filtered
    }
    
    func isNumbersAndSymbols(symbol: [String]) -> Bool{
        var allCharacters: String = "0123456789"
        symbol.forEach({allCharacters.append($0)})
        let inverseSet = NSCharacterSet(charactersIn: allCharacters).inverted
        let components = self.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return self == filtered
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func convertDict(modelString: String) -> [String: Any] {
        if let jsonData = modelString.data(using: .utf8) {
            if let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) {
                return dictionary as? [String : Any] ?? [:]
            }
        }
        
        return [:]
    }
    
     func convertArrayDict(modelString: String) -> [[String: Any]] {
         if let jsonData = modelString.data(using: .utf8) {
             if let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) {
                 return dictionary as? [[String : Any]] ?? []
             }
         }
         
         return []
     }
    
    func convertJSONString(dict: [String:Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        
        return ""
    }
  
    func convertJSONString(arrayDict: [[String:Any]]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: arrayDict, options: []) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        
        return ""
    }
 
    func convertByteToString(byte: Int64) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useAll] // .useMB,
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: byte)
        
        return string
    }
    
    func convertToNextDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }
    
    func toDate() -> Date? {
         let formatter = DateFormatter()
        formatter.dateFormat = Date.styleInspectDateFormat
         return formatter.date(from: self)
     }
    
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
       
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
  
    func convertDMSDateFormat(dateFormat: DateFormat) -> String{
        switch (dateFormat) {
        case .D_SP_M_SP_Y:
            return DMS_DateFormat.DD_SP_MMM_SP_YYYY.rawValue
        case .D_M_Y:
            return DMS_DateFormat.DD_MM_YYYY.rawValue
        case .Y_M_D:
            return DMS_DateFormat.YYYY_MM_DD.rawValue
        case .Y_SP_M_SP_D:
            return DMS_DateFormat.YYY_SP_MMM_SP_DD.rawValue
        case .Y_SL_M_SL_D:
            return DMS_DateFormat.YYY_SL_MMM_SL_DD.rawValue
        }
    }
  
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
   
    // Load HTML text
    func setHTMLFromString(htmlText: String) -> String {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.appFont(ofSize: 13.0, weight: .medium))\">%@</span>", htmlText)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        return attrStr.string
    }
    
    var htmlToAttributedString: NSAttributedString? {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.appFont(ofSize: 13.0, weight: .medium))\">%@</span>", self)
           guard let data = data(using: .utf8) else { return nil }
           do {
               return try NSAttributedString(data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                                             options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                                             documentAttributes: nil)
           } catch {
               return nil
           }
       }
       var htmlToString: String {
           return htmlToAttributedString?.string ?? ""
       }
    
    func getAlertSuccess(message: String) -> String{
        
        var msg = message.lowercased()
        switch msg {
        case Config.backEndAlertMessage.otpSentMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "otpSentMessage")
        case Config.backEndAlertMessage.contactAdminMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "contactAdminMessage")
        case Config.backEndAlertMessage.userNotFound.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "user_not_found")
        case Config.backEndAlertMessage.userFoundOTPSentMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "user_found_otp_sent_message")
        case Config.backEndAlertMessage.registerNotCompleted.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "notCompleteRegisterMessage")
        case Config.backEndAlertMessage.planExpired.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "planExpiredText")
            
            
        case Config.backEndAlertMessage.inCorrectOtpMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "inCorrectOtp")
        case Config.backEndAlertMessage.otpVerifiedMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "otpVerified")
            
        case Config.backEndAlertMessage.loggedOutSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "loggedOutSuccessMessage")
            
        case Config.backEndAlertMessage.dateRescheduleSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateRescheduleSuccessMessage")
        case Config.backEndAlertMessage.picChangeSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "picChangeSuccessMessage")
        case Config.backEndAlertMessage.dateAccomplishedSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateAccomplishedSuccessMessage")
        case Config.backEndAlertMessage.dateUpdatedSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateUpdatedSuccessMessage")
            
        case Config.backEndAlertMessage.dataInputUpdatedSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dataInputUpdatedSuccessMessage")
            
        case Config.backEndAlertMessage.generalSettingSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateRescheduleSuccessMessage")
        case Config.backEndAlertMessage.notifSettingSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "picChangeSuccessMessage")
        case Config.backEndAlertMessage.emailSettingSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateAccomplishedSuccessMessage")
        case Config.backEndAlertMessage.dashboardSettingSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateUpdatedSuccessMessage")
          
        case Config.backEndAlertMessage.subTaskAddedSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dateUpdatedSuccessMessage")
            
        case Config.backEndAlertMessage.alreadyUpdatedMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "alreadyUpdatedAccomplishedText")
        case Config.backEndAlertMessage.accomplishAllSubTask.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "pleaseAccomplishAllTheSubtasks")
        case Config.backEndAlertMessage.enterDateCorrectlyMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "enterDateCorrectlyMessage")
       
        case Config.backEndAlertMessage.startDateValidationMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "startDateValidation")
        case Config.backEndAlertMessage.endDateValidationMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "endDateValidation")
            
        case Config.backEndAlertMessage.subTaskDeletedSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "subTaskDeletedSuccessMessage")
         
        case Config.backEndAlertMessage.enterMainTaskMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "enterMainTaskDateMessage")
        case Config.backEndAlertMessage.reschduleSubTaskDateMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "rescheduleSubTaskDate")
       
            // Inquiry
        case Config.backEndAlertMessage.inquiryAddedSuccessMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "inquiryAddedSuccessMessage")
        case Config.backEndAlertMessage.selectFactoryText.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "selectFactoryText")
        case Config.backEndAlertMessage.inquirySentMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "inquirySentMessage")
        case Config.backEndAlertMessage.poGeneratedMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "poGeneratedMessage")
        case Config.backEndAlertMessage.factoryAddedMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "factoryAddedMessage")
        case Config.backEndAlertMessage.poGeneratedMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dataAddedSuccessfullyText")
        case Config.backEndAlertMessage.factoryAddedMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "dataUpdatedSuccessfullyText")
        
            // Fabric
        case Config.backEndAlertMessage.fabricContactAlreadyTakenMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "fabricContactAlreadyTakenMessage")
        case Config.backEndAlertMessage.fabricEmailAlreadyTakenMessage.lowercased():
            msg = LocalizationManager.shared.localizedString(key: "fabricEmailAlreadyTakenMessage")
            
        default:
            msg = message
        }
        return msg
    }
}
