//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController , CLLocationManagerDelegate  , ChangeCityDelegate{
   
    
    
    //Constants
    // my id  4/6/2018       60344abb16db6b6b5cb2bc0aafd2651c
    //angyla yu id  e72ca729af228beabd5d20e3b7749713
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "60344abb16db6b6b5cb2bc0aafd2651c"
  

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String , parameters:[String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                // to check the conectionto the sever use print statment
                print("Seccess ..!Got the Weather data")
                // convert  to JSON and implicitly Unwrapping the value becouse it's optional
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }else{
                print("ERROR : \(response.result.error)")
                self.cityLabel.text = "Connction Issues"
            }
            
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        // useing optional bainding  (if let ) instead of unwrapping the tempResult ... to check the result of sever or skip
      
        if  let tempResult = json ["main"]["temp"].double {
        // here we Unwrapping the tempResult to change it from double?  to doable
        //weatherDataModel.tempature = Int(tempResult! - 273.15)
        weatherDataModel.tempature = Int(tempResult - 273.15)
        weatherDataModel.city = json ["name"].stringValue
        weatherDataModel.condtion = json ["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condtion)
            
            // call update Method for UI
            updateUIWithWeatherData()  
        }else{
            print("wather unavailable")
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.tempature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        // the frist step here (app beginning)
        
        
        // to get the last value in lactionValues Array
        let location  = locations[(locations.count - 1)]
        // if the Accuracyarea > 0 ----> get latitude and longitude and stop update location
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            // to get the data form the server( only one time ) set the delgate is nil until the stopUpdatingLocation() happend becouse it take meny seconds to stop
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude)  ,  latitude = \(location.coordinate.latitude)")
            
        let longitude =  String(location.coordinate.longitude)
        let latitude = String(location.coordinate.latitude)
          // put the long and lati in Dictionary Parameter to pass it into alamofire
            let params:Dictionary<String,String> = ["lat": latitude , "lon": longitude , "appid": APP_ID]
            
            // to call the alamofire method
            getWeatherData(url: WEATHER_URL , parameters:params )
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func userEnteredNewCityName(city: String) {
        print(city)
        let params: [String:String] = ["q" : city , "appid" : APP_ID]
        // here we call the func tha Alamofire in side
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}


