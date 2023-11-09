//
//  CircleImageModifier.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import SwiftUI

struct CircleImageModifier: ViewModifier {
    
    private enum Constants {
        static let size: CGSize = CGSize(width: 45, height: 45)
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: Constants.size.width, height: Constants.size.height)
            .clipShape(Circle())
    }
}
