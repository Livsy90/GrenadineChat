//
//  GrenadineViewModelFactory.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation
import StreamChat
import StreamChatSwiftUI

enum GrenadineViewModelFactory {
    
    private enum Constants {
        static let pageSize: Int = 10
    }
    
    enum ChannelListKind {
        case chats
        case groups
        
        var channelType: ChannelType {
            switch self {
            case .chats:
                    .messaging
            case .groups:
                    .team
            }
        }
    }
    
    static func makeChannelListViewModel(_ kind: ChannelListKind) -> ChatChannelListViewModel {
        ChatChannelListViewModel(channelListController: ChatClient.shared.channelListController(query: .init(filter: .and([.equal(.type, to: kind.channelType), .containMembers(userIds: [ChatClient.shared.currentUserId ?? ""])]), pageSize: Constants.pageSize)))
    }
    
}
