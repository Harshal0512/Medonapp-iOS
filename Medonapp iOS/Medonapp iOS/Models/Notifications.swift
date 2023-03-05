//
//  Notifications.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 05/03/23.
//

import Foundation
class NotificationElement: Codable {
    var id: Int?
    var timestamp, message: String?
    var isRead: Bool?
    var type: String?
    var senderID: Int?
    var senderName: String?
    var senderURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, timestamp, message, isRead, type
        case senderID = "senderId"
        case senderName
        case senderURL = "senderUrl"
    }

    init(id: Int?, timestamp: String?, message: String?, isRead: Bool?, type: String?, senderID: Int?, senderName: String?, senderURL: String?) {
        self.id = id
        self.timestamp = timestamp
        self.message = message
        self.isRead = isRead
        self.type = type
        self.senderID = senderID
        self.senderName = senderName
        self.senderURL = senderURL
    }
    
    static private var notifications: Notifications = Prefs.notifications
    
    static func refreshNotifications(completionHandler: @escaping(Bool) -> ()) {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .getNotificationsWithID(User.getUserDetails().patient!.id!), method: .get, isJSONRequest: false).executeQuery() { (result: Result<Notifications, Error>) in
            switch result{
            case .success(_):
                try? NotificationElement.setNotifications(notifications: result.get())
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    static func getNotifications() -> Notifications {
        return notifications
    }
    
    static func clearNotifications() {
        notifications = Notifications()
    }
    
    static func setNotifications(notifications: Notifications) {
        self.notifications = notifications
        saveToPrefs()
    }
    
    static func saveToPrefs() {
        Prefs.notifications = notifications
    }
    
    static func loadFromPrefs() {
        notifications = Prefs.notifications
    }
}

typealias Notifications = [NotificationElement]
