//
//  ViewController.swift
//  MVCNotificationHTTPManager
//
//  Created by Jyoti on 25/08/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelDownloaded: UILabel!

    var dataDownloaded = 0 {
           didSet {
               DispatchQueue.main.async(execute: {
                   [weak self] () -> Void in
                   guard let self = self else {return}
                   self.labelDownloaded.text = "Objects downloaded : \(self.dataDownloaded)"
               })
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRcvd(withNotification: )), name: Notification.Name.notificationHTTPDataDidUpdateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func notificationRcvd(withNotification notification : NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        if let data = userInfo["data"] as? Int {
            dataDownloaded += data
        }
    }
    
    @IBAction func buttonDownloadClicked(_ sender: UIButton) {
        NotificationHTTPManager.shared.get(urlString: baseUrl + breachesExtensionURL)
    }

}

extension Notification.Name {
    static let notificationHTTPDataDidUpdateNotification = Notification.Name("NotificationHTTPDataDidUpdateNotification")
}

