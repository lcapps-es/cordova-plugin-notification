//
//  CordovaPluginNotification.swift
//  cordova-plugin-notification
//
//  Created by Luis Miguel Martín - 2017.
//

import UIKit
import UserNotifications

@objc( CordovaPluginNotification ) class CordovaPluginNotification : CDVPlugin, UNUserNotificationCenterDelegate {
    func _alert( msg:String ){
        
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )
        
        if msg.characters.count > 0 {
            let toastController: UIAlertController =
                UIAlertController(
                    title: "",
                    message: msg,
                    preferredStyle: .alert
            )
            
            self.viewController?.present(
                toastController,
                animated: true,
                completion: nil
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toastController.dismiss(
                    animated: true,
                    completion: nil
                )
            }
            
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }
        
        self.commandDelegate!.send(
            pluginResult,
            callbackId: nil
        )
    }
    
    @objc( alert: )
    func alert(command: CDVInvokedUrlCommand) {
        
        let msg = command.arguments[0] as? String ?? ""
        
        self._alert(msg: msg);
    }
    
    @objc( notification: )
    func notification(command: CDVInvokedUrlCommand) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            
            let opta = UNNotificationAction(identifier: "opt1",
                                          title: "opcion1", options: [])
            let optb = UNNotificationAction(identifier: "opt2",
                                          title: "opcion2", options: [])
            
            let category = UNNotificationCategory(identifier: "TEST",
                                                  actions: [opta, optb],
                                                  intentIdentifiers: [],
                                                  options: [])
            
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            let center = UNUserNotificationCenter.current();
            let content = UNMutableNotificationContent()
            content.title = "TITULO"
            content.body = "CONTENIDO"
            content.categoryIdentifier = "TEST"
            content.userInfo = ["customData": "aaaa"]
            content.sound = UNNotificationSound.default()
            let calendar = Calendar.current;
            let today = Date()
            let date  = calendar.date(byAdding: .second, value: 10, to: today)
            
            let comp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("NIENTRA");
        let identifier = response.actionIdentifier
        let request = response.notification.request
        if identifier == "opt1"{
            print("PASA1");
            self._alert(msg: "ENTRA BOTON1")
        }
        
        if identifier == "opt2"{
            print("PASA2");
            self._alert(msg: "ENTRA BOTON2")
        }
        
        completionHandler()
    }
}
