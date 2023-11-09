//
//  StreamViewModel.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation
import SwiftUI
import StreamChat
import StreamChatSwiftUI

@MainActor
final class StreamViewModel: ObservableObject {
    
    private enum Constants {
        static let groupNameErrorMessage: String = "Please write a group name"
    }
    
    @Published var isShowSignInView = false
    
    /// Errors
    @Published var hasError = false
    @Published var errorMessage = ""
    
    /// User search
    @Published var isShowSearchUsersView = false
    @Published var searchText = ""
    @Published var searchResults: [ChatUser] = []
    @Published var suggestedUsers: [ChatUser] = []
    
    /// Loading state
    @Published var isLoading = false
    
    @Published var isShowProfile = false
    
    /// New group creation
    @Published var newGroupUsers: [ChatUser] = []
    @Published var newGroupName = ""
    
    /// Channels
    @Published var isShowSelectedChannel = false
    @Published var selectedChannelController: ChatChannelController? = nil
    @Published var selectedChannelViewModel: ChatChannelViewModel? = nil
    
    /// Online users
    @Published var usersOnline: [ChatUser] = []
    
    @Published var isShowChangeProfilePictureView = false
    
    @Published var isSearchBarFocused = false
    
    @AppStorage("colorScheme") var userPrefersDarkMode: Bool = false
    
    @Published var isShowForgotPasswordView = false
    
    /// Alerts
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    var isSignedIn: Bool {
        guard ChatClient.shared.currentUserId != nil else {
            return false
        }
        
        return AuthManager.shared.user != nil
    }
    
    var currentUserId: String? {
        ChatClient.shared.currentUserId
    }
    
    var currentUser: CurrentChatUser? {
        ChatClient.shared.currentUserController().currentUser
    }
    
    var imageURL: URL? {
        guard let fileName = currentUserId else {
            return nil
        }
        
        return FileManager.documnetsDirectory?.appending(path: "\(fileName).\(FileExtensionKind.jpg.rawValue)")
    }
    
    
    func signOut() {
        
        guard currentUser != nil else {
            assert(false, "User must not be nil")
            return
        }
        
        ChatClient.shared.logout { [weak self] in
            print("Client logged out")
            self?.isShowSignInView = true
            self?.isShowProfile = false
        }
    }
    
    func signUp(
        userId: String,
        username: String
    ) {
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: userId, name: username), token: .development(userId: userId)) { [weak self] error in
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.hasError.toggle()
                return
            }
            
            DispatchQueue.main.async {
                self?.isShowSignInView = false
            }
        }
    }
    
    func signIn(userId: String) {
        
        ChatClient.shared.connectUser(
            userInfo: UserInfo(id: userId),
            token: .development(userId: userId)
        ) { [weak self] error in
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.hasError.toggle()
                return
            }
            
            DispatchQueue.main.async {
                self?.isShowSignInView = false
            }
            
        }
    }
    
    func createGroupChannel() {
        guard !newGroupUsers.isEmpty, !newGroupName.isEmpty else {
            self.errorMessage = Constants.groupNameErrorMessage
            self.hasError.toggle()
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        let members: [String] = newGroupUsers.map { user in
            user.id.description
        }
        
        let channelId = ChannelId(type: .team, id: newGroupName)
        
        do {
            let request = try ChatClient.shared.channelController(
                createChannelWithId: channelId,
                name: newGroupName,
                imageURL: nil,
                members: Set(members),
                isCurrentUserMember: true
            )
            
            request.synchronize { [weak self] error in
                
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.hasError.toggle()
                    
                    return
                }
                
                self?.newGroupName = ""
                self?.newGroupUsers = []
                
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                self?.selectedChannelController = request
                self?.isShowSelectedChannel = true
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.hasError = true
        }
    }
    
    func createDirectChannel(id: String) {
        guard currentUserId != nil, !id.isEmpty else {
            self.errorMessage = "User isn't logged in"
            self.hasError.toggle()
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        do {
            let request = try ChatClient.shared.channelController(createDirectMessageChannelWith: Set([id]), type: .messaging, isCurrentUserMember: true, extraData: [:])
            
            request.synchronize { [weak self] error in
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Channel creation error: \(error.localizedDescription)")
                    self?.hasError.toggle()
                    
                    return
                }
                
                print("Channel with id:\(id) created")
                
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                self?.selectedChannelController = request
                self?.isShowSelectedChannel = true
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.hasError = true
        }
    }
    
    func searchUsers(searchText: String) {
        
        let controller = ChatClient.shared.userListController(query: .init(filter: .autocomplete(.name, text: searchText), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("searchUsers error: \(error.localizedDescription)")
                return
            }
            
            print("searchUsers first page: success")
            
            self?.searchResults = controller.users.filter { $0.id.description != self?.currentUserId}
            
            controller.loadNextUsers(limit: 10) { error in
                if let error = error {
                    print("searchUsers next users fetching: \(error.localizedDescription)")
                    return
                }
                
                self?.searchResults = controller.users.filter { $0.id.description != self?.currentUserId}
                print("searchUsers second page: success")
            }
        }
    }
    
    func loadSuggestedResults() {
        
        let controller = ChatClient.shared.userListController(query: .init(filter: .equal(.role, to: .user), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("loadSuggestedResults failure: \(error.localizedDescription)")
                return
            }
            
            print("loadSuggestedResults: success")
            
            self?.suggestedUsers = controller.users.filter { $0.id.description != self?.currentUserId}
        }
    }
    
    func loadOnlineUsers() {
        let controller = ChatClient.shared.userListController(query: .init(pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("loadOnlineUsers failure: \(error.localizedDescription)")
                return
            }
            
            print("loadOnlineUsers success: \(controller.users.count)")
            self?.usersOnline = controller.users.filter { ($0.id.description != self?.currentUserId) }
        }
    }
    
}
