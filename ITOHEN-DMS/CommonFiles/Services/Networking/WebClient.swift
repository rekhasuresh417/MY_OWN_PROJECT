//
//  WebClient.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.

import Foundation
import UIKit

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
   public init<A, E>(baseUrl: String, resource: Resource<A, E>) {
        var components = URLComponents(string: baseUrl)!
        let resourceComponents = URLComponents(string: resource.path.absolutePath)!
        
        components.path = Path(components.path).appending(path: Path(resourceComponents.path)).absolutePath
        components.queryItems = resourceComponents.queryItems
        
        switch resource.method {
        case .get, .delete:
            var queryItems = components.queryItems ?? []
            queryItems.append(contentsOf: resource.params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            })
            components.queryItems = (queryItems.count > 0) ? queryItems : nil
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
   public init<A, E>(baseUrl: String, resource: Resource<A, E>) {
        let url = URL(baseUrl: baseUrl, resource: resource)
        self.init(url: url)
        httpMethod = resource.method.rawValue
        resource.headers.forEach{
            setValue($0.value, forHTTPHeaderField: $0.key)
        }
        switch resource.method {
        case .post, .put:
           
            let plainText = resource.params.toJsonString()
         
            let aes = EasyAES.init(key: Config.aesKey, bit: 256, andIV: Config.aesIV)
            let cipherText = aes.encrypt(plainText)
            /*let key = Config.encryptKey
            let cryptLib = CryptLib()
            let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: plainText, key: key)
            */
            print("Encrypted", cipherText,"/n BaseURL", baseUrl)
            httpBody = cipherText.data(using: String.Encoding.utf8)
            //httpBody = try! JSONSerialization.data(withJSONObject: (resource.groupOfParams.count > 0) ? resource.groupOfParams : resource.params, options: [])
        default:
            break
        }
    }
}

open class WebClient {
    public var baseUrl: String
    public var bearerToken: String?
    public var deviceToken: String?
    public var workspace: String?
    public var preferredLanguage: String?
    
    public var commonParams: [String: Any] = [:]
    let defaults = UserDefaults.standard
    
    public init(baseUrl: String, bearerToken: String, deviceToken: String, workspace: String, preferredLanguage: String) {
        self.baseUrl = baseUrl
        self.bearerToken = bearerToken
        self.deviceToken = deviceToken
        self.workspace = workspace
        self.preferredLanguage = preferredLanguage
    }
 
    public func saveHeaderData(_ application: UIApplicationDelegate, bearerToken: String, deviceToken: String, workspace: String, preferredLanguage: String) {
        self.bearerToken = bearerToken
        self.deviceToken = deviceToken
        self.workspace = workspace
        self.preferredLanguage = preferredLanguage
    }
    
    public func load<A, CustomError>(resource: Resource<A, CustomError>,
                                     completion: @escaping (Result<A, CustomError, Any>) ->()){
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.noInternetConnection))
            return
        }
        
        var newResouce = resource
        newResouce.params = newResouce.params.merging(commonParams) { spec, common in
            return spec
        }
        
        var request = URLRequest(baseUrl: baseUrl, resource: newResouce)
        let hasToken = RMConfiguration.shared.accessToken
        
        if hasToken.count > 0, !hasToken.isEmpty{
            request.addValue("Bearer \(hasToken)", forHTTPHeaderField: "Authorization")
        }

        print("BASEURL:", baseUrl)
        /// Device details
        request.addValue("iOS", forHTTPHeaderField: "platform")
        request.addValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: "device-id")
        request.addValue(UIDevice.current.systemVersion, forHTTPHeaderField: "os-version")
        request.addValue(UIApplication.release, forHTTPHeaderField: "app-version")
        request.addValue(UIDevice.current.model, forHTTPHeaderField: "mobile-model")

        print("HEADER:", "baseURL:\(baseUrl)", "bearer-\(hasToken)")
      
        
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in

            print(data as Any, response as Any)
            // Parsing incoming data
        guard let response = response as? HTTPURLResponse else {
                completion(.failure(.other))
                return
            }
            
            print("statusCode:", response.statusCode)

            if (200..<300) ~= response.statusCode {
                // Convert HTTP Response Data to a String
               
                let aes = EasyAES.init(key: Config.aesKey, bit: 256, andIV: Config.aesIV)
                if let getData = data, let dataString = String(data: getData, encoding: .utf8) {
                    print("encryptedstring:\n \(dataString)")
                    let decryptedString = aes.decrypt(dataString)
                    print("decryptedString:\n \(decryptedString.utf8)")
                    completion(Result(value: resource.parse(Data(decryptedString.utf8)), or: .other, status: response))
                }
                
                /*let cryptLib = CryptLib()

                if let getData = data, let dataString = String(data: getData, encoding: .utf8) {
                    print("encryptedstring:\n \(dataString)")
                    
                    let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: "\(dataString)", key: Config.encryptKey)
                    print("decryptedString \(decryptedString! as String)")
                  
                    if let decrypt = decryptedString{
                        completion(Result(value: resource.parse(Data(decrypt.utf8)), or: .other, status: response))
                    }
                }
               */
            } else if response.statusCode == 401 {
                completion(.failure(.unauthorized))
            } else {
                completion(.failure(data.flatMap(resource.parseError).map({.custom($0)}) ?? .other))
            }
        }
        
        task.resume()
    }
}

extension Dictionary {
   func toJsonString() -> String {
     do {
           let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])

           let jsonString = String(data: jsonData, encoding: .utf8)

        return jsonString ?? ""
       } catch {
           print(error.localizedDescription)
        return ""
       }
  }
}
