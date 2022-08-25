//
//  NotificationHTTPManager.swift
//  MVCNotificationHTTPManager
//
//  Created by Jyoti on 25/08/2022.
//

import Foundation

class NotificationHTTPManager {
    static let shared : NotificationHTTPManager = NotificationHTTPManager()
    
    enum HTTPError : Error {
        case invalidURL
        case invalidResponse(Data?, URLResponse?)
    }
    
    public func get(urlString: String) {
        guard let url = URL(string: urlString) else {
            let dict = ["error": nil] as [String : Any?]
            NotificationCenter.default.post(name: Notification.Name.notificationHTTPDataDidUpdateNotification, object: self, userInfo: dict as [AnyHashable : Any])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                let dict = ["error": "nil"] as [String : Any]
                NotificationCenter.default.post(name: Notification.Name.notificationHTTPDataDidUpdateNotification, object: self, userInfo: dict as [AnyHashable : Any])
                return
            }
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    let dict = ["error": "nil"] as [String : Any?]
                    NotificationCenter.default.post(name: Notification.Name.notificationHTTPDataDidUpdateNotification, object: self, userInfo: dict as [AnyHashable : Any])

                    return
            }
            let dict = ["data": responseData.count] as [String : Any?]
            NotificationCenter.default.post(name: Notification.Name.notificationHTTPDataDidUpdateNotification, object: self, userInfo: dict as [AnyHashable : Any])

        }
        task.resume()
    }
}
