//
//  Extensions.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import Foundation
import SwiftUI

extension Color {
    static let backgroundColor = Color("Background")
    static let iconColor = Color("Icon")
    static let textColor = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}


extension DateFormatter {
    static let allNumericUSA: DateFormatter = {
        print("Initializing DateFormater")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else {return Date()}
        return parsedDate

    }
    
}


extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}
