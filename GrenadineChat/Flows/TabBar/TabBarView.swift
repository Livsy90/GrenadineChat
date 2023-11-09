//
//  TabBarView.swift
//  GrenadineChat
//
//  Created by Livsy on 08.11.2023.
//

import SwiftUI
import StreamChatSwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    var body: some View {
        ZStack {
            TabView {
                ChannelListView(type: .messaging)
                    .tabItem {
                        Label("Chats", systemImage: "message")
                    }
                
//                ChatChannelsListView(type: .team)
//                    .tabItem {
//                        Label("Groups", systemImage: "person.3.fill")
//                    }
            }
            
//            SideMenuProfileView(content: AnyView(ProfileView()))
        }
        .onAppear {
            streamViewModel.loadOnlineUsers()
        }
        .fullScreenCover(isPresented: $streamViewModel.isShowSelectedChannel) {
            DirectChatChannelView()
        }
        .overlay {
            ZStack {
                if streamViewModel.isLoading {
                  //  LoadingScreen()
                }
            }
    }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(StreamViewModel())
    }
}
