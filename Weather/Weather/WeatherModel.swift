//
//  WeatherModel.swift
//  
//
//  Created by Eugene Kuropatenko on 1/15/17.
//
//

import Foundation

class WeatherModel {
    let iconPath:String
    let city:String
    let country:String
    let temp:Double
    let forecast:String
    
    init(country:String, city:String, temp:Double, icon:String, forecast:String ) {
        self.country = country
        self.city = city
        self.forecast = forecast
        self.iconPath = icon
        self.temp = temp
    }
}
