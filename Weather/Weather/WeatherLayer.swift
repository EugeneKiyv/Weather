//
//  WeatherLayer.swift
//  Weather
//
//  Created by Eugene Kuropatenko on 1/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

let DayLengthInSeconds:TimeInterval = 60*60*24

protocol ApiAgreement {
    func updateWeather(city:String ,success:(( _ response:[String:Any]) -> ())?, failure:((_ error:NSError) -> ())?)
}

protocol WeatherLayerDelegate {
    func forecast(index:Int, weather:WeatherModel)
}

class WeatherLayer {
    let cities = ["Kiev,UA","Kharkov,UA","Kherson,UA","Yalta,UA"]
    let delegate:WeatherLayerDelegate
    let api:ApiAgreement
    
    init(delegate:WeatherLayerDelegate, api:ApiAgreement) {
        self.delegate = delegate
        self.api = api
    }
    
    func citiesCount() -> Int {
        return cities.count
    }
    
    func getInfo()  {
        for cityName in cities {
            api.updateWeather(city: cityName, success: {[weak self] ( data) in
                guard let city = data["city"] as? [String:Any] else {return}
                guard let list = data["list"] as? [[String:Any]] else {return}
                var temp = 0.0;
                var descr = ""
                var icon = ""
                for forecast in list {
                    let date = NSDate(timeIntervalSince1970: forecast["dt"] as! Double)
                    if date.timeIntervalSinceNow > DayLengthInSeconds && date.timeIntervalSinceNow < 2*DayLengthInSeconds {
                        let main = forecast["main"] as! [String:Any]
                        temp = main["temp"] as! Double
                        let weather = forecast["weather"] as! [[String:Any]]
                        if weather.count > 0 {
                            descr += " \(weather[0]["description"]!)"
                            icon = weather[0]["icon"] as! String
                            icon = "http://openweathermap.org/img/w/\(icon).png"
                        }
                        break
                    }
                }
                let weatherModel = WeatherModel(country: city["country"] as! String, city: city["name"] as! String, temp:temp, icon: icon, forecast: descr)
                self?.delegate.forecast(index: (self?.cities.index(of: cityName))!, weather: weatherModel)
            }, failure: { (error) in
                
            })
        }
    }
}
