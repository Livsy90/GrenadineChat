//
//  DirectChatChannelView.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import StreamChatSwiftUI
import SwiftUI

struct DirectChatChannelView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        NavigationStack {
            Group {
                if let channelController = streamViewModel.selectedChannelController {
                    LazyView(
                        ChatChannelView(viewFactory: StreamViewFactory.shared, viewModel: streamViewModel.selectedChannelViewModel, channelController: channelController)
                    )
                } else {
                    VStack(spacing: 20) {
                        Text("OPENNING A DIRECT CHANNEL WENT WRONG!")
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Back")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(width: 100, height: 50)
                                .clipShape(Capsule(style: .continuous))
                                .background {
                                    Capsule().fill(Color.purple)
                                }
                                
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DirectChatChannelView()
        .environmentObject(StreamViewModel())
}

