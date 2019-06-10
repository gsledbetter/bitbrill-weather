//
//  WeatherViewController.swift
//  gozio-weather
//
//  Created by Greg Ledbetter on 6/8/19.
//  Copyright © 2019 Greg Ledbetter. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    private var fiveDayTableViewController: FiveDayTableViewController?
    private var fiveDayForecast:FiveDayCityForecast?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let weatherApi = OpenWeatherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getFiveDayForecast()
        self.activityIndicator.hidesWhenStopped = true


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let fiveDayTVC = destination as? FiveDayTableViewController {
            self.fiveDayTableViewController = fiveDayTVC
            guard let forecast = self.fiveDayForecast else {
                logger?.log(category: .ui, message: "The five day forecast is nil.")
                return
            }
            fiveDayTableViewController?.fiveDayForecast = forecast
        }
        
    }
    
    private func getFiveDayForecast() {
        self.activityIndicator.startAnimating()
        self.weatherApi.getAtlanta5DayWeather() { forecast in
            self.fiveDayForecast = forecast
            DispatchQueue.main.async {
                self.fiveDayTableViewController?.fiveDayForecast = self.fiveDayForecast
                self.fiveDayTableViewController?.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                
            }

        }
        
    }

}
