//
//  AppDelegate.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation
import UIKit
import StreamChat
import StreamChatSwiftUI
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var streamChat: StreamChat?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppConfigurator.configure()
        streamChat = StreamChatFactory.makeStreamChat()
        ChatClient.shared.connectUser()
        
        return true
    }
    
}
