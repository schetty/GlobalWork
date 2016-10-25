//
//  Months.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-24.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import Foundation

enum Months : String {
    case january = "January"
    case february = "February"
    case march = "March"
    case april = "April"
    case may = "May"
    case june = "June"
    case july = "July"
    case august = "August"
    case september = "September"
    case october = "October"
    case november = "November"
    case december = "December"


    
    
    func toInt() -> Int{
        switch self {
        case .january:
            return 1
        case .february:
            return 2
        case .march:
            return 3
        case .april:
            return 4
        case .may:
            return 5
        case .june:
            return 6
        case .july:
            return 7
        case .august:
            return 8
        case .september:
            return 9
        case .october:
            return 10
        case .november:
            return 11
        case .december:
            return 12
        default:
            return -1
        }
    }
    
}
