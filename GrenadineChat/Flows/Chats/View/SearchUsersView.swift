//
//  SearchUsersView.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct SearchUsersView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    var transitionEdge: AnyTransition = .move(edge: .trailing)
    
    @FocusState private var focused: Bool
    
    var body: some View {
        List {
            if streamViewModel.searchText.isEmpty {
                Section {
                    NavigationLink {
                        CreateNewGroupView()
                    } label: {
                        HStack {
                            Image(systemName: "person.3.fill")
                            
                            Text("Group Chat")
                        }
                    }
                } header: {
                    Text("Create Group")
                }
            }
            
            Group {
                if streamViewModel.searchText.isEmpty {
                    Section("Suggested") {
                        SearchUsersResultsView(results: streamViewModel.suggestedUsers)
                    }
                } else {
                    Section {
                        SearchUsersResultsView(results: streamViewModel.searchResults)
                    }
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.gray)
        .transition(transitionEdge)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    streamViewModel.isShowSearchUsersView = false
                    streamViewModel.searchText = ""
                    streamViewModel.searchResults = []
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.purple)
                }
            }
            
            ToolbarItem(placement: .principal) {
                TextField("Search users", text: $streamViewModel.searchText)
                    .focused($focused)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color(.lightGray))
                    .cornerRadius(5)
                    .overlay {
                        HStack {
                            Spacer()
                            
                            if !streamViewModel.searchText.isEmpty {
                                Button {
                                    streamViewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    }
            }
            
        }
        .onChange(of: streamViewModel.searchText, { _, newValue in
            if !newValue.isEmpty {
                streamViewModel.searchUsers(searchText: newValue)
            }
        })
        .onAppear {
            focused = true
            
            streamViewModel.loadSuggestedResults()
        }
        .alert("ERROR CREATING NEW DIRECT CHANNEL...", isPresented: $streamViewModel.hasError) {
            Button("OK") {}
        } message: {
            Text(streamViewModel.errorMessage)
        }
        .fullScreenCover(isPresented: $streamViewModel.isShowSelectedChannel) {
            DirectChatChannelView()
        }
    }
    
}

#Preview {
    NavigationStack {
        SearchUsersView()
            .environmentObject(StreamViewModel())
    }
}

