//
//  ResultsTableController.swift
//  TodayAir
//
//  Created by ows on 2015. 9. 24..
//  Copyright © 2015년 ESKompany. All rights reserved.
//

import UIKit

class ResultsTableController: BaseTableViewController {
    // MARK: Properties
    
    var filteredStations = [Station]()
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BaseTableViewController.tableViewCellIdentifier)!
        
        let station = filteredStations[indexPath.row]
        configureCell(cell, forStation: station)
        
        return cell
    }
}
