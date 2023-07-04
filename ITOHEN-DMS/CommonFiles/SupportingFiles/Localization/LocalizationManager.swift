//
//  LocalizationManager.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class LocalizationManager{
    
    private init() { }
    
    public static let shared = LocalizationManager()
    
    private static var appTexts: Dictionary<String, AnyObject> = [:]
    
    private static var logTag: String {
        return String(describing: type(of: self))
    }
    
    static func loadLocalizableStrings() {
        var language = Config.AppLanguages.first(where: {$0.code == RMConfiguration.shared.language})
        if language == nil { // safe case
            language = Config.AppLanguages.first
            RMConfiguration.shared.language = language?.code ?? "en"
        }
        do {
            if let file = Bundle.main.url(forResource: language?.jsonFile, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? Dictionary<String, AnyObject> {
                    LocalizationManager.appTexts = object
                    RMLogs.shared.log(type: .INFO, tag: logTag, message: "Loaded localizable strings for language -  \(language!.code)")
                } else {
                    RMLogs.shared.log(type: .ERROR, tag: logTag, message: "Invalid JSON - Failed to load localizable strings for language - \(language!.code)")
                }
            } else {
                RMLogs.shared.log(type: .ERROR, tag: logTag, message: "No JSON file exists - Failed to load localizable strings for language - \(language!.code)")
            }
        } catch {
            print(error.localizedDescription)
            RMLogs.shared.log(type: .ERROR, tag: logTag, message: "Failed to load localizable strings for language -  \(language!.code)")
        }
    }
    
    func localizedString(key: String) -> String {
        if let value = LocalizationManager.appTexts[key] as? String {
            return value
        }
        return ""
    }
  
    func localizedStrings(key: String) -> [String] {
        if let value = LocalizationManager.appTexts[key] as? [String] {
            return value
        }
        return []
    }
}
