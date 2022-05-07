//
//  Time.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 4/27/22.
//

import Foundation


enum DoW {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    
}

class Time {
    var active: Bool
    var timeDoW: DoW

    init(timeDoW: DoW) {
        self.timeDoW = timeDoW
        self.active = false
    }
    
    func getdowfull() -> String {
        switch timeDoW {
        case .mon:
            return "Monday"
            
        case .tue:
            return "Tuesday"
            
        case .wed:
            return "Wednesday"
            
        case .thu:
            return "Thursday"

        case .fri:
            return "Friday"

        case .sat:
            return "Saturday"

        case .sun:
            return "Sunday"

            
        }
    }

    
    
    func getdow() -> String {
        switch timeDoW {
        case .mon:
            return "Mon"
            
        case .tue:
            return "Tue"
            
        case .wed:
            return "Wed"
            
        case .thu:
            return "Thu"

        case .fri:
            return "Fri"

        case .sat:
            return "Sat"

        case .sun:
            return "Sun"

            
        }
    }
}
