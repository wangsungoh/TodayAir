//
//  Station.swift
//  TodayAir
//
//  Created by ows on 2015. 9. 23..
//  Copyright © 2015년 ESKompany. All rights reserved.
//

import Foundation

class Station: NSObject, NSCoding {
    // MARK: Types
    struct CoderKeys {
        static let name = "nameKey"
        static let address = "addressKey"
        static let items = "itemKey"
        static let type = "typeKey"
        // TODO
        //static let locx = "locationXKey"
        //static let locy = "locationYKey"
    }
    
    // MARK: Properties
    let name:String
    let address:String
    let items:String
    let type:String
    // TODO
    //let locx:String
    //let locy:String

    // MARK: Initializers
    // TODO
    //init(name:String, address:String, items:String, type:String, locx:String, locy:String) {
    init(name:String, address:String, items:String, type:String) {

        self.name = name
        self.address = address
        self.items = items
        self.type = type
        // TODO
        //self.locx = locx
        //self.locy = locy
    }
    
    // MARK: NSCoding
    required init(coder aDecoder:NSCoder) {
        self.name = aDecoder.decodeObjectForKey(CoderKeys.name) as! String
        self.address = aDecoder.decodeObjectForKey(CoderKeys.address) as! String
        self.items = aDecoder.decodeObjectForKey(CoderKeys.items) as! String
        self.type = aDecoder.decodeObjectForKey(CoderKeys.type) as! String
        // TODO
        //self.locx = aDecoder.decodeObjectForKey(CoderKeys.locx) as! String
        //self.locy = aDecoder.decodeObjectForKey(CoderKeys.locy) as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: CoderKeys.name)
        aCoder.encodeObject(self.address, forKey: CoderKeys.address)
        aCoder.encodeObject(self.items, forKey: CoderKeys.items)
        aCoder.encodeObject(self.type, forKey: CoderKeys.type)
        // TODO
        //aCoder.encodeObject(self.locx, forKey: CoderKeys.locx)
        //aCoder.encodeObject(self.locy, forKey: CoderKeys.locy)
    }
    
    func getStationName() -> String {
        return self.name
    }
}
