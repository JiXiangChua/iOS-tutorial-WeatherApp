//
//  WeatherManager.swift
//  Clima
//
//  Created by JI XIANG on 11/7/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(weatherKeys.api)&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString) //reuse the networking functionaility to pass the data and retrieve the data back.
    }
    
    func performRequest(with urlString: String){ //does the networking using URLSession to fetch some data back from OpenWeatherMap
        //        1. Create a URL object
        if let url = URL(string: urlString) { //optionally bind to a constant called url as long as the urlstring is not nil.
            
            //        2. Create a URLSession - the object that's going to be doing on networking
            let session = URLSession(configuration: .default) //using default configuration
            
            //        3. Give URLSession a task
            //here we are using an anonymous charger
            let task = session.dataTask(with: url) { (data, response, error) in
                //this method is executed whenever its done getting the data off of the internet
                if error != nil {
                    //print(error!) //since we already check is no nil, we can force unwrap this
                    self.delegate?.didFailWithError(error: error!) //to passover the error via the delegate
                    return //exit out of this function since there is an error
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) { //in closures if we are calling methods from the current class, then we need to add self. infront of the method.
                        self.delegate?.didUpdateWeather(self, weather: weather) //self.delegate refers to the current class delegate
                    }
                }
            }
            //completionHandler takes in a function as a value
            //once the task is complete, then the completionHandler will be called and its going to pass in a optional data, optional response and optional error automatically
            
            
            //        4. Start the task
            task.resume()
            
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? { //takes in a data object
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //decoder.decode requires a try so that it is able to throw error if any
            
            
            //Getting the data from API JSON format
//            print(decodedData.name) //to get hold of the values from JSON, make sure that you decalre the property inside the struct which follows the decodable protocol
//            print(decodedData.main.temp)
//            print(decodedData.weather[0].description)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            print(weather.temperatureString)
            
            return weather
            
        } catch { //catch the error if any
            self.delegate?.didFailWithError(error: error) //to passover the error via the delegate
            return nil
        }
        
    }
    
    
    
}
