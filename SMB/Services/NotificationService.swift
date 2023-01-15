//
//  NotificationService.swift
//  SMB
//
//  Created by Mateusz Dylewski on 12/01/2023.
//

import Foundation
import UserNotifications
import MapKit

class NotificationService: ObservableObject {
    
    @Published
    var notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.sound, .alert]
        notificationCenter
            .requestAuthorization(options: options) { result, _ in
                print("Notification Auth Request result: \(result)")
        }
    }
    
    func registerNotifications(shop: ShopModel) {
        removeNotifications(shop: shop)
        registerEntryNotifi(shop: shop)
        registerExitNotifi(shop: shop)
    }
    
    func removeNotifications(shop: ShopModel) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [
            shop.id + "entry",
            shop.id + "exit"
        ])
    }
    
    func removeNotifications(shopId: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [
            shopId + "entry",
            shopId + "exit"
        ])
    }
    
    private func registerEntryNotifi(shop: ShopModel) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Welcome to " + shop.name + "!"
        notificationContent.body = shop.description
        notificationContent.sound = .default

        let center = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        let region = CLCircularRegion(center: center, radius: Double(shop.range), identifier: shop.id + "entry")
        region.notifyOnEntry = true
        region.notifyOnExit = false

        let trigger = UNLocationNotificationTrigger(
            region: region,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: shop.id + "entry",
            content: notificationContent,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    private func registerExitNotifi(shop: ShopModel) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = shop.name + " says Goodbye!"
        notificationContent.body = "See you soon!"
        notificationContent.sound = .default

        let center = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        let region = CLCircularRegion(center: center, radius: Double(shop.range), identifier: shop.id + "exit")
        region.notifyOnEntry = false
        region.notifyOnExit = true

        let trigger = UNLocationNotificationTrigger(
            region: region,
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: shop.id + "exit",
            content: notificationContent,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        }
    }

}
