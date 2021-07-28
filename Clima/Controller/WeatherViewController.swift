//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() //responsible for getting hold the current gps location of the phone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self //rmb to set this up whenever using delegate if not nothing is gonna happen even if you adopt the protocol or delegate methods.
        
        locationManager.requestWhenInUseAuthorization() //ask the user permission to use their location
        locationManager.requestLocation() //request for a one-time delivery of user location
        //locationManager.startUpdatingLocation() is for fitness or tracking app where it cosntantly reports back the user location when it updates
        
        weatherManager.delegate = self
        searchTextField.delegate = self //set it to this current class, becuz this class adopts the protocol UITextFieldDelegate
        //The UITextField has a property delegate: UITextFieldDelegate, which requires a UITextFieldDelegate protocol data type as a value to the delegate property inside the UITextField.
        //the textfield will report back to this weatherviewcontroller after the user interact with the textfield
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate
////MARK: - <#Section Heading #> //to give it a template placeholder name you need to insert <# at the start of the sentence
// and #> at the end of the sentence when you are creating the code snippets

extension WeatherViewController: UITextFieldDelegate { //inherit a class, adopt a protocol
    //the UITextFieldDelegate will allow you to use the editing and validation of text in a text field object.
    
    @IBAction func searchedPressed(_ sender: UIButton) {
        print(searchTextField.text!) //only when you know that there is definitely some value passed to this text property then we use the "!" to unwrap it.
        searchTextField.endEditing(true) //tells the textfield that we are done with editing and can dismiss the keyboard
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //function will trigger when the user press the "return" key on the keyboard
        //to have this function you need to inherit UITextFieldDelegate and have an IB outlet to access the textfield
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        
        return true //becuz this template function expects a boolean as a output.
        //return true means it should return
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { //this function runs when the user tries to deselect the textfield.
        //useful on doing validation on what the user type into the textfield
        if textField.text != "" { //if the user did not enter an empty string...
            return true //return true means it should end editing
        } else {
            textField.placeholder = "Type something"
            return false //not allowing the textfield to end editing and keep the keyboard
        }
        //we used the textField parameter name instead of searchTextField is becuz whichever textfield that trigger this event will be called as the textField. Its the same concept as what we do for sender when we link 1 IBAction to serveral buttons.
        //So in this case is any of the textfield will be able to perform this code of function.
        
    }
    
    //another delegate method
    func textFieldDidEndEditing(_ textField: UITextField) { //this functions runs when the user stop editing the textfield. All the textfield that is on the current screen.
        
        //Use searchTextField.text to get the weather for that city before clearing the input
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = "" //clear the textfield
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate { //better organising of codes using the extention and then adopting a protocol here. Whatever codes that are related to this protocol, we can write it here for better management.
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString //label.text requires a String type
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    //Must implement this two methods if not the app will crash
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locations is an array of CLLocation
        if let location = locations.last {//we want to get hold of the last item in the array, the last location is the most accurate one.
            locationManager.stopUpdatingLocation() //tell the location manager to stop updating so that it can call this delegate method again. //Becuz this delegate method only runs when there is an update/changes to the gps location, hence we need to manually stop it so that we can call it again to retrieve the user's location.
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

