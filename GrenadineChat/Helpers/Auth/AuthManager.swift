//
//  AuthManager.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    enum ProviderKind: String {
        case email = "password"
        case google = "google.com"
        case apple = "apple.com"
    }
    
    var user: User? {
        try? getUser()
    }
    
    private init() {}
    
    func getProviders() throws -> [ProviderKind] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [ProviderKind] = []
        
        for provider in providerData {
            if let option = ProviderKind(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.cannotFindHost)
        }
        
        try await user.delete()
    }
    
    private func getUser() throws -> User {
        guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse) }
        return user
    }
    
}
