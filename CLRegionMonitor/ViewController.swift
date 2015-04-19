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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        locationManager.requestAlwaysAuthorization()
        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 24.813114, longitude: 67.049717), radius: 150, identifier: "PK")
        locationManager.startMonitoringForRegion(currRegion)
        
        self.mapView.delegate = self
        var circle = MKCircle(centerCoordinate: CLLocationCoordinate2D(latitude: 24.813114, longitude: 67.049717), radius: 150)
        circle.title = "Check Point"
        mapView.addOverlay(circle)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        else {
            return nil
        }
    }
    
    @IBAction func getLocation(sender: AnyObject) {
        let available = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
        locationManager.startUpdatingLocation()
        
        println("getLocation!")
    }
    
    @IBAction func regionMonitoring(sender: AnyObject) {
        locationManager.requestAlwaysAuthorization()
        
        println("regionMonitoring!")
        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 24.813114, longitude: 67.049717), radius: 150, identifier: "Karachi")
        locationManager.startMonitoringForRegion(currRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        /*geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            
        })*/
        //let placeMarks = data as [CLPlacemark]
        //let loc:CLPlacemark = placeMarks[0]
        self.mapView.centerCoordinate = location.coordinate
        println(location.coordinate.latitude)
        println(location.coordinate.longitude)
        //let addr = loc.locality
        //self.address.text = addr
        let reg = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 24.813114, longitude: 69.049717), 200, 200)
        self.mapView.setRegion(reg, animated: true)
        self.mapView.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered!")
        self.address.text = "Entered!"
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exited!")
        self.address.text = "Exited!"
    }
    
    /*func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("didStartMonitoringForRegion")
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("monitoringDidFailForRegion")
    }*/
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error")
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if state == CLRegionState.Inside{
            println("Inside")
        }
        else if state == CLRegionState.Outside{
            println("Outside")
        }
        else{
            println("Unknown")
        }
    }
    
}

