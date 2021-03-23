//
//  ViewController.swift
//  NFAppStoreUpdateNotifier
//
//  Created by Neil Francis Ramirez Hipona on 03/23/2021.
//  Copyright (c) 2021 Neil Francis Ramirez Hipona. All rights reserved.
//

import UIKit
import NFAppStoreUpdateNotifier

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
}

