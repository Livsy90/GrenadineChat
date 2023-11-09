//
//  StreamChatFactory.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation
import SwiftUI
import StreamChatSwiftUI
import StreamChat

enum StreamChatFactory {
    
    private enum Constants {
        static let minimumSwipeGestureDistance: CGFloat = 50
    }
    
    static func streamChat() -> StreamChat {
        StreamChat(
            chatClient: ChatClient.shared,
            utils: Utils(messageListConfig: messageListConfig())
        )
    }
    
    private static func messageListConfig() -> MessageListConfig {
        var customTransition: AnyTransition {
            .scale.combined(with:
                AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                )
            )
        }
        
        let messageDisplayOptions = MessageDisplayOptions(
            animateChanges: true,
            minimumSwipeGestureDistance: Constants.minimumSwipeGestureDistance,
            currentUserMessageTransition: customTransition,
            otherUserMessageTransition: customTransition,
            shouldAnimateReactions: true
        )
        
        let messageListConfig = MessageListConfig(
            typingIndicatorPlacement: .navigationBar,
            messageDisplayOptions: messageDisplayOptions,
            doubleTapOverlayEnabled: true,
            showNewMessagesSeparator: true
        )
        
        return messageListConfig
    }
}
