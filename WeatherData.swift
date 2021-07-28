//
//  WeatherData.swift
//  Clima
//
//  Created by JI XIANG on 11/7/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable, Encodable { //Decodable protocol allows convert JSON to swift objects
    //Encodable protocol which allows swift objects to be encoded into a JSON
    let name: String
    let main: Main
    let weather: [Weather] //becuz the weather property in the JSON file is an array of values, so we need an array of Weather data types by decalring a struct
}

struct Main: Codable{ //Codeable is a typealias that combines two protocol, decodable & codable
    let temp: Double
}

struct Weather: Codable { //Codeable is a typealias that combines two protocol, decodable & codable
    //must adopt the decodable protocol so that it is able to format the data
    let description: String
    let id: Int
}
