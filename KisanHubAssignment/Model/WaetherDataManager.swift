//
//  WaetherDataManager.swift
//  KisanHubAssignment
//
//  Created by Pran Kishore on 15/01/18.
//  Copyright © 2018 Pran Kishore. All rights reserved.
//

import UIKit

struct URLBuilder {
    let baseUrl = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/"
    var weatherParam = ""
    var countryCode = ""
    
    func urlForResource() -> String {
        return "\(baseUrl)\(weatherParam)/date/\(countryCode).txt"
    }
}

class WaetherDataManager {
    
    //Constants
    let numberOfMonths = 12
    let metadataLines = 6
    let countryCodes = ["England_SE_and_Central_S","England_SW_and_S_Wales", "East_Anglia", "Midlands", "England_NW_and_N_Wales", "England_E_and_NE", "Scotland_W", "Scotland_E", "Scotland_N", "England_S", "Northern_Ireland", "England_and_Wales", "England_N", "UK", "England","Wales"]
    let waetherParams = ["Tmean", "Sunshine", "Rainfall", "Tmax", "Tmin"]
    let months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
    
    func downloadAllRecords() {
        for country in countryCodes {
            for weatherParam in waetherParams {
                var url = URLBuilder() ; url.weatherParam = weatherParam ; url.countryCode = country;
                print(url.urlForResource())
            }
        }
    }
    
    //Used to strip the first lines of metadata
    func strip(FromText text: [String],ignoringElements number: Int ) -> [String]? {
        //Assume that the text has more count than could be igonored inside it.
        guard text.count > number else {
            return nil
        }
        let startIndex = text.index(after: number)// Indexing starts from Zero
        return Array(text[startIndex...])
    }
    
    func parse(Text text:String, forCountry code:String , Weather param:String) -> [WeatherRecord]? {
        
        //First try to split all the lines in the text file.
        let rows = text.split(separator: "\r\n").map({String($0)}) //Line sperator of text file is \r\n
        //Asuuming that the first we dont need first 6 lines and the 7th line is always same.
        //We strip the data away.
        let stripped = strip(FromText:rows, ignoringElements: metadataLines)
        
        //Ensure after stripping we have any data left.
        guard let strippedText = stripped else {
           return nil
        }
        
        //Start creating records
        var arrWeatherRecord : [WeatherRecord] = []
        for row in strippedText {
            let columns = row.split(separator: " ").map({String($0)})//Split again on the basis of white space.
            guard let year = columns.first else {continue}
            
            //We are starting from 1 as first entry is always the year.
            for index in 1...numberOfMonths {
                let record = WeatherRecord.init(withRegionCode: code, weather_param: param, year: year, month: months[index-1] , entityValue : columns[index])
                arrWeatherRecord.append(record)
            }
        }
        return arrWeatherRecord
    }
}

class WeatherData {
    var arrWeatherData : [WeatherRecord]
    init() {
        arrWeatherData = []
    }
    
}
