//
//  timeHelper.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/30/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class TimeHelper: NSObject {
    
    public static let secondsInMinute = 60.0
    public static let secondsInHour = 3600.0
    public static let secondsInDay = 86400.0
    
    class func secondsToMinutes(seconds: Double) -> Double {
        return seconds / secondsInMinute
    }
    
    class func secondsToHours(seconds: Double) -> Double {
        return seconds / secondsInHour
    }
    
    class func secondsToDays(seconds: Double) -> Double {
        return seconds / secondsInDay
    }
    
}
