//
//  TodayViewController.swift
//  TodayAirWidget
//
//  Created by ows on 2015. 11. 20..
//  Copyright © 2015년 ESKompany. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var pm10Value: UILabel!
    @IBOutlet weak var khaiValue: UILabel!
    @IBOutlet weak var pm10Grade: UILabel!
    @IBOutlet weak var khaiGrade: UILabel!
    
    var airState: AirState!

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var currentSize:CGSize = self.preferredContentSize
        currentSize.height = 50.0
        self.preferredContentSize = currentSize
        getAirState()
    }
    
    func switchStatus(status:String) -> String {
        switch status {
        case "1":
            return "좋음"
        case "2":
            return "보통"
        case "3":
            return "나쁨"
        case "4":
            return "매우나쁨"
        default:
            return "데이터없음"
        }
    }

    func getAirState() {
        let defaults = NSUserDefaults(suiteName: "group.todayair")
        defaults?.synchronize()
        
        // Check for null value before setting
        if let stationName = defaults!.stringForKey("station") {
            print("sationName : \(stationName)")
            stationLabel.text = stationName
            print("\(__FILE__) \(__FUNCTION__) \(__LINE__)")

            self.airState = AirState(stationName: stationName)
            self.airState.setupReachability()
            self.airState.startNotifier()
            
            if self.airState.isNetworkReachable {
                print("Network Available")
            } else {
                print("Network not Available")
            }
            
            self.airState.getAirState()
            
            NSThread.sleepForTimeInterval(1)
            
            dispatch_async(dispatch_get_main_queue(), {
                print("self.airState.dataTime \(self.airState.dataTime)")
                print("self.airState.pm10Value \(self.airState.pm10Value)")
                print("self.airState.pm10Grade \(self.airState.pm10Grade)")
                print("self.airState.khaiValue \(self.airState.khaiValue)")
                print("self.airState.khaiGrade \(self.airState.khaiGrade)")
                self.pm10Value.text = self.airState.pm10Value
                self.khaiValue.text = self.airState.khaiValue
                self.pm10Grade.text = self.switchStatus(self.airState.pm10Grade)
                self.khaiGrade.text = self.switchStatus(self.airState.khaiGrade)
            });
        } else {
            print("sationName is null")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
