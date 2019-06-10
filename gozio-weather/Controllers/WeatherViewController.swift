//
//  WeatherViewController.swift
//  gozio-weather
//
//  Created by Greg Ledbetter on 6/8/19.
//  Copyright © 2019 Greg Ledbetter. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var fiveDayTableViewController: FiveDayTableViewController?
    private var fiveDayForecast:FiveDayCityForecast?
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
            if let fiveDay = forecast  {
                self.fiveDayForecast = fiveDay
                DispatchQueue.main.async {
                    let dateFormatter = DateFormatter()
                    //dateFormatter.timeStyle = .short
                    //dateFormatter.dateStyle = .short
                    dateFormatter.dateFormat = " MMM dd, YYYY h:mm a"

                    self.lblCity.text = fiveDay.city.name
                    self.lblDate.text = "\(dateFormatter.string(from:fiveDay.list[0].dt))"
                    self.lblTemp.text = "\(Int(fiveDay.list[0].temp.day.rounded()))\u{00B0}"
                    self.lblDescription.text = fiveDay.list[0].weather[0].description.localizedCapitalized
                    self.fiveDayTableViewController?.fiveDayForecast = fiveDay
                    self.fiveDayTableViewController?.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    
                }
            }
        }
    }
}
