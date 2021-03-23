# NFAppStoreUpdateNotifier

[![CI Status](https://img.shields.io/travis/nferocious76/NFAppStoreUpdateNotifier.svg?style=flat)](https://travis-ci.org/nferocious76/NFAppStoreUpdateNotifier)
[![Version](https://img.shields.io/cocoapods/v/NFAppStoreUpdateNotifier.svg?style=flat)](https://cocoapods.org/pods/NFAppStoreUpdateNotifier)
[![License](https://img.shields.io/cocoapods/l/NFAppStoreUpdateNotifier.svg?style=flat)](https://cocoapods.org/pods/NFAppStoreUpdateNotifier)
[![Platform](https://img.shields.io/cocoapods/p/NFAppStoreUpdateNotifier.svg?style=flat)](https://cocoapods.org/pods/NFAppStoreUpdateNotifier)

## Features
- [x] Light weight
- [x] Fetch and compare `local | installed` and `live` version
- [x] Redirect to `App's Page`
- [x] Straight forward and easy to use

## Requirements
- iOS 13.0+
- Xcode 12+
- Swift 5+

## Installation

#### CocoaPods

`NFAppStoreUpdateNotifier` is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your `Podfile`:

```ruby
pod 'NFAppStoreUpdateNotifier'
```

``
To run the example project, clone the repo, and run `pod install` from the Example directory first.
``

#### Manually

1. Download and drop ```/Pod/Classes```folder in your project.  
2. Congratulations!

## Usage

```Swift

import NFAppStoreUpdateNotifier

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
 
    // set your app store app id
    NFAppStoreUpdateNotifier.shared.appStoreAppId = "YOUR_APP_STORE_ID"
    // set to true or leave it if you wish to see event logs. this defaults to true 
    NFAppStoreUpdateNotifier.shared.isLoggingEnabled = true

    return true
}
```

```Swift
/**
 * in viewWillAppear(animated:)
 * call `startAppVersionCheck()`
 */

func startAppVersionCheck() {
    // open loading spinner
    // check if new version is available
    NFAppStoreUpdateNotifier.shared.checkAppVersion { [weak self] (hasNewVersion, error) in
        guard let self = self else { return }
        // close loading spinner
        
        // check and show error?
        if let error = error {
            // handle error
            let message = (error as NSError).userInfo["message"] as? String ?? String(error.localizedDescription)
            let proceedAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            self.showAlert(withTitle: "Error", message: message, proceedAction: proceedAction)
            return
        }
        
        if hasNewVersion { // open persistent alert
            let proceedAction = UIAlertAction(title: "Proceed", style: .default) { _ in
                // Open the AppStore page where user can update their local app. This uses the id set in `appStoreAppId`.
                NFAppStoreUpdateNotifier.shared.openItunesUpdate { [weak self] (finish, error) in
                    guard let self = self else { return }
                    if let error = error {
                        let message = (error as NSError).userInfo["message"] as? String ?? String(error.localizedDescription)
                        let proceedAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        self.showAlert(withTitle: "Error", message: message, proceedAction: proceedAction)
                    }
                }
            }
            
            self.showAlert(withTitle: "New Version Available", message: "Update Now to Version: \(NFAppStoreUpdateNotifier.shared.lastVersionChecked)", proceedAction: proceedAction)
        }
    }
}

func showAlert(withTitle title: String, message: String, proceedAction: UIAlertAction) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(proceedAction)
    present(alertController, animated: true, completion: nil)
}

```

## Author

Neil Francis Ramirez Hipona, nferocious76@gmail.com

## License

`NFAppStoreUpdateNotifier` is available under the MIT license. See the [LICENSE](https://github.com/nferocious76/NFAppStoreUpdateNotifier/blob/main/LICENSE) file for more info.
