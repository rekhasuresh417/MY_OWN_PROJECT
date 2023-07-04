//
//  UserDefaults.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

extension UserDefaults{
    
    /// Groups last update date for page number
    func setLoginnedUserId(userId: String){
        setValue(userId, forKey: "\(Config.AppConstants.USER_ID)")
    }
    
    func getLoginnedUserId() -> String?{
        return string(forKey: "\(Config.AppConstants.USER_ID)")
    }
    
    func removeAllData(){
        if let appDomain = Bundle.main.bundleIdentifier {
          UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    func storeCodable<T: Codable>(_ object: T, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch let error {
            print("Error encoding: \(error)")
        }
    }
    
    func retrieveCodable<T: Codable>(for key: String) -> T? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print("Error decoding: \(error)")
            return nil
        }
    }
}
