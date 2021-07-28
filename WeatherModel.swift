//
//  WeatherModel.swift
//  Clima
//
//  Created by JI XIANG on 12/7/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    //Stored property
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    //computed Property must always be var
    //syntax: var aProperty: Int {
        //codes that calculate the output and assign it to aProperty variable
        //Note that we must assign a Int as the output since we declare it is an Int datatype
    //}
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    //Computed property that you can do in swift
    var conditionName: String {
        //return an String output and assigns to the conditionName
        switch conditionId {
        case 200...232: //range between 200 and 232 inclusive
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "cloud.bolt"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    
    //    func getConditionName(weatherID: Int) ->String {
    //        switch weatherID {
    //        case 200...232: //range between 200 and 232 inclusive
    //            return "cloud.bolt"
    //        case 300...321:
    //            return "cloud.drizzle"
    //        case 500...531:
    //            return "cloud.rain"
    //        case 600...622:
    //            return "cloud.snow"
    //        case 701...781:
    //            return "cloud.fog"
    //        case 800:
    //            return "cloud.bolt"
    //        case 801...804:
    //            return "cloud"
    //        default:
    //            return "cloud"
    //        }
    //    }
    
}
