//
//  NewGroupListView.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct NewGroupListView: View {
    
    private enum Constants {
        static let unknownUserString: String = "Unknown User"
        static let lineLimit: Int = 1
        static let image: (checked: Image, unchecked: Image) = (
            Image(systemName: "checkmark.circle.fill"),
            Image(systemName: "circle")
        )
        static let uncheckedOpacity: CGFloat = 0.7
        static let avatarStackHeight: CGFloat = 40
    }
    
    @EnvironmentObject var streamViewModel: StreamViewModel
        
    let results: [ChatUser]
    
    var body: some View {
        
        ForEach(results) { user in
            Button(action: {
                if streamViewModel.newGroupUsers.contains(user) {
                    withAnimation {
                        streamViewModel.newGroupUsers.removeAll { $0 == user }
                    }
                } else {
                    withAnimation {
                        streamViewModel.newGroupUsers.append(user)
                    }
                }
            }, label: {
                HStack {
                    MessageAvatarView(avatarURL: user.imageURL)
                    
                    Text(user.name ?? Constants.unknownUserString)
                        .foregroundColor(.primary)
                        .lineLimit(Constants.lineLimit)
                        .font(.headline)
                    
                    Spacer()
                    
                    if streamViewModel.newGroupUsers.contains(user) {
                        Constants.image.checked
                            .foregroundColor(Color.purple)
                    } else {
                        Constants.image.unchecked
                            .foregroundColor(.purple.opacity(Constants.uncheckedOpacity))
                    }
                }
                .frame(height: Constants.avatarStackHeight)
            })
        }
    }
}

#Preview {
    NewGroupListView(results: [])
        .environmentObject(StreamViewModel())
}
