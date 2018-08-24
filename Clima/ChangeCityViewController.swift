//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredNewCityName(city : String)
}



class ChangeCityViewController: UIViewController  {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let  cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        // here we set ?after the delgate to check if the delgate contains a value (go on the statment) or if no value in it (nil) this do not continue the statment line ..
        // optionalchaining is an alternaivte to optional binding
        
        delegate?.userEnteredNewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
