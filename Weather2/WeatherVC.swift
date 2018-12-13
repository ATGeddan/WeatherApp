//
//  ViewController.swift
//  Weather2
//
//  Created by Admin on 8/9/1439 AH.
//  Copyright © 1439 AH Admin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController,CLLocationManagerDelegate {
  
  // Constants - final URL in the location manager method because it has the latitude and longitude from the GPS
  
  let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat="
  let WEATHER_URL2 = "&lon="
  let APP_ID = "&appid=2e635fab3c972a6c1a41a80928efe600"
  
  //___________________________
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var currentTemplabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var currentWeatherimage: UIImageView!
  @IBOutlet weak var currentWthrTypeLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    
  }
  
  // getWeatherData Method - Fetch weather from the URL and set values for the labels
  
  func getWeatherData(url:String) {
    Alamofire.request(url).responseJSON {
      response in
      let result = response.result
      if result.isSuccess {
        if let dict = result.value as? Dictionary <String,AnyObject> {
          if let name = dict["name"] {
            self.locationLabel.text = name.capitalized
          }
          if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
            if let main = weather[0]["main"] as? String {
              self.currentWthrTypeLbl.text = main.capitalized
              self.currentWeatherimage.image = UIImage(named: main)
            }
            
          }
          
          if let main = dict["main"] as? Dictionary<String,AnyObject> {
            if let temp = main["temp"] as? Int {
              let temp2 = temp - 273
              self.currentTemplabel.text = "\(temp2)°"
            }
          }
        }
        
      }
      else {
        print("Error")
        self.locationLabel.text = "Connection Problems"
        
      }
    }
    
  }
  
  
  
  // Location Manager delegate methods - Did Update & Did Fail
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else {return}
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      print("\(location.coordinate.longitude) , \(location.coordinate.latitude)")
      let latitude = String(location.coordinate.latitude)
      let longitude = String(location.coordinate.longitude)
      let finalURL = "\(WEATHER_URL)\(latitude)\(WEATHER_URL2)\(longitude)\(APP_ID)"
      getWeatherData(url: finalURL)
      
    }
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    locationLabel.text = "Location Unavailable"
  }
  
  // Choosing another City
  
  @IBAction func getWeatherPressed(_ sender: Any) {
    let finalURL = "http://api.openweathermap.org/data/2.5/weather?q=\(textField.text ?? "cairo")&appid=2e635fab3c972a6c1a41a80928efe600"
    getWeatherData(url: finalURL)
    
  }
  
  
  
  
  
  
  
  
}

