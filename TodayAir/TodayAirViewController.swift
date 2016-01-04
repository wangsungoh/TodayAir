//
//  TodayAirViewController.swift
//  TodayAir
//
//  Created by ows on 2015. 9. 23..
//  Copyright © 2015년 ESKompany. All rights reserved.
//

import UIKit
import MBProgressHUD

class TodayAirViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    enum type_module {
        case TYPE_PM10
        case TYPE_SO2
        case TYPE_CO
        case TYPE_O3
        case TYPE_NO2
        case TYPE_KHAI
    }
    
    let pm10_str_contents_good = (
        "간만에 화창한 날이네요.\n산책을 즐겨보세요.",
        "공기가 맑아요.\n마음껏 숨을 쉬어 보세요.",
        "마스크는 다시 옷장으로 넣어 두세요.\n화창한 날입니다.",
        "창문을\n활짝 열어보세요.",
        "마음까지 맑아지는\n기분이네요.")
    
    let pm10_str_contents_normal = (
        "좋긴 하지만 기관지가 민감하신 분들은\n장시간 실외 활동은 자제하시는게 좋겠어요.",
        "오늘은\n보통이네요.",
        "그래도 움추려 드는것 보다는\n산책정도는 하시는게 어떨까요?",
        "환기정도는\n하셔도 될듯해요.",
        "기관지가 약하신 분들은\n외출은 자제해주세요.")
    
    let pm10_str_contents_bad = (
        "나쁘네요.\n마스크를 챙기시는게 좋겠어요.",
        "산책은 내일로\n미루시는게 어떨까요?",
        "환기는\n안하시는게 좋겠어요.",
        "사랑하는 사람과의 산책은\n내일로 미루시는게 어떨까요?",
        "지금 상태로 봐서는 건강하신 분도\n실외활동은 자제하시는게 좋겠는데요...")
    
    let pm10_str_contents_toobad = (
        "최악입니다.\n외출을 삼가주세요.",
        "공기가 너무 나쁩니다. \n중금속이 가득한걸까요??.",
        "마스크를 준비하시는게 어떨까요?",
        "정말로 안좋은 공기상태입니다.",
        "실외활동은 하지 마세요. 정말 나쁩니다.")
    
    let pm10_str_contents_nodata = (
        "데이터가 없네요.\n날이 너무 좋아서 그런가봐요.",
        "해당 관측소에서\n데이터를 가져올수 없습니다.",
        "네트워크 상태를 확인해보시겠어요?",
        "네트워크 상태가 불안정해 보여요.")
    
    var stations = [Station]()
    var airState: AirState!
    let defaults = NSUserDefaults.standardUserDefaults()
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var stationName:String?
    var screenSize:Int?
    
    let SCREEN_IPHONE_4 = 0
    let SCREEN_IPHONE_5 = 1
    let SCREEN_IPHONE_6 = 2
    let SCREEN_IPHONE_6P = 3
    
    let S_COLOR_NODATA:UInt = 0x1F5A8C
    let S_COLOR_GOOD:UInt = 0x25BA84
    let S_COLOR_NORMAL:UInt = 0x389ED1
    let S_COLOR_BAD:UInt = 0xE2B328
    let S_COLOR_TOOBAD:UInt = 0xE0452D

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var dataTimeLabel: UILabel!
    @IBOutlet weak var pm10TitelLabel: UILabel!
    @IBOutlet weak var pm10ValueLabel: UILabel!
    @IBOutlet weak var pm10GradeLabel: UILabel!
    @IBOutlet weak var khaiTitleLabel: UILabel!
    @IBOutlet weak var khaiValueLabel: UILabel!
    @IBOutlet weak var khaiGradeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var airkoreaTermsLabel: UILabel!
    @IBOutlet weak var coTitleLabel: UILabel!
    @IBOutlet weak var coValueLabel: UILabel!
    @IBOutlet weak var no2TitleLabel: UILabel!
    @IBOutlet weak var no2ValueLabel: UILabel!
    @IBOutlet weak var so2TitleLabel: UILabel!
    @IBOutlet weak var so2ValueLabel: UILabel!
    @IBOutlet weak var o3TitleLabel: UILabel!
    @IBOutlet weak var o3ValueLabel: UILabel!

    
    let adaptiveFontSize = (
        stationFontSize:40.0,
        khaivalueFontSize:100.0,
        khaititleFontSize:19.0,
        khaistateFontSize:32.0,
        updatetimeFontSize:16.0,
        pm10titleFontSize:22.0,
        pm10stateFontSize:28.0,
        pm10valueFontSize:76.0,
        pm10textFontSize:17.0,
        airkoreaTermsFontSize:11.0,
        othertitleFontSize:20.0,
        othervalueFontSize:24.0
    )
    
    let adaptieFontRatio = (
        iphone6p:1.2,
        iphone6:1.0,
        iphone5:0.87,
        iphone4:0.77
    )
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        var adap_font_ratio:Double = self.adaptieFontRatio.iphone6
        
        switch(self.screenSize) {
        case self.SCREEN_IPHONE_4?:
            adap_font_ratio = self.adaptieFontRatio.iphone4
            break
        case self.SCREEN_IPHONE_5?:
            adap_font_ratio = self.adaptieFontRatio.iphone5
            break
        case self.SCREEN_IPHONE_6?:
            adap_font_ratio = self.adaptieFontRatio.iphone6
            break
        case self.SCREEN_IPHONE_6P?:
            adap_font_ratio = self.adaptieFontRatio.iphone6p
            break
        default:
            break
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.dataTimeLabel.font = self.dataTimeLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.updatetimeFontSize * adap_font_ratio))
            self.so2TitleLabel.font = self.so2TitleLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othertitleFontSize * adap_font_ratio))
            self.so2ValueLabel.font = self.so2ValueLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othervalueFontSize * adap_font_ratio))
            self.coTitleLabel.font = self.coTitleLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othertitleFontSize * adap_font_ratio))
            self.coValueLabel.font = self.coValueLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othervalueFontSize * adap_font_ratio))
            self.o3TitleLabel.font = self.o3TitleLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othertitleFontSize * adap_font_ratio))
            self.o3ValueLabel.font = self.o3ValueLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othervalueFontSize * adap_font_ratio))
            self.no2TitleLabel.font = self.no2TitleLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othertitleFontSize * adap_font_ratio))
            self.no2ValueLabel.font = self.no2ValueLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.othervalueFontSize * adap_font_ratio))
            self.pm10TitelLabel.font = self.pm10TitelLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.pm10titleFontSize * adap_font_ratio))
            self.pm10ValueLabel.font = self.pm10ValueLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.pm10valueFontSize * adap_font_ratio))
            self.pm10GradeLabel.font = self.pm10GradeLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.pm10stateFontSize * adap_font_ratio))
            self.statusLabel.font = self.statusLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.pm10textFontSize * adap_font_ratio))
            self.khaiTitleLabel.font = self.khaiTitleLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.khaititleFontSize * adap_font_ratio))
            self.khaiValueLabel.font = self.khaiValueLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.khaivalueFontSize * adap_font_ratio))
            self.khaiGradeLabel.font = self.khaiGradeLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.khaistateFontSize * adap_font_ratio))
            self.stationLabel.font = self.stationLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.stationFontSize * adap_font_ratio))
            self.airkoreaTermsLabel.font = self.airkoreaTermsLabel.font.fontWithSize(CGFloat(self.adaptiveFontSize.airkoreaTermsFontSize * adap_font_ratio))
        });

        if let value = defaults.stringForKey("DefaultStation") {
            stationName = value
            
            dispatch_async(dispatch_get_main_queue(), {
                self.stationLabel.text = self.stationName
                
            });
            
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Loading"
            loadingNotification.detailsLabelText = "정보를 가져오고 있습니다."
            loadingNotification.showWhileExecuting(Selector("getAirState"), onTarget: self, withObject: nil, animated: true)

        } else {
            let alert = UIAlertController(title: "기본 지역 선택", message: "측정소가 선택되어 있지 않습니다.\n기본 지역을 선택해주세요.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "지역선택", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    self.goSelectStation()
                default:
                    break
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("introPresented") {
            
            showIntro()
            
            userDefaults.setBool(true, forKey: "introPresented")
            userDefaults.synchronize()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        loadingNotification.detailsLabelText = "정보를 가져오고 있습니다."
        loadingNotification.showWhileExecuting(Selector("getAirState"), onTarget: self, withObject: nil, animated: true)
    }

    @IBAction func searchStation(sender: AnyObject) {
        self.goSelectStation()
    }
    
    func goSelectStation() {
        let tableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTableViewController") as! MainTableViewController
        tableViewController.stations = self.stations
        
        navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
    
    func switchStatusColor(status:String) -> UIColor {
        switch status {
        case "1":
            return UIColorFromRGB(S_COLOR_GOOD)
        case "2":
            return UIColorFromRGB(S_COLOR_NORMAL)
        case "3":
            return UIColorFromRGB(S_COLOR_BAD)
        case "4":
            return UIColorFromRGB(S_COLOR_TOOBAD)
        default:
            return UIColorFromRGB(S_COLOR_NODATA)
        }
    }
    
    func switchStatusString(status:String) -> String {
        let diceRoll = Int(arc4random_uniform(4))
        switch status {
        case "1":
            switch diceRoll {
            case 0:
                return self.pm10_str_contents_good.0
            case 1:
                return self.pm10_str_contents_good.1
            case 2:
                return self.pm10_str_contents_good.2
            case 3:
                return self.pm10_str_contents_good.3
            default:
                return self.pm10_str_contents_good.0
            }
        case "2":
            switch diceRoll {
            case 0:
                return self.pm10_str_contents_normal.0
            case 1:
                return self.pm10_str_contents_normal.1
            case 2:
                return self.pm10_str_contents_normal.2
            case 3:
                return self.pm10_str_contents_normal.3
            default:
                return self.pm10_str_contents_normal.0
            }
        case "3":
            switch diceRoll {
            case 0:
                return self.pm10_str_contents_bad.0
            case 1:
                return self.pm10_str_contents_bad.1
            case 2:
                return self.pm10_str_contents_bad.2
            case 3:
                return self.pm10_str_contents_bad.3
            default:
                return self.pm10_str_contents_bad.0
            }
        case "4":
            switch diceRoll {
            case 0:
                return self.pm10_str_contents_toobad.0
            case 1:
                return self.pm10_str_contents_toobad.1
            case 2:
                return self.pm10_str_contents_toobad.2
            case 3:
                return self.pm10_str_contents_toobad.3
            default:
                return self.pm10_str_contents_toobad.0
            }
        default:
            switch diceRoll {
            case 0:
                return self.pm10_str_contents_nodata.0
            case 1:
                return self.pm10_str_contents_nodata.1
            case 2:
                return self.pm10_str_contents_nodata.2
            case 3:
                return self.pm10_str_contents_nodata.3
            default:
                return self.pm10_str_contents_nodata.3
            }
        }
    }
    
    func getAirState() {
        self.airState = AirState(stationName: self.stationName!)
        self.airState.setupReachability()
        self.airState.startNotifier()
        
        let shared = NSUserDefaults(suiteName: "group.todayair")
        shared?.setObject(self.stationName, forKey: "station")
        print("\(__FILE__) \(__FUNCTION__) \(__LINE__) self.stationName:\(self.stationName!)")
        
        shared?.synchronize()

        if self.airState.isNetworkReachable {
            print("Network Available")
        } else {
            print("Network not Available")
            let alert = UIAlertController(title: "인터넷 연결 실패", message: "네트워크 상태가 불안정합니다.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "확인", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    break
                default:
                    break
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        self.airState.getAirState()
        
        NSThread.sleepForTimeInterval(1)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.dataTimeLabel.text = self.airState.dataTime
            
            self.so2ValueLabel.text = self.airState.so2Value
            self.so2ValueLabel.textColor = self.switchStatusColor(self.airState.so2Grade)
            
            self.coValueLabel.text = self.airState.coValue
            self.coValueLabel.textColor = self.switchStatusColor(self.airState.coGrade)
            
            self.o3ValueLabel.text = self.airState.o3Value
            self.o3ValueLabel.textColor = self.switchStatusColor(self.airState.o3Grade)
            
            self.no2ValueLabel.text = self.airState.no2Value
            self.no2ValueLabel.textColor = self.switchStatusColor(self.airState.no2Grade)

            self.pm10ValueLabel.text = self.airState.pm10Value
            self.pm10ValueLabel.textColor = self.switchStatusColor(self.airState.pm10Grade)
            self.pm10GradeLabel.text = self.switchStatus(self.airState.pm10Grade)
            self.pm10GradeLabel.textColor = self.switchStatusColor(self.airState.pm10Grade)
            
            self.statusLabel.text = self.switchStatusString(self.airState.pm10Grade)
            
            self.khaiValueLabel.text = self.airState.khaiValue
            self.khaiGradeLabel.text = self.switchStatus(self.airState.khaiGrade)

            self.topView.backgroundColor = self.switchStatusColor(self.airState.khaiGrade)
        });
    }
    
    @IBAction func showTerms(sender: AnyObject) {
       showIntro()
    }
    
    func showIntro() {
        let stb = UIStoryboard(name: "Intro", bundle: nil)
        let intro = stb.instantiateViewControllerWithIdentifier("intro") as! BWWalkthroughViewController
        let intro01 = stb.instantiateViewControllerWithIdentifier("intro01")
        let intro02 = stb.instantiateViewControllerWithIdentifier("intro02")
        let intro03 = stb.instantiateViewControllerWithIdentifier("intro03")
        let intro04 = stb.instantiateViewControllerWithIdentifier("intro04")

        intro.delegate = self
        intro.addViewController(intro01)
        intro.addViewController(intro02)
        intro.addViewController(intro03)
        intro.addViewController(intro04)

        self.presentViewController(intro, animated: true, completion: nil)
    }
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
