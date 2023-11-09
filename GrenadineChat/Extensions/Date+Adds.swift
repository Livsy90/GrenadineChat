//
//  String+Adds.swift
//  GrenadineChat
//
//  Created by Livsy on 09.11.2023.
//

import Foundation

extension Date {
    var lastSeenString: String {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: self, to: currentDate)
        
        if let day = components.day, day > 0 {
            return "last seen \(day) day\(day > 1 ? "s" : "") ago"
        } else if let hour = components.hour, hour > 0 {
            return "last seen \(hour) hour\(hour > 1 ? "s" : "") ago"
        } else if let minute = components.minute, minute > 0 {
            return "last seen \(minute) minute\(minute > 1 ? "s" : "") ago"
        } else {
            return ""
        }
    }
}
