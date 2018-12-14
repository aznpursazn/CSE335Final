//
//  locations.swift
//  FindMyEats
//
//  Created by Kathy Nguyen on 10/13/18.
//  Copyright © 2018 Kathy Nguyen. All rights reserved.
//

import Foundation
class location {
    
    var latitude:String?
    var longitude:String?
    var address:String?
    var name:String?
    var cuisine:String?
    var price:Int?
    var url:String?
    
    init(n: String, lat: String, long: String, a: String, c: String, p: Int, u: String) {
        name = n
        latitude = lat
        longitude = long
        address = a
        cuisine = c
        price = p
        url = u
    }
}

class locations  {
    var locations:[location] = []
    
    func getCount() -> Int {
        return locations.count
    }
    
    func getInfo(row: Int) -> location {
        return locations[row]
    }
    
    func add(loc: location) {
        locations.append(loc)
    }
}
