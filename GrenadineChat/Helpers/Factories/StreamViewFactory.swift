//
//  GrenadineViewFactory.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

final class StreamViewFactory: ViewFactory {
    
    static let shared: StreamViewFactory = .init()
    
    @Injected(\.chatClient) public var chatClient
    
    private init() {}
    
    func navigationBarDisplayMode() -> NavigationBarItem.TitleDisplayMode {
        .inline
    }
        
}

//extension StreamViewFactory {
//    func makeChatChannelView(
//        channelController: ChatChannelController,
//        viewModel: ChatChannelViewModel
//    ) -> some View {
//        
//        ChatChannelView(
//            viewFactory: StreamViewFactory.shared,
//            viewModel: viewModel,
//            channelController: channelController
//        )
//    }
//    
//    func makeChatChannelListView(viewModel: ChatChannelListViewModel) -> some View {
//        ChatChannelListView(
//            viewFactory: StreamViewFactory.shared,
//            viewModel: viewModel,
//            embedInNavigationView: false
//        )
//    }
//}
