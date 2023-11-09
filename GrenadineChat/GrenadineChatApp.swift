//
//  GrenadineChatApp.swift
//  GrenadineChat
//
//  Created by Livsy on 08.11.2023.
//

import SwiftUI

@main
struct GrenadineChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var streamViewModel = StreamViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
