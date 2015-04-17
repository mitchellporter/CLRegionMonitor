//
//  ViewController.swift
//  CLRegionMonitor
//
//  Created by Panaswift on 4/16/15.
//  Copyright (c) 2015 Panaswift. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getLocation(sender: AnyObject) {
        let available = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func regionMonitoring(sender: AnyObject) {
        locationManager.requestAlwaysAuthorization()
        
        println("regionMonitoring!")
        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 24.813114, longitude: 67.049717), radius: 200, identifier: "KhadaMarket")
        locationManager.startMonitoringForRegion(currRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            let placeMarks = data as [CLPlacemark]
            let loc:CLPlacemark = placeMarks[0]
            println(location.coordinate)
            self.mapView.centerCoordinate = location.coordinate
            let addr = loc.locality
            self.address.text = addr
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            self.mapView.setRegion(reg, animated: true)
            self.mapView.showsUserLocation = true
        })
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered!")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exited!")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error")
    }
    
}

