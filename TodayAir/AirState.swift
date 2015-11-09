//
//  HttpTask.swift
//  TodayAir
//
//  Created by ows on 2015. 9. 27..
//  copyright © 2015년 ESKompany. All rights reserved.
//

import UIKit
//import SwiftHTTP
//import SWXMLHash

class AirState: NSObject {
    let stationName:String
    var dataTime:String
    var so2Value:String
    var so2Grade:String
    var coValue:String
    var coGrade:String
    var o3Value:String
    var o3Grade:String
    var no2Value:String
    var no2Grade:String
    var pm10Value:String
    var pm10Grade:String
    var khaiValue:String
    var khaiGrade:String
    
    init(stationName:String) {
        self.stationName = stationName
        self.dataTime = "1975-01-01 00:00"
        self.so2Value = "-"
        self.so2Grade = "-"
        self.coValue = "-"
        self.coGrade = "-"
        self.o3Value = "-"
        self.o3Grade = "-"
        self.no2Value = "-"
        self.no2Grade = "-"
        self.pm10Value = "-"
        self.pm10Grade = "-"
        self.khaiValue = "-"
        self.khaiGrade = "-"
    }
    
    func getAirState() {
        var str:NSString?
        let station:NSString = self.stationName.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let url:NSString = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?ServiceKey=TEFV8XzRy%2BhyH22z0YPcWzVxFCf5%2ByFHYlIgLvTuW22t0gX114xCK7l6mLosVITly96Nlz7gje%2FumFjL95r96w%3D%3D&stationName=\(station)&dataTerm=DAILY&numOfRows=1"
        
        let request = HTTPTask()
        
        request.GET(url as String, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return
            }
            if let data = response.responseObject as? NSData {
                //print("opt finished: \(response.description)")
                str = NSString(data: data, encoding: NSUTF8StringEncoding)!
                //print("response: \(str!)")
                
                let xml = SWXMLHash.parse(str as! String)
                for elem in xml["response"]["body"]["items"]["item"] {

                    if (elem["dataTime"].element!.text != nil) {
                        self.dataTime = elem["dataTime"].element!.text!
                    } else {
                        self.dataTime = "-"
                    }
                    
                    if (elem["so2Value"].element!.text != nil) {
                        let _so2Value = elem["so2Value"].element!.text!
                        if (_so2Value == "-") {
                            self.so2Value = "-"
                            self.so2Grade = "-"
                        } else {
                            self.so2Value = _so2Value
                            if (elem["so2Grade"].element!.text != nil) {
                                self.so2Grade = elem["so2Grade"].element!.text!
                            } else {
                                self.so2Grade = "-"
                            }
                        }
                    } else {
                        self.so2Value = "-"
                        self.so2Grade = "-"
                    }
                    
                    if (elem["coValue"].element!.text != nil) {
                        let _coValue = elem["coValue"].element!.text!
                        if (_coValue == "-") {
                            self.coValue = "-"
                            self.coGrade = "-"
                        } else {
                            self.coValue = _coValue
                            if (elem["coGrade"].element!.text != nil) {
                                self.coGrade = elem["coGrade"].element!.text!
                            } else {
                                self.coGrade = "-"
                            }
                        }
                    } else {
                        self.coValue = "-"
                        self.coGrade = "-"
                    }
                    
                    if (elem["o3Value"].element!.text != nil) {
                        let _o3Value = elem["o3Value"].element!.text!
                        if (_o3Value == "-") {
                            self.o3Value = "-"
                            self.o3Grade = "-"
                        } else {
                            self.o3Value = _o3Value
                            if (elem["o3Grade"].element!.text != nil) {
                                self.o3Grade = elem["o3Grade"].element!.text!
                            } else {
                                self.o3Grade = "-"
                            }
                        }
                    } else {
                        self.o3Value = "-"
                        self.o3Grade = "-"
                    }
                    
                    if (elem["no2Value"].element!.text != nil) {
                        let _no2Value = elem["no2Value"].element!.text!
                        if (_no2Value == "-") {
                            self.no2Value = "-"
                            self.no2Grade = "-"
                        } else {
                            self.no2Value = _no2Value
                            if (elem["no2Grade"].element!.text != nil) {
                                self.no2Grade = elem["no2Grade"].element!.text!
                            } else {
                                self.no2Grade = "-"
                            }
                        }
                    } else {
                        self.no2Value = "-"
                        self.no2Grade = "-"
                    }
                    
                    if (elem["pm10Value"].element!.text != nil) {
                        let _pm10Value = elem["pm10Value"].element!.text!
                        if (_pm10Value == "-") {
                            self.pm10Value = "-"
                            self.pm10Grade = "-"
                        } else {
                            self.pm10Value = _pm10Value
                            if (elem["pm10Grade"].element!.text != nil) {
                                self.pm10Grade = elem["pm10Grade"].element!.text!
                            } else {
                                self.pm10Grade = "-"
                            }
                        }
                    } else {
                        self.pm10Value = "-"
                        self.pm10Grade = "-"
                    }
                    
                    if (elem["khaiValue"].element!.text != nil) {
                        let _khaiValue = elem["khaiValue"].element!.text!
                        if (_khaiValue == "-") {
                            self.khaiValue = "-"
                            self.khaiGrade = "-"
                        } else {
                            self.khaiValue = _khaiValue
                            if (elem["khaiGrade"].element!.text != nil) {
                                self.khaiGrade = elem["khaiGrade"].element!.text!
                            } else {
                                self.khaiGrade = "-"
                            }
                        }
                    } else {
                        self.khaiValue = "-"
                        self.khaiGrade = "-"
                    }
                }
            }
        })
    }
}
