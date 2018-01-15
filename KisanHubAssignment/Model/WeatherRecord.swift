//
//  WeatherRecord.swift
//  KisanHubAssignment
//
//  Created by Pran Kishore on 15/01/18.
//  Copyright © 2018 Pran Kishore. All rights reserved.
//

import UIKit

class WeatherRecord {
    
    var region_code : String
    var weather_param : String
    var year : String
    var month : String
    var entityValue : String
    
    init (withRegionCode region_code:String , weather_param : String , year : String , month : String ,entityValue : String = "N/A" ) {
        self.region_code = region_code
        self.weather_param = weather_param
        self.year = year
        self.month = month
        self.entityValue = entityValue
    }
}
