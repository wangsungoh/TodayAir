//
//  DetailViewController.swift
//  TodayAir
//
//  Created by ows on 2015. 9. 26..
//  Copyright © 2015년 ESKompany. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    static let storyboardName = "Main"
    static let viewControllerIdentifier = "DetailViewController"
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var station: Station!
    
    @IBOutlet weak var labelStationName: UILabel!
    @IBOutlet weak var labelStationAddress: UILabel!
    @IBOutlet weak var labelStationItems: UILabel!
    @IBOutlet weak var labelStationType: UILabel!
    
    // MARK: Initialization
    class func detailViewControllerForStation(station: Station) -> DetailViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(DetailViewController.viewControllerIdentifier) as! DetailViewController
        
        viewController.station = station
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false

        // Do any additional setup after loading the view.
        dispatch_async(dispatch_get_main_queue(), {
            self.labelStationName.text = self.station.name
            self.labelStationAddress.text = self.station.address
            self.labelStationItems.text = self.station.items
            self.labelStationType.text = self.station.type
        });
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToRoot(sender: AnyObject) {
        defaults.setObject(self.station.name, forKey: "DefaultStation")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
