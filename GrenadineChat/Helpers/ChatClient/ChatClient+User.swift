//
//  ChatClient+User.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import StreamChat

extension ChatClient {
    
    func connectUser() {
        guard AuthManager.shared.user != nil,
              let userId = ChatClient.shared.currentUserId,
              let username = ChatClient.shared.currentUserController().currentUser?.name
        else { return }
        
        connectUser(userId: userId, username: username)
    }
    
    private func connectUser(userId: String, username: String) {
        ChatClient.shared.connectUser(
            userInfo: UserInfo(id: userId, name: username),
            token: .development(userId: userId)
        ) { error in
            
            guard let error else {
                print("\(username) is logged in")
                return
            }
            print("Can't connect user: \(error.localizedDescription)")
        }
    }
    
}
