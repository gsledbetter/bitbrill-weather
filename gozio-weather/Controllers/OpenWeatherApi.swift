//
//  OpenWeatherApi.swift
//  gozio-weather
//
//  Created by Greg Ledbetter on 6/8/19.
//  Copyright © 2019 Greg Ledbetter. All rights reserved.
//

import Foundation
import SwiftyJSON

public class OpenWeatherApi {

    let atlWeatherUrl = "https://api.openweathermap.org/data/2.5/forecast/daily?q=Atlanta&mode=json&cnt=5&units=imperial&apikey=3aa158b2f14a9f493a8c725f8133d704"
    var getWeatherSemaphore:DispatchSemaphore?

    
    public func getAtlanta5DayWeather() {
        
        self.getWeatherSemaphore = DispatchSemaphore(value: 0)
        
        var requestSuccess = false
        
        // URL Session start
        let url = URL(string: self.atlWeatherUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                logger?.log(category: .network, message: "Error getting weather\(error).")
                return
            }
            guard let requestSemaphore = self.getWeatherSemaphore else
            {
                logger?.log(category: .network, message: "The weather request semaphore is nil.")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    requestSemaphore.signal()
                    logger?.log(category: .network, message: "Server error in getting weather.")
                    return
            }
            requestSuccess = true
            logger?.log(category: .network, message: "Success in getting weather.")
            
            if let dataFromNetwork = data {
                if let json = try? JSON(data: dataFromNetwork) {
                    
                    for day in json["list"].arrayValue {
                        let dateTime = day["dt"].doubleValue
                        let date = Date(timeIntervalSince1970: dateTime)
                        print("Date = \(date)")
                    }
                 }
            }
            requestSemaphore.signal()
            
        }
        task.resume()
        
        let result = self.getWeatherSemaphore!.wait(timeout: DispatchTime.now() + 60.0)
        switch result {
        case .timedOut:
            logger?.log(category: .network, message: "Timeout waiting to get weather.")
        case .success:
            if requestSuccess {
                logger?.log(category: .network, message: "Success in getting weather.")
            } else {
                logger?.log(category: .network, message: "Error in gettign weather.")
            }
            
        }
        
    }


}
