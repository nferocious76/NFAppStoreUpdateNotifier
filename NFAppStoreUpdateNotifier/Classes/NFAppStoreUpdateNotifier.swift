//
//  NFAppStoreUpdateNotifier.swift
//  NFAppStoreUpdateNotifier
//
//  Created by Neil Francis Hipona on 3/23/21.
//

import Foundation
import Alamofire

public class NFAppStoreUpdateNotifier: NSObject {
    
    static public let shared = NFAppStoreUpdateNotifier()
    
    /// Enables `debug` logging. Defaults to `true`
    public var isLoggingEnabled: Bool = true
    
    /// App's AppStore ID
    public var appStoreAppId: String = "id497799835" /// Xcod‪e‬ AppStore ID
    
    /// Last version checked
    public var lastVersionChecked: String {
        return liveVersion
    }
    
    /// Hold fetched live version
    private var liveVersion: String = "0.0.0"
    
    private
    override init() {
        super.init()
    }
}

extension NFAppStoreUpdateNotifier {
    
    public func checkAppVersion(openAlertCallback callback: @escaping (_ hasNewVersion: Bool, _ error: Error?) -> Void) {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let bundleID = infoDictionary[kNFAppStoreBundleID]
        else {
            if isLoggingEnabled { debugPrint("NFAppStoreUpdateNotifier:-- Unable to fetch App's bundle identifier.") }
            let error = NSError(domain: kNFAppStoreErrorResponseDomain, code: 500, userInfo: [kNFAppStoreErrorResponseMessage: "Unable to fetch App's bundle identifier."])
            callback(false, error)
            return }
        
        let itunesURL = "\(kNFAppStoreLookupURL)?bundleId=\(bundleID)"
        
        AF
            .request(itunesURL, method: .get, encoding: JSONEncoding.default)
            .responseJSON { [weak self] (response) in
                guard let self = self else { return }
                
                if let error = response.error {
                    if self.isLoggingEnabled { debugPrint("NFAppStoreUpdateNotifier:-- Request Error: \(error.localizedDescription)") }
                    callback(false, error)
                }else{
                    guard let data = response.value as? [String: Any],
                          let results = data[kNFAppStoreResponseResults] as? [[String: Any]],
                          let result = results.first,
                          let appStoreVersion = result[kNFAppStoreResponseVersion] as? NSString,
                          let locaVersion = infoDictionary[kNFAppStoreVersionString] as? NSString
                    else {
                        if self.isLoggingEnabled { debugPrint("NFAppStoreUpdateNotifier:-- Request Response - \(bundleID):    \(response.value ?? "null")") }
                        let error = NSError(domain: kNFAppStoreErrorResponseDomain, code: 400, userInfo: [kNFAppStoreErrorResponseMessage: "Bad parameter."])
                        callback(false, error)
                        return }
                    
                    self.liveVersion = appStoreVersion as String
                    let formattedVersion = appStoreVersion.replacingOccurrences(of: ".", with: "")
                    let formattedLocalVersion = locaVersion.replacingOccurrences(of: ".", with: "")
                    let appStoreVer = Int(formattedVersion) ?? 0
                    let localVer = Int(formattedLocalVersion) ?? 0
                    let isUpdateAvailable = appStoreVer > localVer
                    
                    if self.isLoggingEnabled { debugPrint("NFAppStoreUpdateNotifier:-- New AppStore update is available: \(isUpdateAvailable) for bundle: \(bundleID) with new version: \(appStoreVersion)") }
                    callback(isUpdateAvailable, nil)
                }
            }
    }
    
    public func openItunesUpdate(completion: ((_ finish: Bool, _ error: Error?) -> Void)? = nil) {
        let appStoreLink = "\(kNFAppStoreAppSchemeURL)/\(appStoreAppId)"
        if let appStoreURL = URL(string: appStoreLink), UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:]) { [weak self] finish in
                guard let self = self else { return }
                if self.isLoggingEnabled { debugPrint("NFAppStoreUpdateNotifier:-- App Store has been opened with new version") }
                completion?(finish, nil)
            }
        }else{
            if self.isLoggingEnabled { debugPrint("NFAppStoreUpdateNotifier:-- Can't open AppStore URL: \(appStoreLink)") }
            let error = NSError(domain: kNFAppStoreErrorResponseDomain, code: 500, userInfo: [kNFAppStoreErrorResponseMessage: "Unable to fetch App's bundle identifier."])
            completion?(true, error)
        }
    }
}
