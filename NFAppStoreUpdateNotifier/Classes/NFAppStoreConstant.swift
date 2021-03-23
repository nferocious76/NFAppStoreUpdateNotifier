//
//  NFAppStoreConstant.swift
//  NFAppStoreUpdateNotifier
//
//  Created by Neil Francis Hipona on 3/23/21.
//

import Foundation

public let NFAppStoreUpdateNotifierQueue = DispatchQueue(label: "com.NFAppStoreUpdateNotifierQueue.main-thread (background)", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .main)

public let kNFAppStoreBundleID = "CFBundleIdentifier"
public let kNFAppStoreVersionString = "CFBundleShortVersionString"


public let kNFAppStoreLookupURL = "https://itunes.apple.com/lookup"
public let kNFAppStoreAppSchemeURL = "itms-apps://apps.apple.com/app"

let kNFAppStoreResponseResults = "results"
let kNFAppStoreResponseVersion = "version"

let kNFAppStoreErrorResponseDomain = "com.NFAppStoreUpdateNotifier.error"
let kNFAppStoreErrorResponseMessage = "message"
