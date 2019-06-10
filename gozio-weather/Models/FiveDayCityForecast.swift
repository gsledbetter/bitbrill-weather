//
//  FiveDayCityForecast.swift
//  gozio-weather
//
//  Created by Greg Ledbetter on 6/8/19.
//  Copyright © 2019 Greg Ledbetter. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct City: Codable {
    let name: String
    let coord: Coordinate
    let country: String
}

struct Temperatures: Codable {
    let day: Double
    let min: Double
    let max: Double

}
struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct DayForecast: Codable {
    let dt: Date
    let temp: Temperatures
    let weather: [Weather]

    func describe() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        print("Forecast for \(dateFormatter.string(from: dt)): \(weather[0].description), High: \(temp.max), Low: \(temp.min)")
    }
}

public struct FiveDayCityForecast: Codable {
    let city: City
    let list: [DayForecast]
    
    func describe() {
        print("Five day forecast for \(city.name), \(city.country):")
        for forecast in list {
            forecast.describe()
        }
    }
    
}
