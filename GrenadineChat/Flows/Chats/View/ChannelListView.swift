//
//  ChannelListView.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import UIKit
import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct ChannelListView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    @StateObject private var chatsViewModel: ChatChannelListViewModel = GrenadineViewModelFactory.makeChannelListViewModel(.chats)
    @StateObject private var groupsViewModel: ChatChannelListViewModel = GrenadineViewModelFactory.makeChannelListViewModel(.groups)
    
    let type: ChannelType
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ChatChannelListView(
                    viewFactory: StreamViewFactory.shared,
                    viewModel: type == .messaging ? chatsViewModel : groupsViewModel,
                    embedInNavigationView: false
                )
                
                Button {
                    withAnimation {
                        streamViewModel.isShowSearchUsersView = true
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.white)
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .background {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color.purple)
                        }
                        .padding()
                }
            }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        MessageAvatarView(avatarURL: streamViewModel.currentUser?.imageURL)
                            .modifier(CircleImageModifier())
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                streamViewModel.isShowProfile = true
                            }
                        } label: {
                            Image(systemName: "gear")
                                .font(.title3.bold())
                                .foregroundColor(.purple)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                            Text(type == .messaging ? "Chats" : "Groups")
                                .font(.title.bold())
                                .foregroundColor(.purple)
                    }
                }
                .navigationBarBackButtonHidden()
                .fullScreenCover(isPresented: $streamViewModel.isShowSearchUsersView) {
                    NavigationStack {
                        SearchUsersView()
                    }
                }
        }
        
    }
}

#Preview {
    ChannelListView(type: .messaging)
        .environmentObject(StreamViewModel())
}
