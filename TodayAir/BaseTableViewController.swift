//
//  BaseTableViewController.swift
//  TodayAir
//
//  Created by ows on 2015. 9. 24..
//  Copyright © 2015년 ESKompany. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    // MARK: Types
    
    static let nibName = "TableCell"
    static let tableViewCellIdentifier = "cellID"
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        tableView.registerNib(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: Configuration
    func configureCell(cell: UITableViewCell, forStation station: Station) {
        cell.textLabel?.text = station.name
        cell.detailTextLabel?.text = station.address
    }
}
