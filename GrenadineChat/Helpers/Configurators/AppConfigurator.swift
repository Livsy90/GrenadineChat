//
//  AppConfigurator.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation
import StreamChat
import FirebaseCore

enum AppConfigurator {
    
    private enum Constants {
        static let apiKey: String =  "jvxhhtp3ddr3"
    }
    
    static func configure() {
        configureChatClient()
        FirebaseApp.configure()
    }
    
    private static func configureChatClient() {
        var config = ChatClientConfig(apiKeyString: Constants.apiKey)
        config.isLocalStorageEnabled = true
        let client = ChatClient(config: config)
        
        ChatClient.shared = client
    }
        
}
