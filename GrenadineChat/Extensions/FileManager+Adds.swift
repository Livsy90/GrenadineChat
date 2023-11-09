//
//  FileManager+Adds.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation

extension FileManager {
    static var documnetsDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[safe: 0]
    }
}
