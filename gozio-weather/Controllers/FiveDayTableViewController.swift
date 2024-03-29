//
//  FiveDayTableViewController.swift
//  gozio-weather
//
//  Created by Greg Ledbetter on 6/9/19.
//  Copyright © 2019 Greg Ledbetter. All rights reserved.
//

import UIKit

class FiveDayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHighTemp: UILabel!
    @IBOutlet weak var lblLowTemp: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    
}


class FiveDayTableViewController: UITableViewController {
    var fiveDayForecast: FiveDayCityForecast?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 500;

        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard self.fiveDayForecast != nil else {
            return 0
        }

        return 1
    }

    public func refresh() {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        logger?.log(category: .ui, message: "auto refresh of Location History UI.")
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.fiveDayForecast != nil else {
            return 0
        }
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
            as! FiveDayTableViewCell
        
        guard let fiveDay = self.fiveDayForecast else {
            logger?.log(category: .ui, message: "No valid five day forecast for FiveDayTableViewController.")
            return cell
        }
        let forecast = fiveDay.list[indexPath.row]
        
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "EEEE"
        cell.lblDay.text = dayFormat.string(from: forecast.dt)
        
        let dateFormat  = DateFormatter()
        dateFormat.dateFormat = "MMM dd"
        cell.lblDate.text = dateFormat.string(from: forecast.dt)
        
        cell.lblDescription.text = forecast.weather[0].description.localizedCapitalized
        cell.lblHighTemp.text = "High: \(Int(forecast.temp.max.rounded()))\u{00B0}"
        cell.lblLowTemp.text = "Low: \(Int(forecast.temp.min.rounded()))\u{00B0}"
        
        cell.imgWeather.image = UIImage(named: forecast.weather[0].icon)
        return cell
    }

}
