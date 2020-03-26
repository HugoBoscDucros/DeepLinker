//
//  Date+Extensions.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 26/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import Foundation

extension Date {
    public var toJSON: String {
        get {
            let dateFormater = DateFormatter()
            dateFormater.locale = Locale(identifier: "en_GB")
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let APIStringDate = dateFormater.string(from: self)
            return APIStringDate
        }
    }
}
