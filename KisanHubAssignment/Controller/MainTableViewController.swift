//
//  MainTableViewController.swift
//  KisanHubAssignment
//
//  Created by Pran Kishore on 15/01/18.
//  Copyright © 2018 Pran Kishore. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    let manager = WaetherDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let sv = UIViewController.displaySpinner(onView: self.tableView)
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            self.manager.downloadAllRecords()
            self.manager.pathForExportedCSVFile()
            DispatchQueue.main.async { // 2
                UIViewController.removeSpinner(spinner: sv)
                self.tableView.reloadData() // 3
            }
        }
        
    }

    @IBAction func btnClickShare(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [manager.exportURL], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manager.arrWeatherData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let record = manager.arrWeatherData[indexPath.row]
        cell.textLabel?.text = "\(record.region_code),\(record.weather_param)"
        cell.detailTextLabel?.text = "\(record.year),\(record.entityValue)"
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIViewController {
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
