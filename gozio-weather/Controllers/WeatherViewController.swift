//
//  WeatherViewController.swift
//  gozio-weather
//
//  Created by Greg Ledbetter on 6/8/19.
//  Copyright © 2019 Greg Ledbetter. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let weatherApi = OpenWeatherApi()
        weatherApi.getAtlanta5DayWeather()
    }

}
