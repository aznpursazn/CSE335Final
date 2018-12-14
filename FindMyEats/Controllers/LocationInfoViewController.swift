//
//  LocationInfoViewController.swift
//  FindMyEats
//
//  Created by Kathy Nguyen on 10/13/18.
//  Copyright © 2018 Kathy Nguyen. All rights reserved.
//

import UIKit

class LocationInfoViewController: UIViewController {
    
    var lat:String?
    var long:String?
    var address:String?
    var name:String?
    var cuisine:String?
    var price:Int?
    var url:String?
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var latText: UILabel!
    @IBOutlet weak var urlText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.text = name
        longText.text = long
        latText.text = lat
        addressText.text = address
        categoryText.text = cuisine
        priceText.text = "\(price!)"
        urlText.text = url
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
