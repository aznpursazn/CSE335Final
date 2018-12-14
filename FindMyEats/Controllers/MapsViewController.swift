//
//  MapsViewController.swift
//  FindMyEats
//
//  Created by Kathy Nguyen on 10/12/18.
//  Copyright © 2018 Kathy Nguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var manager:CLLocationManager!
    
    var city:String!
    var lat:CLLocationDegrees!
    var long:CLLocationDegrees!
    var textSearch:String!
    
    var locals:locations = locations()
    
    @IBOutlet weak var mapTable: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locals.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath) as! MapTableViewCell
        let loc = locals.getInfo(row: indexPath.row)
        cell.cellLabel.text = loc.name
        //let city = cInfo.getInfo(index: indexPath.row)
        //cell.infoLabel.text = "Lat: " + city.lat!.stringValue + " Long: " + city.long!.stringValue
        return cell
    }
    
    
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self as? CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //        lat = manager.location?.coordinate.latitude
        //        long = manager.location?.coordinate.longitude
        //
        //        self.addMainLocation()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        //userLocation - there is no need for casting, because we are now using CLLocation object
        
        let userLocation:CLLocation = locations[0]
        
        lat = userLocation.coordinate.latitude
        
        long = userLocation.coordinate.longitude
        
        self.addMainLocation()
    }
    
    func addMainLocation() {
        let coordinates = CLLocationCoordinate2D( latitude: lat, longitude: long)
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
        
        self.map.setRegion(region, animated: true)
        
        // add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = city
        
        self.map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //NOTE: [AnyObject] changed to [CLLocation]
    
    @IBAction func searchArea(_ sender: Any) {
        //        // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyALlaNOL2dCg8BLhkLIMUX_-waUnkelteE
        //
        //        // EXAMPLE ABOVE
        //        // GOOGLE PLACE SEARCH
        //
        //        // TEST GOOGLE PLACE SEARCH REQUIRES PAYMENT
        //        //        let na = "name"
        //        //        let ra = 4.5
        //        //        let la = 32.45
        //        //        let lo = -123.4
        //        //        let pa = "place types, shopping"
        //        //        let pr = 3
        //        //        let vi = "vicinity"
        //        //        let ho = true
        //        //
        //        //        let a = location(n: na, lat: la, long: lo, h: ho, pt: pa, p: pr, r: ra, v: vi)
        //        //
        //        //        self.locals.add(loc: a)
        //        //
        //        //        self.mapTable.reloadData()
        //
        //
        //        guard let search = searchTextField.text, !search.isEmpty else {
        //            let alert = UIAlertController(title: "Search Error", message: "Correct data input is required.", preferredStyle: .alert)
        //
        //            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //            self.present(alert, animated: true)
        //            return
        //        }
        //        textSearch = search
        //
        //        let urlAsString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + String(long) + "," + String(lat) + "&radius=1500&type=restaurant&keyword=" + textSearch + "&key=AIzaSyCzIYbLw0RCSF23UoXYXlWGcO0o3tCxbsc"
        //
        //        let url = URL(string: urlAsString)!
        //        let urlSession = URLSession.shared
        //
        //        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
        //            if (error != nil) {
        //                print(error!.localizedDescription)
        //            }
        //            var err: NSError?
        //
        //            let jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        //            if (err != nil) {
        //                print("JSON Error \(err!.localizedDescription)")
        //            }
        //
        //
        //            if let dictionary = jsonResult as? [String: AnyObject] {
        //
        //                let array:NSArray = dictionary["results"] as! NSArray
        //                //            print(array)
        //
        //                // TO FIX
        //                for item in array {
        //                    var info = item as? [String: AnyObject]
        //
        //                    let geometry = info?["geometry"]! as! NSDictionary
        //                    let loc = geometry["location"] as! NSDictionary
        //                    let open = info?["opening_hours"] as! NSDictionary
        //
        //
        //                    let name = info?["name"] as! String
        //                    let rate = info?["rating"] as! Double
        //                    let hours = open["open_now"] as! Bool
        //                    let vicinity = info?["vicinity"] as! String
        //                    let pricelvl = info?["price_level"] as! Int
        //
        //                    let types = info?["types"] as! NSArray
        //
        //                    let ln = loc["lat"] as! Double
        //                    let lt = loc["lng"]! as! Double
        //
        //                    //                print(types)
        //                    var placeTypes = ""
        //                    for type in types {
        //                        if !placeTypes.isEmpty {
        //                            placeTypes = placeTypes + ", " + (type as! String)
        //                        }
        //                        else {
        //                            placeTypes = type as! String
        //                        }
        //                    }
        //
        //                    let toAdd = location(n: name, lat: lt, long: ln, h: hours, pt: placeTypes, p: pricelvl, r: rate, v: vicinity)
        //                    self.locals.add(loc: toAdd)
        //
        //                    DispatchQueue.main.async {
        //                        self.mapTable.reloadData()
        //                    }
        //                }
        //            }
        //        })
        //
        //        jsonQuery.resume()
        
        let myURL = "https://developers.zomato.com/api/v2.1/geocode?lat=" + String(lat) + "&lon=" + String(long)
        let url = NSURL(string: myURL)!
        
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "user_key": "e33a299931e2886e714f8740d6c11444"
        ]
        
        let urlSession = URLSession(configuration: config)
        
        let myQuery = urlSession.dataTask(with: url as URL, completionHandler: {
            data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            var err: NSError?
            
            let jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            
            let dictionary = jsonResult as? [String: AnyObject]
            
            let array:NSArray = dictionary?["nearby_restaurants"] as! NSArray
            
            for item in array {
                var info = item as? [String: AnyObject]
                var restaurant = info?["restaurant"] as? NSDictionary
                let loc = restaurant?["location"] as? [String: AnyObject]
                
                let name = restaurant?["name"] as! String
                let latitude = loc?["latitude"] as! String
                let longitude = loc?["longitude"] as! String
                let address = loc?["address"] as! String
                let url = restaurant?["url"] as! String
                let price = restaurant?["price_range"] as! Int
                let cuisines = restaurant?["cuisines"] as! String
                
                let add = location(n: name, lat: latitude, long: longitude, a: address, c: cuisines, p: price, u: url)
                self.locals.add(loc: add)
                
                let coordinates = CLLocationCoordinate2D( latitude: Double(latitude) as! CLLocationDegrees, longitude: Double(longitude) as! CLLocationDegrees)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = name
                
                self.map.addAnnotation(annotation)
                
                DispatchQueue.main.async {
                    self.mapTable.reloadData()
                }
            }
        })
        myQuery.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapCell") {
            let selectedIndex: IndexPath = self.mapTable.indexPath(for: sender as! UITableViewCell)!
            let loc = locals.getInfo(row: selectedIndex.row)
            
            if let viewController: LocationInfoViewController = segue.destination as? LocationInfoViewController {
                viewController.name = loc.name
                viewController.lat = loc.latitude
                viewController.long = loc.longitude
                viewController.price = loc.price
                viewController.url = loc.url
                viewController.cuisine = loc.cuisine
                viewController.address = loc.address
            }
        }
    }
}
